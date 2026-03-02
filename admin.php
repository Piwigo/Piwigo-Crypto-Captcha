<?php
defined('CRYPTO_PATH') or die('Hacking attempt!');

global $pwg_loaded_plugins;
$loaded = array(
  'contactform' => isset($pwg_loaded_plugins['ContactForm']),
  'category' => isset($pwg_loaded_plugins['Comments_on_Albums']),
  'guestbook' => isset($pwg_loaded_plugins['GuestBook']),
  'easycaptcha' => isset($pwg_loaded_plugins['EasyCaptcha']),
  );

if ($loaded['easycaptcha'])
{
  $page['warnings'][] = l10n('We detected that EasyCaptcha plugin is available on your gallery. Both plugins can be used at the same time, but you should not under any circumstances activate both of them on the same page.');
}

if ( isset($_POST['submit']))
{
  if (!isset($_POST['activate_on'])) $_POST['activate_on'] = array();
  
  $conf['cryptographp'] = array(
    'activate_on' => array(
      'picture'     => in_array('picture', $_POST['activate_on']),
      'category'    => in_array('category', $_POST['activate_on']) || !$loaded['category'],
      'register'    => in_array('register', $_POST['activate_on']),
      'contactform' => in_array('contactform', $_POST['activate_on']) || !$loaded['contactform'],
      'guestbook'   => in_array('guestbook', $_POST['activate_on']) || !$loaded['guestbook'],
      // add login here
    'login'       => in_array('login', $_POST['activate_on']),
      ),
    'comments_action' => $_POST['comments_action'],
    'guest_only'      => isset($_POST['guest_only']),
    'theme'           => $_POST['theme'],
    'captcha_type'    => $_POST['captcha_type'],
    'case_sensitive'  => 'false', //not used, problem with some fonts
    'width'           => (int)$_POST['width'], 
    'height'          => (int)$_POST['height'],
    'perturbation'    => (float)$_POST['perturbation'],
    'background'      => $_POST['background'],
    'bg_color'        => $_POST['bg_color'],
    'bg_image'        => $_POST['bg_image'],
    'code_length'     => (int)$_POST['code_length'],
    'text_color'      => $_POST['text_color'],
    'num_lines'       => (float)$_POST['num_lines'],
    'line_color'      => $_POST['line_color'],
    'noise_level'     => (float)$_POST['noise_level'],
    'noise_color'     => $_POST['noise_color'],
    'ttf_file'        => $_POST['ttf_file'],
    'button_color'    => $_POST['button_color'],
    );
  
  conf_update_param('cryptographp', $conf['cryptographp']);
  $page['infos'][] = l10n('Information data registered in database');
}

$presets = array(
  'bluenoise' =>  array('perturbation'=>0.25, 'background'=>'color', 'bg_image'=>'', 'bg_color'=>'ffffff', 'text_color'=>'0000ff', 'num_lines'=>2, 'line_color'=>'0000ff', 'noise_level'=>2, 'noise_color'=>'0000ff', 'ttf_file'=>'AlteHassGroteskB'),
  'gray' =>       array('perturbation'=>1, 'background'=>'color', 'bg_image'=>'', 'bg_color'=>'ffffff', 'text_color'=>'8a8a8a', 'num_lines'=>2, 'line_color'=>'8a8a8a', 'noise_level'=>0.1, 'noise_color'=>'8a8a8a', 'ttf_file'=>'TopSecret'),
  'xcolor' =>     array('perturbation'=>0.5, 'background'=>'color', 'bg_image'=>'', 'bg_color'=>'ffffff', 'text_color'=>'random', 'num_lines'=>1, 'line_color'=>'ffffff', 'noise_level'=>2, 'noise_color'=>'ffffff', 'ttf_file'=>'Dread'),
  'pencil' =>     array('perturbation'=>0.8, 'background'=>'color', 'bg_image'=>'', 'bg_color'=>'9e9e9e', 'text_color'=>'363636', 'num_lines'=>0, 'line_color'=>'ffffff', 'noise_level'=>0, 'noise_color'=>'ffffff', 'ttf_file'=>'AllStar'),
  'ransom' =>     array('perturbation'=>0, 'background'=>'image', 'bg_image'=>'bg1.jpg', 'bg_color'=>'ffffff', 'text_color'=>'4a003a', 'num_lines'=>0, 'line_color'=>'ffffff', 'noise_level'=>0, 'noise_color'=>'ffffff', 'ttf_file'=>'ransom'),
  );


$template->assign(array(
  'crypto' => $conf['cryptographp'],
  'loaded' => $loaded,
  'fonts' => list_fonts(CRYPTO_PATH.'securimage/fonts'),
  'backgrounds' => list_backgrounds(CRYPTO_PATH.'securimage/backgrounds'),
  'PRESETS' => $presets,
  'CRYPTO_PATH' => CRYPTO_PATH,
  ));

$template->set_filename('plugin_admin_content', realpath(CRYPTO_PATH . 'template/admin.tpl'));
$template->assign_var_from_handle('ADMIN_CONTENT', 'plugin_admin_content');



function list_fonts($dir)
{
  $dir = rtrim($dir, '/');
  $dh = opendir($dir);
  $fonts = array();
  
  while (($file = readdir($dh)) !== false )
  {
    if ($file !== '.' && $file !== '..' && get_extension($file)=='ttf') 
    {
      $fonts[get_filename_wo_extension($file)] = $dir . '/' . $file;
    }
  }
  
  closedir($dh);
  return $fonts;
}

function list_backgrounds($dir)
{
  $dir = rtrim($dir, '/');
  $dh = opendir($dir);
  $backgrounds = array();
  
  while (($file = readdir($dh)) !== false )
  {
    if ($file !== '.' && $file !== '..')
    {
      $ext = get_extension($file);
      if ($ext=='jpg' || $ext=='png' || $ext=='jpeg' || $ext=='gif')
      {
        $backgrounds[$file] = $dir . '/' . $file;
      }
    }
  }
  
  closedir($dh);
  return $backgrounds;
}
