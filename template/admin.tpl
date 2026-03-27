{combine_css path=$CRYPTO_PATH|cat:'template/style.css'}

{combine_css path=$CRYPTO_PATH|cat:'template/colorpicker/colorpicker.css'}
{combine_script id='jquery.colorpicker' load='footer' path=$CRYPTO_PATH|cat:'template/colorpicker/colorpicker.js'}

{combine_css id='jquery.selectize' path="themes/default/js/plugins/selectize.{$themeconf.colorscheme}.css"}
{combine_script id='jquery.selectize' load='footer' path='themes/default/js/plugins/selectize.min.js'}


{footer_script}
var time = 0;

// colorpicker
$('.colorpicker-input')
  .ColorPicker({
    onSubmit: function(hsb, hex, rgb, el) { 
      $(el).val(hex); 
      $(el).ColorPickerHide(); 
    },
    onChange: function(hsb, hex, rgb, el) { 
      $(el).val(hex).trigger('change');
      changeColor(el, hex);
    },
    onBeforeShow: function () { 
      $(this).ColorPickerSetColor(this.value); 
    }
  })
  .bind('keyup', function() { 
    $(this).ColorPickerSetColor(this.value);
    changeColor(this, $(this).val());
  })
  .each(function() {
    changeColor(this, $(this).val());
  });
  
  
$('.button').click(function() {
  $(this).siblings('.button').removeClass('selected');
  $(this).addClass('selected');
  $('input[name='+ $(this).data('input') +']').val($(this).data('val')).trigger('change');
});

// change button
$('input[name=button_color]').change(function() {
  $('#reload').attr('src', '{$CRYPTO_PATH}template/refresh_'+ $(this).val() +'.png');
});

// apply a preset
$('input[name=theme]').change(function() {
  var id = $(this).val();
  
  for (key in presets[id]) {
    if ($('input[name="'+ key +'"]').attr('type') == 'radio') {
      $('input[name="'+ key +'"][value="'+ presets[id][key] +'"]').prop('checked', true).trigger('change', false);
    }
    else {
      $('input[name="'+ key +'"]').val(presets[id][key]).trigger('change', false);
    }
  }
  
  $('.colorpicker-input').each(function() {
    changeColor(this, $(this).val());
  });

  changePreview();
});

// toggle background type
$('input[name=background]').change(function() {
  $('li[id^=background]').hide().filter('#background-'+$(this).val()).show();
});

// display customization panel
$('.customize').click(function() {
  $('#theming').toggle();
});

// change theme to 'custom' if a parameter is changed
$('input.istheme').change(function(e, p) {
  if (p!==false) setThemeCustom();
});

// update the preview
$('input.preview').change(function(e, p) {
  if (p!==false) changePreview();
});
$('#reload').click(function() {
  changePreview();
});

// links for random color
$('a.random').click(function() {
  $(this).prev('label').children('input').val('random').trigger('change');
  changeColor($(this).prev('label').children('input'), 'random');
});

// multiselect
$('[name="activate_on[]"]').selectize({
  plugins: ['remove_button']
});

function setThemeCustom() {
  $('.button[data-input=theme]').removeClass('selected');
  $('input[name=theme]').val('custom');
}

function changePreview() {
  var now = (new Date()).getTime();

  if (now-time < 1000) {
    return;
  }
  time = now;
  
  options = new Array();
  str = '';
  
  $('input.preview:not([type=radio]), input[type=radio].preview:checked').each(function() {
    options[$(this).attr('name')] = $(this).val();
  });
  
  for (x in options) {
    str+= '&' + x + '=' + options[x];
  }
  $('#captcha').attr('src', '{$CRYPTO_PATH}securimage/securimage_preview.php?' + new Date().getTime() + str);
}

function changeColor(target, color) {
  if (color == 'random') {
    color = '808080';
  }
  if (parseInt(color, 16) > 16777215/2) {
    $(target).css('color', '#222');
  }
  else {
    $(target).css('color', '#ddd');
  }
  $(target).css('background', '#'+color)
}

var presets = {
{foreach from=$PRESETS key=name item=params}
  "{$name}" : {
  {foreach from=$params key=key item=value}
    "{$key}" : "{$value}",
  {/foreach}
  },
{/foreach}
};
{/footer_script}


{html_style}
{foreach from=$fonts item=path key=font}
@font-face {  
  font-family: '{$font}';  
  src: url({$path}) format("truetype");  
}
{/foreach}
{/html_style}


<div class="titrePage">
  <h2>Crypto Captcha</h2>
</div>

