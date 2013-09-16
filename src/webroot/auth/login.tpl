{include file="../macro/h.tpl"}
<div id="content" class="pg-login"> 
   <div class="mainbox" > 
	 <div id="signup">
     <div class="head-section cf"> 
     <ul id="reg-type"> 
      <li class=""> <a class="qq-trigger" href="{$app_name}/qqconnect_login.do" target="_blank"><i></i><span></span>QQ</a> </li> 
      <li class="change-trigger"> <a class="email-trigger" href="javascript:void(0);"><i></i><span></span>邮箱</a> </li> 
      <li class="change-trigger current"> <a class="mobile-trigger" href="javascript:void(0);"><i></i><span></span>手机</a> </li> 
     </ul> 
	 </div>
	 </div>
	<!-- 
    <h3 class="mainbox__title" >会员登录</h3> 
	-->
    <div class="signup-section" > 
	<!-- 
     <div class="login-type" > 
      <a href="/account/login?_nsmobilelogin=1" class="login-type__link" id="J-mobile-login-link"><i></i>手机动态码登录</a> 
      <a href="/account/login" class="login-type__link login-type__link--normal" id="J-login-link" style="display:none"><i></i>普通方式登录</a> 
     </div> 
	-->
     <form id="login-form" action="{$app_name}/loginpost.htm" method="post" class="common-form"> 
	  <input type="hidden" id="loginType" name="loginType" value="email" />
	  {if $r_referUrl}
	  <input type="hidden" name="referUrl" value="{$r_referUrl}" />
	  {else}
	  <input type="hidden" name="referUrl" value="{$app_name}/index.htm" />
	  {/if}
      <div class="field-group" > 
       <label id="loginTypeLabel" for="mobile">手机</label> 
       <input type="text" id="mobile" class="f-text" name="mobile" placeholder="手机号/邮箱/QQ号码" value="" /> 
	   <span class="inline-tip" id="signup-tip" style="display: none;"></span>
      </div> 
      <div class="field-group" > 
       <label for="login-password">密码</label> 
       <input type="password" id="pwd" class="f-text" name="pwd" /> 
       <a tabindex="-1" href="{$app_name}/getpwd.htm" class="inline-link" >忘记密码？</a> 
      </div> 
      <div class="field-group field-group--auto-login" > 
       <input type="checkbox" name="remember_username" id="remember-username" class="f-check" /> 
       <label class="normal" for="remember-username">记住账号</label> 
       <input type="checkbox" name="autologin" id="autologin" class="f-check" /> 
       <label class="normal" for="autologin">下次自动登录</label> 
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

      <div class="field-group field-group--ops" > 
       <input type="submit" class="btn" value="登录" /> &nbsp;
	   <br />
	   <br />
	   <a href="signup.htm" class="normal-button" >注册</a> 
      </div> 
     </form> 
    </div> 
    <div class="oauth-section" > 
	 <!-- 
     <div class="switch-area" > 
      <span>尚未注册？</span> 
      <a href="signup.htm" class="normal-button" >免费注册</a> 
     </div> 
     <h3 >用合作网站账号登录</h3> 
     <ul id="open-auth" class="open-auth cf"> 
      <li ><i class="qq"></i><a class="min" href="{$app_name}/qqconnect_login.do" target="_blank" >QQ</a></li> 
     </ul> 
	 -->
    </div><!-- /.oauth-section -->
   </div> 
  </div>
{include file="../macro/f.tpl"}