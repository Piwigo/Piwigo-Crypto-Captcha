<?php
defined('CRYPTO_PATH') or die('Hacking attempt!');

// Enable error reporting
// error_reporting(E_ALL);
// ini_set('display_errors', 1);

// Include the common CAPTCHA setup file
$conf['cryptographp']['template'] = 'comment';
include(CRYPTO_PATH.'include/common.inc.php');

// Register event handlers
add_event_handler('loc_end_picture', 'add_crypto');
add_event_handler('loc_end_picture_info_comments', 'add_crypto');
add_event_handler('user_comment_check', 'check_crypto', EVENT_HANDLER_PRIORITY_NEUTRAL, 2);

function add_crypto()
{
    global $template;
    
    // Log to confirm the function is being called
    // error_log("add_crypto function called.");
    
    // Use the prefilter to insert CAPTCHA in comments
    $template->set_prefilter('picture', 'prefilter_crypto');
    $template->set_prefilter('picture_info_comments', 'prefilter_crypto');
}

function prefilter_crypto($content)
{
    // Adjust to match the comment text area placeholder exactly
    $search = '<textarea class="form-control" name="content" id="contentid" rows="5" cols="50">{$comment_add.CONTENT}</textarea>';
    $replacement = $search . "\n{\$CRYPTO.parsed_content}";

    // Log if the search string is found for easier debugging
    if (strpos($content, $search) === false) {
      // error_log("Search string '{$search}' not found in template.");
    } else {
      // error_log("Search string found, applying replacement.");
    }

    return str_replace($search, $replacement, $content);
}

function check_crypto($action, $comment)
{
    global $conf, $page;

    // Include the securimage class
    include_once(CRYPTO_PATH . 'securimage/securimage.php');
    $securimage = new Securimage();

    // Perform CAPTCHA validation
    if (empty($_POST['captcha_code']) || $securimage->check($_POST['captcha_code']) == false) {
        $page['errors'][] = l10n('Invalid Captcha');
        
        // Ensure it rejects the comment by returning 'reject'
        return 'reject';
    }

    // If CAPTCHA is valid, proceed normally
    return $action;
}