<form method="post" class="properties">
<fieldset>
  <legend>{'Configuration'|translate}</legend>
  
  <ul>
    <li>
      <b><label for="guest_only">{'Only for unauthenticated users'|translate}</label></b>
      <input type="checkbox" name="guest_only" id="guest_only" {if $crypto.guest_only}checked{/if}>
    </li>
    <li>
      <b>{'Activate on'|translate}</b>
      <select name="activate_on[]" multiple placeholder="{'Nowhere'|translate}">
        <option value="picture" {if $crypto.activate_on.picture}selected{/if}>{'Picture comments'|translate}</option>
        {if $loaded.category}<option value="category" {if $crypto.activate_on.category}selected{/if}>{'Album comments'|translate}</option>{/if}
        <option value="register" {if $crypto.activate_on.register}selected{/if}>{'Register form'|translate}</option>
        {if $loaded.contactform}<option value="contactform" {if $crypto.activate_on.contactform}selected{/if}>{'Contact form'|translate}</option>{/if}
        {if $loaded.guestbook}<option value="guestbook" {if $crypto.activate_on.guestbook}selected{/if}>{'Guestbook'|translate}</option>{/if}
        <!-- NEW LOGIN OPTION -->
        <option value="login" {if $crypto.activate_on.login}selected{/if}>{'Login form'|translate}</option>
      </select>
    </li>
    <li>
      <b>{'Comments action'|translate}</b>
      <label><input type="radio" name="comments_action" value="reject" {if $crypto.comments_action == 'reject'}checked="checked"{/if}> {'Reject'|translate}</label>
      <label><input type="radio" name="comments_action" value="moderate" {if $crypto.comments_action == 'moderate'}checked="checked"{/if}> {'Moderate'|translate}</label>
    </li>
    <li>
      <b>{'Captcha type'|translate}</b>
      <label><input type="radio" name="captcha_type" class="preview" value="string" {if $crypto.captcha_type == 'string'}checked="checked"{/if}> {'Random string'|translate}</label>
      <label><input type="radio" name="captcha_type" class="preview" value="math" {if $crypto.captcha_type == 'math'}checked="checked"{/if}> {'Simple equation'|translate}</label>
    </li>
    <!--<li>
      <b>{'Case sensitive'|translate}</b>
      <label><input type="radio" name="case_sensitive" value="false" {if $crypto.case_sensitive == 'false'}checked="checked"{/if}> {'No'|translate}</label>
      <label><input type="radio" name="case_sensitive" value="true" {if $crypto.case_sensitive == 'true'}checked="checked"{/if}> {'Yes'|translate}</label>
    </li>-->
    <li>
      <b>{'Code lenght'|translate}</b>
      <label><input type="text" name="code_length" class="preview" value="{$crypto.code_length}" size="6" maxlength="2"></label>
    </li>
    <li>
      <b>{'Width'|translate}</b>
      <label><input type="text" name="width" class="preview" value="{$crypto.width}" size="6" maxlength="3"> {'good value:'|translate} lenght&times;30</label>
    </li>
    <li>
      <b>{'Height'|translate}</b>
      <label><input type="text" name="height" class="preview" value="{$crypto.height}" size="6" maxlength="3"> {'good value:'|translate} lenght&times;12</label>
    </li>
    <li>
      <b>{'Button color'|translate}</b>
      <a class="button {if $crypto.button_color == 'dark'}selected{/if}" data-val="dark" data-input="button_color"><img src="{$CRYPTO_PATH}template/refresh_dark.png" alt="dark"></a>
      <a class="button {if $crypto.button_color == 'light'}selected{/if}" data-val="light" data-input="button_color"><img src="{$CRYPTO_PATH}template/refresh_light.png" alt="light"></a>
      <input type="hidden" name="button_color" value="{$crypto.button_color}">
    </li>
    <li>
      <b>{'Captcha theme'|translate}</b>
    {foreach from=$PRESETS key=preset item=params}
      <a class="button {if $crypto.theme == $preset}selected{/if}" data-val="{$preset}" data-input="theme"><img src="{$CRYPTO_PATH}template/presets/{$preset}.png" alt="{$preset}"></a>
    {/foreach}
      <input type="hidden" name="theme" value="{$crypto.theme}">
      <a class="customize">{'Customize'|translate}</a>
    </li>
  </ul>
  
  <fieldset {if $crypto.theme != 'custom'}style="display:none;"{/if} id="theming">
    <legend>{'Customize'|translate}</legend>
    
    <ul>
      <li>
        <b>{'Perturbation'|translate}</b>
        <label><input type="text" name="perturbation" value="{$crypto.perturbation}" class="istheme preview" size="6" maxlength="4"> {'range:'|translate} 0 - 1</label>
      </li>
      <li>
        <b>{'Background'|translate}</b>
        <label><input type="radio" name="background" class="istheme preview" value="color" {if $crypto.background == 'color'}checked="checked"{/if}> {'Color'|translate}</label>
        <label><input type="radio" name="background" class="istheme preview" value="image" {if $crypto.background == 'image'}checked="checked"{/if}> {'Image'|translate}</label>
      </li>
      <li id="background-color" {if $crypto.background != 'color'}style="display:none;"{/if}>
        <b>{'Background color'|translate}</b>
        <label><input type="text" name="bg_color" value="{$crypto.bg_color}" class="colorpicker-input istheme preview" size="6" maxlength="6"></label> 
        <a class="random" title="{'random'|translate}"><img src="{$CRYPTO_PATH}/template/arrow_switch.png"></a>
      </li>
      <li id="background-image" {if $crypto.background != 'image'}style="display:none;"{/if}>
        <b>{'Background image'|translate}</b>
      {foreach from=$backgrounds item=path key=background}
        <a class="button {if $crypto.bg_image == $background}selected{/if}" data-val="{$background}" data-input="bg_image"><img src="{$path}" alt="{$background}" style="width:120px;height:40px;"></a>
      {/foreach}
        <!-- <a class="button {if $crypto.bg_image == 'random'}selected{/if}" title="{'random'|translate}" data-val="random" data-input="bg_image"><img src="{$CRYPTO_PATH}/template/arrow_switch.png"></a> -->
        <input type="hidden" name="bg_image" value="{$crypto.bg_image}" class="istheme preview">
      </li>
      <li>
        <b>{'Text color'|translate}</b>
        <label><input type="text" name="text_color" value="{$crypto.text_color}" class="colorpicker-input istheme preview" size="6" maxlength="6"></label> 
        <a class="random" title="{'random'|translate}"><img src="{$CRYPTO_PATH}/template/arrow_switch.png"></a>
      </li>
      <li>
        <b>{'Lines density'|translate}</b>
        <label><input type="text" name="num_lines" value="{$crypto.num_lines}" class="istheme preview" size="6" maxlength="4"> {'range:'|translate} 0 - 10</label>
      </li>
      <li>
        <b>{'Lines color'|translate}</b>
        <label><input type="text" name="line_color" value="{$crypto.line_color}" class="colorpicker-input istheme preview" size="6" maxlength="6"></label> 
        <a class="random" title="{'random'|translate}"><img src="{$CRYPTO_PATH}/template/arrow_switch.png"></a>
      </li>
      <li>
        <b>{'Noise level'|translate}</b>
        <label><input type="text" name="noise_level" value="{$crypto.noise_level}" class="istheme preview" size="6" maxlength="4"> {'range:'|translate} 0 - 10</label>
      </li>
      <li>
        <b>{'Noise color'|translate}</b>
        <label><input type="text" name="noise_color" value="{$crypto.noise_color}" class="colorpicker-input istheme preview" size="6" maxlength="6"></label> 
        <a class="random" title="{'random'|translate}"><img src="{$CRYPTO_PATH}/template/arrow_switch.png"></a>
      </li>
      <li>
        <b>{'Font'|translate}</b>
      {foreach from=$fonts item=path key=font}
        <label style="font-family:{$font};" title="{$font}"><input type="radio" name="ttf_file" value="{$font}" {if $crypto.ttf_file == $font}checked="checked"{/if} class="istheme preview"> {$font}</label>
      {/foreach}
      </li>
    </ul>
    
    {'Tip: type "random" on a color field to have a random color'|translate}
  </fieldset>
  
  <ul style="margin-top:30px;">
    <li>
      <b>{'Preview'|translate}</b>
      <img id="captcha" src="{$CRYPTO_PATH}securimage/securimage_show.php" alt="CAPTCHA Image">
      <a href="#" onClick="return false;"><img id="reload" src="{$CRYPTO_PATH}template/refresh_{$crypto.button_color}.png"></a>
    </li>
  </ul>
  
</fieldset>

<p class="formButtons"><input class="submit" type="submit" value="{'Submit'|translate}" name="submit"></p>
</form>

<div style="text-align:right;">
  All free fonts from <a href="http://www.dafont.com" target="_blank">dafont.com</a> | 
  Powered by : <a href="http://www.phpcaptcha.org/" target="_blank"><img src="{$CRYPTO_PATH}template/logo.png" alt="Secureimage"></a>
</div>
