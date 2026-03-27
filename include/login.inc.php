<?php
defined('CRYPTO_PATH') or die('Hacking attempt!');

$conf['cryptographp']['template'] = 'login';
include(CRYPTO_PATH . 'include/common.inc.php');

/********************************************************************
 * 1. Inject CAPTCHA container into Bootstrap Darkroom login page
 ********************************************************************/
add_event_handler('loc_end_page_header', 'crypto_login_add_prefilter');

function crypto_login_add_prefilter()
{
    global $template;
    try {
        $template->set_prefilter('identification', 'crypto_login_prefilter');
    } catch (Throwable $t) {
        file_put_contents(CRYPTO_PATH . 'debug.log', date('Y-m-d H:i:s') . " - prefilter error: {$t->getMessage()}\n", FILE_APPEND);
    }
}

function crypto_login_prefilter($content)
{
    // Simply wrap {$CRYPTO.parsed_content} in a Bootstrap Darkroom container
    $captcha_block = <<<HTML
<div class="form-group crypto-captcha-block">
  <div class="col-sm-offset-2 col-sm-4">
    {\$CRYPTO.parsed_content}
  </div>
</div>
HTML;

    $search  = '#(<input[^>]*type="submit"[^>]*>)#i';
    $replace = $captcha_block . "\n$1";

    $new = @preg_replace($search, $replace, $content, 1);
    return $new === null ? $content : $new;
}

/********************************************************************
 * 2. Block login completely if CAPTCHA fails
 ********************************************************************/
add_event_handler('try_log_user', 'crypto_login_block_login', EVENT_HANDLER_PRIORITY_NEUTRAL, 4);

function crypto_login_block_login($success, $username, $password, $remember_me)
{
    global $conf, $page;

    if (empty($conf['cryptographp']['activate_on']['login'])) {
        return $success;
    }

    include_once(CRYPTO_PATH . 'securimage/securimage.php');
    $securimage = new Securimage();

    $captcha_ok = !empty($_POST['captcha_code']) && $securimage->check($_POST['captcha_code']);

    if (!$captcha_ok) {
        $page['errors'][] = l10n('Invalid Captcha');
        if (isset($_SESSION)) {
            unset($_SESSION['pwg_uid'], $_SESSION['pwg_username'], $_SESSION['pwg_groups'], $_SESSION['connected_with']);
        }
        if (!empty($_COOKIE[session_name()])) {
            setcookie(session_name(), '', time() - 3600, '/');
        }
        return false;
    }

    return $success;
}
