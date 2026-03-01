<div class="column-flex crypto-captcha-block" style="width:100%;">

  <!-- LABEL -->
  <label for="captcha_code" class="form-label" style="margin-bottom:6px;">
    {if $CRYPTO.captcha_type=='string'}
      {'Enter code'|translate}
    {else}
      {'Solve equation'|translate}
    {/if}
  </label>

  <!-- RESPONSIVE WRAPPER -->
  <div class="captcha-row"
       style="
         display:flex;
         flex-wrap:wrap;
         align-items:center;
         gap:12px;
         row-gap:12px;
         width:100%;
       ">

    <!-- CAPTCHA IMAGE -->
    <img id="captcha"
         src="{$CRYPTO_PATH}securimage/securimage_show.php"
         alt="CAPTCHA Image"
         style="
           height:auto;
           max-height:55px;
           width:auto;
           border-radius:4px;
           flex-shrink:0;
         ">

    <!-- REFRESH ICON -->
    <a href="#"
       onclick="document.getElementById('captcha').src = '{$CRYPTO_PATH}securimage/securimage_show.php?' + Math.random(); return false;"
       style="display:flex; align-items:center; flex-shrink:0;">
      <img src="{$CRYPTO_PATH}template/refresh_light.png"
           alt="Refresh CAPTCHA"
           style="height:32px; width:auto; cursor:pointer;">
    </a>

    <!-- LOCK ICON 
    <i class="gallery-icon-lock"
       style="font-size:20px; flex-shrink:0;"></i> -->

    <!-- CAPTCHA INPUT -->
    <input type="text"
           id="captcha_code"
           name="captcha_code"
           maxlength="6"
           style="
             flex:1 1 160px;
             min-width:120px;
             max-width:100%;
             background-color:#303030;
             color:#D6D6D6;
             border:1px solid #303030;
             border-radius:4px;
             padding:6px 10px;
             height:40px;
             font-size:1rem;
           ">
  </div>

  <!-- ERROR -->
  <p class="error-message"
     style="margin-top:10px; color:#d9534f;">
    <i class="gallery-icon-attention-circled"></i>
    {'must not be empty'|translate}
  </p>

</div>
