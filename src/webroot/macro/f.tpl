    </div> 
    <!-- bd end --> 
   </div> 
   <!-- bdw end --> 

   <div id="ftw"> 
    <div id="ft"> 
     <div class="ftbox"> 
      <h3>用户帮助</h3> 
      <ul>
	   {foreach from=$confLinkList item=one}
	   {if $one.type eq 'bangzhu'}
       <li><a rel="nofollow" href="{$one.link}" target="{$one.target}">{$one.label}</a></li> 
	   {/if}
	   {/foreach}
      </ul> 
     </div> 
     <div class="ftbox"> 
      <h3>获取更新</h3> 
      <ul> 
	   {foreach from=$confLinkList item=one}
	   {if $one.type eq 'gengxin'}
       <li><a rel="nofollow" href="{$one.link}" target="{$one.target}">{$one.label}</a></li> 
	   {/if}
	   {/foreach}
      </ul> 
     </div> 
     <div class="ftbox"> 
      <h3>商务合作</h3> 
      <ul> 
	   {foreach from=$confLinkList item=one}
	   {if $one.type eq 'hezuo'}
       <li><a rel="nofollow" href="{$one.link}" target="{$one.target}">{$one.label}</a></li> 
	   {/if}
	   {/foreach}
      </ul> 
     </div> 
     <div class="ftbox"> 
      <h3>公司信息</h3> 
      <ul> 
	   {foreach from=$confLinkList item=one}
	   {if $one.type eq 'gongsi'}
       <li><a rel="nofollow" href="{$one.link}" target="{$one.target}">{$one.label}</a></li> 
	   {/if}
	   {/foreach}
      </ul> 
     </div> 
     <div class="ftbox service"> 
      <i class="hotline"></i> 
      <p class="desc">客服电话(免长途费)</p> 
      <p class="num">{$confSite.kefuTel}</p> 
      <p class="time">{$confSite.kefuTime}</p> 
     </div> 
     <div class="copyright"> 
      <p>&copy;<span>2013</span><a href="{$app_name}/">朝夕团购</a> {$confSite.hostUrl} <a href="http://www.miibeian.gov.cn/" target="_blank">{$confSite.icp}</a></p> 
     </div> 
     <ul class="cert cf"> 
      <li class="cert__item cert__item--record"><a title="备案信息" href="{$confSite.icpReferUrl}" hidefocus="true" target="_blank">备案信息</a></li> 
	  <!-- 
      <li class="cert__item cert__item--alipay"><a rel="nofollow" title="支付宝特约商家">支付宝特约商家</a></li> 
      <li class="cert__item cert__item--tenpay"><a rel="nofollow" href="http://union.tenpay.com/cgi-bin/trust_mch/ShowTrustMchInfo.cgi?uin=1209236701&amp;uin_type=1" title="财付通诚信商家" hidefocus="true" target="_blank">财付通诚信商家</a></li> 
      <li class="cert__item cert__item--knet"><a title="可信网站认证" rel="nofollow">可信网站</a></li> 
	  -->
     </ul> 
    </div> 
   </div> 
  </div> 
  <!-- doc end --> 

{if $withAccountSetting}
<div id="dialog-overlay" class="dialog-overlay"></div>
<div id="setting-mobile" class="dialog-wrapper" style="display: none; width: 400px; position: fixed; left: 400px; top: 125px; z-index: 102;">
  <div class="mt-dialog">
   <h3 class="head">更换手机号码<span class="close">关闭</span></h3>
   <div class="body">
	<p class="error" style="display:none">&nbsp;</p> 
    <div class="mobile-rebind-dialog"> 
     <form id="settings-mobile-rebind-form" method="POST" action="{$app_name}/my/mobilerebind.htm" class="common-form"> 
      <div class="field-group mobile"> 
       <label for="mobile-input">新手机号</label> 
       <input name="mobile" id="mobile-input" class="f-text" value="" /> 
       <span id="mobile-tip" class="tip"></span> 
      </div> 
      <div class="field-group mobile f-block-verify"> 
       <input type="button" id="mobile-verify" class="small-normal-button" value="获取验证码" />
       <span class="hint inline-hint">（将发送到新手机上）</span> 
	   <span id="mobile-verify-tip" class="tip"></span> 
      </div> 
      <div class="field-group mobile f-block-verify"> 
       <label for="verify-code">验证码</label> 
       <input name="verifycode" id="verify-code" class="f-text f-text-verify" value="" /> 
       <span id="verify-tip" class="tip"></span> 
       <span class="hint">注意：绑定新手机号将会清空所有已绑定的手机号</span> 
      </div> 
      <div class="field-group operate"> 
       <input type="submit" class="form-button" value="绑定" /> 
       <a href="javascript:void(0)" class="close inline-link">取消</a> 
      </div> 
     </form> 
    </div> 
   </div>
  </div>
