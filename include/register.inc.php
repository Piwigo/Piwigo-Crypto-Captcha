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
  // Remove unwanted <li> wrappers from plugin.tpl output
  $clean = str_replace(array('<li>', '</li>', '<br>'), '', '{$CRYPTO.parsed_content}');

  // Wrap captcha block in the correct theme structure
  $captcha_block = "<div class=\"col-sm-offset-2 col-sm-4 crypto-captcha-block\">\n$clean\n</div>";

  // Inject BEFORE the submit button
  $search = '#(<input[^>]*type="submit"[^>]*>)#i';
  $replace = $captcha_block . "\n$1";

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
