<!DOCTYPE html>
<html>
 <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
  <title>朝夕购 - 漯河朝夕购将打造漯河团购网第一品牌</title> 
  <meta name="description" content="朝夕购是漯河最大的B2C加团购网站，漯河地区目前唯一一家有正规资质团购网站，增值电信业务许可证 豫B2-20120026-7 朝夕购客服电话0395-3291777" /> 
  <meta name="keywords" content="朝夕购，漯河朝夕购，zhaoxigou，朝夕够，朝夕团购，爱趣，爱趣团购网，漯河首家电商，商城，漯河首家商城，漯河团购，团购，漯河网购，商城，漯河商城，漯河首家电商，首家电商，爱去，爱去团购，哎趣团购网，爱去团购网，爱去，漯河团购网，漯河团购网站，" /> 
  <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> 
  <link rel="stylesheet" href="{$app_name}/css/sidebar.css" /> 
  <script src="{$app_name}/public/json2.js"></script>
  <script src="{$app_name}/public/jquery-1.8.3.min.js"></script>
  <script src="{$app_name}/public/jquery.lazyload.min.js"></script>
  <script src="{$app_name}/public/lhgdialog.min.js"></script>
  <script language="javascript">
  var appname = '{$app_name}';
  var hostUrl = '{$confSite.hostUrl}';

  var getReferUrl = function(){
	var href = document.location.href;
	return appname + href.replace(hostUrl, '');
  };
  </script>
  <script src="{$app_name}/js/base.js"></script>
  <script src="{$app_name}/js/all.js"></script>
  {if $s_user}
  <script type="text/javascript" charset="utf-8">
  Conf.isLogin = true;
  </script>
  {/if}

  {foreach from=$cssList item=cssFile}
  <link rel="stylesheet" href="{$app_name}/css/{$cssFile}.css" /> 
  {/foreach}
  {foreach from=$jsList item=jsFile}
  <script src="{$app_name}/js/{$jsFile}.js"></script>
  {/foreach}
  <script src="{$app_name}/js/main.js"></script>

 </head> 
 <body{if $bodyId} id="{$bodyId}"{/if}> 
  {if $noGoTop}
  {else}
  <a id="J-go-top" class="go-top pngfix" hidefocus="true" 
	href="javascript:void(0)" style="bottom: 20px; left: 1121.5px; display: none;">回顶部</a>
	<!-- 
  <div id="stick-qrcode" class="stick-qrcode" style="top: 150px; left: 1121.5px;" > 
   <a class="stick-qrcode__wrap" href="#" hidefocus="true" > 
   <span class="stick-qrcode__img"></span> 
   <span class="close"></span>
   </a> 
  </div>

  <div class="stick-qrcode" style="display:none;"> 
   <a class="stick-qrcode__wrap" href="" hidefocus="true"> <span class="stick-qrcode__img"></span> <span class="close"></span> </a> 
  </div> 
	-->
  <!-- /#stick-qrcode -->
  {/if}

  <div id="doc" class=""> 
   <div id="hdw"> 
    <div id="hd"> 
     
	 {include file="h-top.tpl"}
	 <!-- /#site-top -->

     <div id="site-nav" class="site-nav"> 
      <div class="nav-wrapper cf"> 
       <ul class="nav"> 
        <li class="current"><a href="{$confSite.hostUrl}"><span class="nav-label">首页</span></a></li> 
		<!-- 
        <li><a href="#"><span class="nav-label">购物<i class="tip-new"></i></span></a></li> 
		-->
		{foreach from=$brandSpecialList item=one}
        <li><a href="{$app_name}/brandlist.htm?type={$one.code}"><span class="nav-label">{if $one.isSpecialNew}<i class="tip-new"></i>{/if}{$one.specialNavName}</span></a></li> 
		{/foreach}
        <li><a href="{$app_name}/giftlist.htm"><span class="nav-label">积分兑换</span></a></li> 
       </ul> 
       <ul class="user-info"> 
        <li class="info-item--begin"></li><li class="info-item item-auth-login">
			<a title="个人中心" rel="nofollow" class="info-link" href="{$app_name}/orderlist/all.htm"><span 
			id="J-login-user" class="nav-label">{if $s_user}{if $s_user.nickname}{$s_user.nickname}{elseif $s_user.mobile}{$s_user.mobile}{else}{$s_user.email}{/if}{/if}</span></a>
		</li><li 
			class="info-item info-item--cart dropdown dropdown--cart" id="J-my-cart-nav"> <a id="J-my-cart-toggle" 
				rel="nofollow" class="dropdown__toggle info-link" href="{$app_name}/cart.htm"><i class="my-cart-icon"></i>
				<span class="nav-label">购物车</span><i class="tri"></i></a>
			 <div id="J-my-cart-menu" class="dropdown-menu dropdown-menu--deal dropdown-menu--cart dropdown-menu--loading" style="display:none;">
			 </div><!-- /#J-my-cart-menu -->
		 </li><!--<li 
			class="info-item info-item--history dropdown" id="J-my-history">
		<a id="J-my-history-toggle" rel="nofollow" class="dropdown__toggle info-link" href="javascript:void(0)"><span class="nav-label">最近浏览</span><i class="tri"></i></a>
         <div id="J-my-history-menu" class="dropdown-menu dropdown-menu--deal dropdown-menu--history dropdown-menu--loading" style="display:none;">
		 </div>
		</li>--><!-- /#J-my-history-menu --><li class="info-item info-item--account dropdown  item-auth-login" id="J-my-account-nav"> <a id="J-my-account-toggle" rel="nofollow" 
			class="dropdown__toggle info-link" href="{$app_name}/orderlist/all.htm"><span 
			class="nav-label">我的团品</span><i class="tri"></i></a> 
         <ul id="J-my-account-menu" class="dropdown-menu dropdown-menu--text dropdown-menu--account account-menu" style="display:none" data-mtnode="Amymeituan"> 
          <li><a class="dropdown-menu__item first" rel="nofollow" href="{$app_name}/orderlist/all.htm">我的订单</a></li> 
          <li><a class="dropdown-menu__item last" rel="nofollow" href="{$app_name}/my/setting.htm">账户设置</a></li> 
          <li><a class="dropdown-menu__item last" rel="nofollow" href="{$app_name}/my/settingaddr.htm">收货地址</a></li> 
         </ul>
		</li><li class="info-item info-item--login item-auth-login">
			<a rel="nofollow" class="info-link" id="J-logout" href="javascript:void(0);"><span class="nav-label">退出</span></a>
		</li><li class="info-item info-item--login item-auth-nologin">
			<a rel="nofollow" class="info-link" id="J-login" href="{$app_name}/login.htm"><span class="nav-label">登录</span></a>
		</li><li class="info-item info-item--signup item-auth-nologin">
			<a rel="nofollow" class="info-link" href="{$app_name}/signup.htm"><span class="nav-label">注册</span></a>
		</li><li class="info-item--end"></li>
       </ul> 
      </div> 
     </div> 
    </div> 
   </div> 
   <div id="bdw" class="bdw"> 
    <div id="bd" class="cf"> 
     
     <div {if $commonError}{else}style="display:none;"{/if} id="J-common-tip" class="common-tip"> 
      <div class="content">{if $commonError}{$commonError}{/if}</div> 
      <span class="close">关闭</span> 
     </div> 
	 <!-- /.common-tip -->

