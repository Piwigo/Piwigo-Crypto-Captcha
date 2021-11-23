<?php
/*
Plugin Name: Crypto Captcha
Version: auto
Description: Add a captcha to register, comment, GuestBook and ContactForm pages (thanks to P@t)
Plugin URI: auto
Author: Mistic
Author URI: http://www.strangeplanet.fr
Has Settings: true
*/

defined('PHPWG_ROOT_PATH') or die('Hacking attempt!');

if (basename(dirname(__FILE__)) != 'CryptograPHP')
{
  add_event_handler('init', 'cryptocaptcha_error');
  function cryptocaptcha_error()
  {
    global $page;
    $page['errors'][] = 'Crypto Captcha folder name is incorrect, uninstall the plugin and rename it to "CryptograPHP"';
  }
  return;
}

if (mobile_theme())
{
  return;
}

define('CRYPTO_PATH' ,    PHPWG_PLUGINS_PATH . 'CryptograPHP/');
define('CRYPTO_ADMIN',    get_root_url() . 'admin.php?page=plugin-CryptograPHP');


add_event_handler('init', 'crypto_init');

if (defined('IN_ADMIN'))
{
  add_event_handler('get_admin_plugin_menu_links', 'crypto_plugin_admin_menu');
}
else
{
  add_event_handler('loc_end_section_init', 'crypto_document_init', EVENT_HANDLER_PRIORITY_NEUTRAL+30);
  add_event_handler('loc_begin_register', 'crypto_register_init', EVENT_HANDLER_PRIORITY_NEUTRAL+30);
}


// plugin init
function crypto_init()
{
  global $conf;
  $conf['cryptographp'] = safe_unserialize($conf['cryptographp']);
  
  load_language('plugin.lang', CRYPTO_PATH);
}


// modules
function crypto_document_init()
{
  global $conf, $pwg_loaded_plugins, $page;
  
  if (!is_a_guest() && $conf['cryptographp']['guest_only'])
  {
    return;
  }

  if (script_basename() == 'picture' and $conf['cryptographp']['activate_on']['picture'])
  {
    include(CRYPTO_PATH . 'include/picture.inc.php');
  }
  else if (isset($page['section']))
  {
    if (
      script_basename() == 'index' &&
      $page['section'] == 'categories' && isset($page['category']) &&
      isset($pwg_loaded_plugins['Comments_on_Albums']) &&
      $conf['cryptographp']['activate_on']['category']
      )
    {
      include(CRYPTO_PATH . 'include/category.inc.php');
    }
    else if ($page['section'] == 'contact' && $conf['cryptographp']['activate_on']['contactform'])
    {
      include(CRYPTO_PATH . 'include/contactform.inc.php');
    }
    else if ($page['section'] == 'guestbook' && $conf['cryptographp']['activate_on']['guestbook'])
    {
      include(CRYPTO_PATH . 'include/guestbook.inc.php');
    }
  }
}
function crypto_register_init()
{
  global $conf;

  if ($conf['cryptographp']['activate_on']['register'])
  {
    include(CRYPTO_PATH . 'include/register.inc.php');
  }
}


// admin
function crypto_plugin_admin_menu($menu)
{
  $menu[] = array(
    'NAME' => 'Crypto Captcha',
    'URL' => CRYPTO_ADMIN,
    );
  return $menu;
}