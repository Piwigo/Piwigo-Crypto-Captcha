<div class="column-flex crypto-captcha-block">

  <label for="captcha_code">
    {if $CRYPTO.captcha_type=='string'}
      {'Enter code'|translate}
    {else}
      {'Solve equation'|translate}
    {/if}
  </label>

  <div class="row-flex input-container">
    <i class="gallery-icon-lock"></i>
    <input type="text"
           name="captcha_code"
           id="captcha_code"
           style="width:{$CRYPTO.code_length}em;"
           maxlength="{$CRYPTO.code_length}">
    <i class="gallery-icon-eye togglePassword" onclick="toggleInputVisibility('captcha_code')"></i>
  </div>

  <div class="row-flex captcha-images" style="align-items:center; margin-top:0.5em;">
    <img id="captcha"
         src="{$CRYPTO_PATH}securimage/securimage_show.php"
         alt="CAPTCHA Image"
         style="max-height:40px; vertical-align:top;">

    <a href="#"
       id="captcha_refresh"
       onclick="document.getElementById('captcha').src = '{$CRYPTO_PATH}securimage/securimage_show.php?' + Math.random(); return false;"
       style="margin-left:0.5em;">
      <img src="{$CRYPTO_PATH}template/refresh_{$CRYPTO.button_color}.png"
           style="max-height:30px; vertical-align:bottom;">
    </a>
  </div>

  <!-- ERROR MESSAGE -->
  <p class="error-message"
     style="margin-top:10px; color:#d9534f;">
    <i class="gallery-icon-attention-circled"></i>
    {'must not be empty'|translate}
  </p>

</div>

{literal}
<script>
  // Toggle show/hide for CAPTCHA input
  function toggleInputVisibility(id) {
    var input = document.getElementById(id);
    if (input.type === 'password') {
      input.type = 'text';
    } else {
      input.type = 'password';
    }
  }

  // LiveValidation equivalent
  if (typeof LiveValidation !== 'undefined') {
    var captcha_code = new LiveValidation("captcha_code", { onlyOnSubmit: true, insertAfterWhatNode: "captcha_refresh" });
    captcha_code.add(Validate.Presence, { failureMessage: "{'Invalid Captcha'|translate}" });
  }
</script>
{/literal}
