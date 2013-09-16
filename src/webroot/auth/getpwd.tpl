{include file="../macro/h.tpl"}
<div id="content"> 
   <div class="mainbox"> 
    <h3 class="mainbox__title">找回密码</h3> 
    <form id="getpwd-form" method="post" action="{$app_name}/getpwdpost.htm" class="common-form"> 
	 <input type="hidden" name="logintype" id="login-type" value="email" />
     <div class="field-group"> 
      <label for="reset-email">邮箱/手机号</label> 
      <input type="text" name="email" class="f-text" id="reset-email" placeholder="" value="" /> 
	  <span class="inline-tip" id="reset-email-tip"></span>
     </div> 
     <div class="field-group captcha"> 
      <label for="captcha">验证码</label> 
      <input type="text" id="captcha" class="f-text" name="captcha" autocomplete="off" /> 
      <img height="30px" width="60px" class="signup-captcha-img" id="signup-captcha-img" src="verify.img" /> 
      <a id="btn-refresh-img" tabindex="-1" class="captcha-refresh inline-link" href="javascript:void(0)">看不清楚？换一张</a> 
     </div> 

	  {if $error}
     <div class="field-group field-group--error"> 
	 	<span class="inline-tip">{$error}</span>
     </div> 
	  {/if}

	  {if $ok}
     <div class="field-group field-group--ok"> 
	 	<span class="inline-tip">{$ok}</span>
     </div> 
	  {/if}

     <div class="field-group"> 
      <input type="submit" class="form-button" value="找回密码" /> 
     </div> 
    </form> 
   </div> 
  </div>
{include file="../macro/f.tpl"}