</div><!-- /#setting-mobile -->

<div id="setting-email" class="dialog-wrapper" style="display: none; width: 400px; position: fixed; left: 400px; top: 125px; z-index: 102;">
  <div class="mt-dialog">
   <h3 class="head">更换邮箱地址<span class="close">关闭</span></h3>
   <div class="body">
	<p class="error" style="display:none">&nbsp;</p> 
    <div class="email-rebind-dialog"> 
     <form id="settings-email-rebind-form" method="POST" action="{$app_name}/my/emailrebind.htm" class="common-form"> 
      <div class="field-group"> 
       <label for="email-input">新邮箱地址</label> 
       <input name="email" id="email-input" class="f-text" value="" /> 
       <span id="email-tip" class="tip"></span> 
      </div> 
      <div class="field-group operate"> 
       <input type="submit" class="form-button" value="绑定" /> 
       <a href="javascript:void(0)" class="close inline-link">取消</a> 
      </div> 
     </form> 
    </div> 
   </div>
  </div>
</div><!-- /#setting-email -->

<div id="setting-nickname" class="dialog-wrapper" style="display: none; width: 400px; position: fixed; left: 400px; top: 125px; z-index: 102;">
  <div class="mt-dialog">
   <h3 class="head">更换昵称<span class="close">关闭</span></h3>
   <div class="body">
	<p class="error" style="display:none">&nbsp;</p> 
    <div class="nickname-rebind-dialog"> 
     <form id="settings-nickname-rebind-form" method="POST" action="{$app_name}/my/nicknamereset.htm" class="common-form"> 
      <div class="field-group"> 
       <label for="nickname-input">昵称</label> 
       <input name="nickname" id="nickname-input" class="f-text" value="" /> 
       <span id="nickname-tip" class="tip"></span> 
      </div> 
      <div class="field-group operate"> 
       <input type="submit" class="form-button" value="修改" /> 
       <a href="javascript:void(0)" class="close inline-link">取消</a> 
      </div> 
     </form> 
    </div> 
   </div>
  </div>
</div><!-- /#setting-nickname -->

<div id="setting-password" class="dialog-wrapper" style="display: none; width: 400px; position: fixed; left: 400px; top: 125px; z-index: 102;">
  <div class="mt-dialog">
   <h3 class="head">修改密码<span class="close">关闭</span></h3>
   <div class="body">
	<p class="error" style="display:none">&nbsp;</p> 
    <div class="password-rebind-dialog"> 
     <form id="settings-password-rebind-form" method="POST" action="{$app_name}/my/passwordreset.htm" class="common-form"> 
      <div class="field-group"> 
       <label for="password-input">当前密码</label> 
       <input type="password" name="pwdOld" id="password-old" class="f-text" value="" /> 
       <span id="password-tip" class="tip"></span> 
      </div> 
      <div class="field-group"> 
       <label for="password-input">新密码</label> 
       <input type="password" name="pwd" id="password-input" class="f-text" value="" /> 
       <span id="password-tip" class="tip"></span> 
      </div> 
      <div class="field-group"> 
       <label for="password2-input">确认密码</label> 
       <input type="password" name="pwd2" id="password2-input" class="f-text" value="" /> 
       <span id="password2-tip" class="tip"></span> 
      </div> 
      <div class="field-group operate"> 
       <input type="submit" class="form-button" value="修改" /> 
       <a href="javascript:void(0)" class="close inline-link">取消</a> 
      </div> 
     </form> 
    </div> 
   </div>
  </div>
</div><!-- /#setting-password -->
{/if}

{literal}
<script id="tplItemOne" type="text/x-template">
	<#macro tplItemOne data>
	<ul>
	<#list data.ll as one>
	<li class="dropdown-menu__item"><a class="deal-link" 
		href="${one.url}" title="${one.des}" target="_blank" rel="nofollow">
		<img class="deal-cover" src="${one.imageIndex}" width="80" height="50" /></a>
		<h5 class="deal-title">
		<a class="deal-link" href="${one.url}" title="${one.des}" target="_blank" rel="nofollow">${one.des}</a>
		</h5>
		<a class="deal-price-w" target="_blank" href="#" >
			<em class="deal-price">&yen;${one.price}</em>
			<span class="old-price">${one.priceMarket}</span>
		</a>
	</li>
	</#list>
	<#if (data.withClose)>
	<li class="opt">
		<a href="${data.app_name}/cart.htm">前往购物车&raquo;</a>
		<span class="close"><img src="${data.app_name}/image/bg-subscribe-close.png" /></span>
	</li>
	</#if>
	</#macro>
	</ul> 
</script>
{/literal}
 </body>
</html>