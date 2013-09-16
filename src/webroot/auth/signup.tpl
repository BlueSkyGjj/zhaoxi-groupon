{include file="../macro/h.tpl"}
<div id="content"> 
   <div class="mainbox"> 
    <div class="head-section cf"> 
     <ul id="reg-type"> 
      <li class="current"> <a class="email-trigger" href="javascript:void(0);"><i></i><span></span>邮箱注册</a> </li> 
      <li> <a class="mobile-trigger" href="javascript:void(0);"><i></i><span></span>手机注册</a> </li> 
     </ul> 
     <span class="login-guide">已有账号？<a href="login.htm">登录</a></span> 
    </div> 
    <form id="email-signup-form" action="{$app_name}/signuppost.htm" 
		autocomplete="off" method="post" class="common-form"> 
     <div class="field-group field-group--type field-email"> 
      <label for="email">邮箱</label> 
      <input type="text" name="email" id="email" class="f-text" autocomplete="off" value="" placeholder="邮箱" /> 
	  <span class="inline-tip" id="signup-tip" style="display: none;"></span>
     </div>

     <div class="field-group field-group--type field-mobile" style="display: none;"> 
      <label for="mobile">手机号码</label> 
      <input type="text" name="mobile" id="mobile" class="f-text" autocomplete="off" value="" placeholder="手机号码" /> 
	  <!-- 
      <p class="verify-mobile"> <input type="button" class="btn-normal btn-small" id="btn-get-sms" value="免费获取短信验证码" /> </p> 
	  -->
     </div>
	 <!-- 
     <div class="field-group"> 
      <label for="sms">短信验证码</label> 
      <input type="text" name="sms" id="sms" class="f-text" autocomplete="off" value="" /> 
     </div> 
	 -->

     <div class="field-group"> 
      <label for="pwd">创建密码</label> 
      <input type="password" name="pwd" id="pwd" class="f-text" autocomplete="off" /> 
     </div> 
     <div class="field-group"> 
      <label for="pwd2">确认密码</label> 
      <input type="password" name="pwd2" id="pwd2" class="f-text" autocomplete="off" /> 
     </div> 

	  {if $error}
     <div class="field-group field-group--highlight"> 
	 	<span class="inline-tip">{$error}</span>
     </div> 
	  {/if}

     <div class="field-group operate"> 
      <input type="submit" class="btn" name="commit" value="注册" /> 
      <input type="hidden" name="city_code" value="{$city_code}" /> 
     </div> 
    </form> 
  
   </div> 
  </div>
{include file="../macro/f.tpl"}