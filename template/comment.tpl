<div class="column-flex crypto-captcha-block" style="margin-top:15px;">

  <!-- LABEL -->
  <label for="captcha_code" class="form-label" style="margin-bottom:6px;">
    {if $CRYPTO.captcha_type=='string'}
      {'Enter code'|translate}
    {else}
      {'Solve equation'|translate}
    {/if}
  </label>

  <!-- CAPTCHA LINE -->
  <div class="captcha-row"
       style="
         display:flex;
         align-items:center;
         gap:12px;
         flex-wrap:wrap;
         row-gap:10px;
       ">

    <!-- CAPTCHA IMAGE (larger & responsive) -->
    <img id="captcha"
         src="{$CRYPTO_PATH}securimage/securimage_show.php"
         alt="CAPTCHA Image"
         style="
           height:auto;
           max-height:55px;
           width:auto;
           border-radius:4px;
         ">

    <!-- REFRESH BUTTON -->
    <a href="#"
       onclick="document.getElementById('captcha').src = '{$CRYPTO_PATH}securimage/securimage_show.php?' + Math.random(); return false;"
       style="display:flex; align-items:center;">
      <img src="{$CRYPTO_PATH}template/refresh_{$CRYPTO.button_color}.png"
           alt="Refresh"
           style="
             height:32px;
             width:auto;
             cursor:pointer;
           ">
    </a>

    <!-- LOCK ICON -->
    <i class="gallery-icon-lock" style="font-size:20px;"></i>

    <!-- INPUT -->
    <input type="text"
           id="captcha_code"
           name="captcha_code"
           maxlength="{$CRYPTO.code_length}"
           class="form-control"
           style="
             width: {$CRYPTO.code_length + 2}em;
             max-width:160px;
           ">

    <!-- TOGGLE VISIBILITY ICON -->
    <i class="gallery-icon-eye togglePassword"
       onclick="toggleInputVisibility('captcha_code')"
       style="cursor:pointer; font-size:20px;"></i>

  </div>

  <!-- ERROR -->
  <p class="error-message" style="margin-top:10px; color:#d9534f;">
    <i class="gallery-icon-attention-circled"></i>
    {'must not be empty'|translate}
  </p>

</div>

{literal}
<script>
function toggleInputVisibility(id) {
  var input = document.getElementById(id);
  input.type = (input.type === 'password') ? 'text' : 'password';
}
</script>
{/literal}
