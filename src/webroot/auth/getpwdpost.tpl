{include file="../macro/h.tpl"}
<div id="content"> 
   <div class="mainbox"> 
    {if $sendemail}<h3 class="mainbox__title">已经发送密码找回邮件，请查收！</h3>{/if}
	{if $sendsms}
	<h3 class="mainbox__title">已经发送短信，请输入手机验证码</h3>
    <form id="getpwdre-form" method="post" action="{$app_name}/getpwdrepost.htm" class="common-form"> 
	 <input type="hidden" name="uid" value="{$r_uid}" />
     <div class="field-group"> 
      <label for="reset-email">手机验证码</label> 
      <input type="text" name="verifycode" class="f-text" id="verifycode" placeholder="" value="" /> 
	  <span class="inline-tip" id="reset-verifycode-tip"></span>
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
      <input type="submit" class="form-button" value="重置密码" /> 
     </div> 
    </form> 
	{/if}
   </div> 
  </div>
{include file="../macro/f.tpl"}