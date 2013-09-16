{include file="../macro/h.tpl"}
<div id="content" class="settings-box settings-form-wrapper"> 
   <div class="dashboard"> 
    <ul> 
     <li><a href="{$app_name}/orderlist/all.htm" >团购订单</a></li> 
	 <!-- 
     <li><a href="{$app_name}/orderlist/feebacklist.htm" >我的评价</a></li> 
     <li><a href="{$app_name}/my/growth.htm" >我的成长</a></li> 
	 -->
     <li class="current"><a href="{$app_name}/my/setting.htm" >账户设置</a></li> 
    </ul> 
   </div> 
   <div class="mainbox mine"> 
    <ul class="filter cf"> 
     <li class="current"><a href="{$app_name}/my/setting.htm">基本信息</a></li> 
     <li><a href="{$app_name}/my/settingaddr.htm">收货地址</a></li> 
    </ul> 

  <form id="settings-info-container" method="get" action="#" class="common-form"> 
	{if $error}
     <div class="field-group field-group--error"> 
	 	<span class="inline-tip">{$error}</span>
     </div> 
	{/if}
	{if $msg}
     <div class="field-group"> 
	 	<span class="inline-tip">{$msg}</span>
     </div> 
	{/if}
   <div class="field-group f-display"> 
	<label>手机号：</label> 
	<span class="text">{if $s_user.mobile}{$s_user.mobile}{else}<span class="setting-no-fill">未填写</span>{/if}</span>
	<a class="settings-mobile-rebind inline-link" href="javascript:void(0)">更换</a> 
   </div> 
   <div class="field-group f-display"> 
	<label>邮　箱：</label> 
	<span class="text mail">{if $s_user.email}{$s_user.email}{else}<span class="setting-no-fill">未填写</span>{/if}</span> 
	<a class="settings-email-rebind inline-link" href="javascript:void(0)">更换</a> 
   </div> 
   <div class="field-group f-display"> 
	<label>昵　称：</label> 
	<span class="text">{if $s_user.nickname}{$s_user.nickname}{else}<span class="setting-no-fill">未填写</span>{/if}</span>
	{if !$s_user.thirdPart}
	<a class="settings-nickname-reset inline-link" href="javascript:void(0)">修改</a> 
	{/if}
   </div>
   {if $s_user.thirdPart}
    <div class="field-group f-display"> 
	<label>其他登录：</label> 
	<span class="text">{$s_user.thirdPart}</span>
	</div>
   {else}
   <div class="field-group f-display f-password"> 
	<label>密　码：</label> 
	<span class="text">••••••</span>
	<a class="settings-password-reset inline-link" href="javascript:void(0)">修改</a> 
   </div>
   {/if}
  </form>

   </div> 
</div>

{include file="../macro/my-sidebar.tpl"}
{include file="../macro/f.tpl"}