<?php
defined('CRYPTO_PATH') or die('Hacking attempt!');

$conf['cryptographp']['template'] = 'register';
include(CRYPTO_PATH.'include/common.inc.php');

add_event_handler('loc_end_page_header', 'add_crypto');
add_event_handler('register_user_check', 'check_crypto');

function add_crypto()
{
  global $template;
  $template->set_prefilter('register', 'prefilter_crypto');
}

function prefilter_crypto($content)
{
  $search = '#\(\{\'useful when password forgotten\'\|(@?)translate\}\)(\s*)((?:\{/if\})?)#i';
  $replace = '({\'useful when password forgotten\'|$1translate})$2$3'."\n".'{\$CRYPTO.parsed_content}';
  return preg_replace($search, $replace, $content);
}

function check_crypto($errors)
{
  include_once(CRYPTO_PATH.'securimage/securimage.php');
  $securimage = new Securimage();
  
  if ($securimage->check($_POST['captcha_code']) == false)
  {
    $errors[] = l10n('Invalid Captcha');
  }

  return $errors;
}