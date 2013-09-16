{include file="macro/h.tpl"}
<div id="content" class="pg-cart"> 
   <form action="{$app_name}/cartcheck.htm" method="post" id="J-cart-form" class="common-form"> 
    <div class="mainbox"> 
     <div class="cart-head cf"> 
      <div class="cart-status extra-offset"> 
       <i class="cart-head-icon"></i> 
       <span class="cart-title">我的购物车</span> 
       <div class="cart-count cf" title="您的购物车内有{$cartLlLength}种商品，共可放20种商品"> 
        <span class="bar"><span class="current" style="width:{$cartLlLengthPercent}%"></span></span> 
        <span class="number">{$cartLlLength}/20</span> 
       </div> 
      </div> 
      <div class="buy-process-info"> 
       <ol class="buy-process-bar"> 
        <li class="step-first current"> 1.查看购物车 <span class="highlight"></span> <span class="arrow"></span> </li> 
        <li> 2.选择支付方式 <span class="highlight"></span> <span class="arrow"></span> </li> 
        <li class="step-last"> 3.购买成功 </li> 
       </ol> 
       <div class="login-bar item-auth-nologin"> 
        <span>现在</span> 
        <a id="J-login-button" class="J-login-button" href="javascript:void(0)">登录</a> 
        <span>，您的购物车的商品将被永久保存</span> 
       </div>

	   <script id="login-window" type="text/x-template">
	   <div class="login-win">
		<div class="login-win-content">
			<div class="input-field">
				<label>用户名：</label>
				<input type="text" id="login-win-username" />
			</div>
			<div class="input-field">
				<label>密码：</label>
				<input type="password" id="login-win-pwd" />
			</div>
			<div class="input-field">
				<span class="error-tip" style="display: none;"></span>
			</div>
			<div class="other-login">
				<a href="{$app_name}/login.htm?referUrl={$app_name}/cart.htm">其他登录方式</a>
			</div>
		</div>
	   </div>
	   </script>
      </div> 
     </div> 
     <div class="table-section summary-table"> 
      <table cellspacing="0"> 
       <tbody>
        <tr> 
         <th width="auto" class="desc">项目</th> 
         <th width="70">状态</th> 
         <th width="170">类型/数量</th> 
         <th width="90" class="price">单价</th> 
         <th width="90" class="total">小计</th> 
         <th width="90"></th> 
        </tr>
		{foreach from=$s_cartLl item=one}
        <tr class="cart-item-tr"> 
         <td class="desc"> <a href="{$app_name}/deal/{$one.id}.htm" target="_blank" 
			title="{$one.des}" class="cf"><img src="{$one.imageIndex}" width="63" height="39" /><span>{$one.des}</span></a> </td> 
         <td>可购买</td> 
         <td class="quantity">
		   <a href="javascript:void(0)" class="minus minus-disabled" hidefocus="true" style=""></a>
		   <input type="text" class="f-text J-quantity" maxlength="4" value="{$one.num}" attr-prod-id="{$one.id}" />
		   <a href="javascript:void(0)" class="plus plus-disabled" hidefocus="true" style=""></a> 
		 </td> 
         <td class="price"> &yen;<span class="J-price">{$one.price}</span> </td> 
         <td class="money total"> &yen;<span class="J-total"></span>
		    <!-- 
			<br /><span class="delivery-fee">含运费￥8</span> 
			-->
		</td> 
         <td class="op"> <a class="delete delete-prod" href="javascript:void(0);" attr-prod-id="{$one.id}">删除</a> </td> 
        </tr> 
		{/foreach}

		<!-- 
        <tr> 
         <td></td> 
         <td colspan="4" class="extra-fee"> 
          <div class="cardcode-container" id="J-cardcode-container">
            代金券
           <span id="J-card-text"></span>： 
           <span class="inline-block money"> -&yen;<span id="J-card-value">0</span> </span> 
          </div> <input type="hidden" value="" name="cardcode" id="J-cardcode" /> </td> 
         <td></td> 
        </tr> 
		-->
        <tr> 
         <td></td> 
         <td></td> 
         <td colspan="3" class="extra-fee total-fee"> <strong>应付总额</strong>： <span class="inline-block money"> &yen;<strong id="J-cart-total"></strong> </span> </td> 
         <td></td> 
        </tr> 
       </tbody>
      </table> 
     </div> 

  <div id="deal-buy-delivery" class="blk-item delivery item-auth-login" style="display: none;"> 
   <h3>收货地址</h3> 
   <ul id="address-list" class="address-list"> 
    {foreach from=$addrList item=one key=key}
    <li{if $key eq 0}{/if}> <input type="radio" name="addr_id" id="deal-buy-address{$one.id}" value="{$one.id}" /> <label class="detail" for="deal-buy-address{$one.id}">{$one.des}</label> 
		<span><a href="#" class="cart-addr-del">删除</a></span>
	</li> 
    {/foreach}
    <li> <input type="radio" name="addr_id" id="deal-buy-address-other" value="other" /> <label class="detail" for="deal-buy-address-other">其他</label> 
	
	<div id="add-addr-field" class="address-field-list" style="display:none;"> 
    <div class="field-group field-group--small"> 
     <label for="address-field-province"><span class="required">*</span>省市区：</label> 
     <span data-widget="cascade"> 
		<select class="address-province" id="sel-prov" name="prov"> 
			<option value="">--省份--</option> 
			{foreach from=$provLl item=one}
			<option value="{$one.regionId}">{$one.regionName}</option> 
			{/foreach}
		</select> 
		<select class="address-city" id="sel-city" name="city"> 
			<option value="">--城市--</option> 
		</select> 
		<select class="address-district" id="sel-dist" name="dist"> 
			<option value="">--市区--</option> 
		</select> 
	 </span> 
    </div> 
    <div class="field-group field-group--small"> 
     <label for="address-field-address"><span class="required">*</span>街道地址：</label> 
     <input type="text" id="address-field-address" maxlength="60" size="60" name="addr" class="f-text address-detail" value="" /> 
    </div> 
    <div class="field-group field-group--small"> 
     <label for="address-field-zipcode"><span class="required">*</span>邮政编码：</label> 
     <input id="address-field-zipcode" class="f-text address-zipcode" type="text" maxlength="20" size="10" name="addr_code" value="" /> 
    </div> 
    <div class="field-group field-group--small"> 
     <label for="address-field-name"><span class="required">*</span>收货人姓名：</label> 
     <input type="text" id="address-field-name" maxlength="15" size="15" name="addr_name" class="f-text address-name" value="" /> 
    </div> 
    <div class="field-group field-group--small"> 
     <label for="address-field-phone"><span class="required">*</span>电话号码：</label> 
     <input id="address-field-phone" 
		class="f-text address-phone item-login-mobile" 
		type="text" maxlength="20" size="15" name="mobile" value="{if $s_user.mobile}{$s_user.mobile}{/if}" /> 
    </div> 
    <div class="field-group field-group--small"> 
		<input type="buttom" class="btn" id="btn-save-addr" value="保存">
    </div> 
   </div> 	
	</li> 
    <li class="selected"> 
		<input type="radio" name="addr_id" id="deal-buy-address-not-required" value="-1" checked="checked" /> <label class="detail" for="deal-buy-address-not-required">无需送货</label> 
		<div id="no-addr-field">
			<div class="field-group"> 
				<label for="addr_mobile">手机</label>
				<input type="text" id="addr_mobile" name="addr_mobile" class="f-text item-login-mobile" value="{if $s_user.mobile}{$s_user.mobile}{/if}" />
			</div>
			<div class="field-group"> 
				<label for="addr_msg">留言</label>
				<input type="text" id="addr_msg" name="addr_msg" class="f-text" />
			</div>
		</div>
	</li> 
   </ul> 
   <hr /> 
   <div id="deal-delivery-type" style="display: none;">
	   <h4>希望送货的时间</h4> 
	   <ul class="delivery-type"> 
		<li> <input id="deliveryType-1" checked="checked" value="1" type="radio" name="delivery_type" /> <label for="deliveryType-1">{$conf.delivery_time_des_1}</label> </li> 
		<li> <input id="deliveryType-2" value="2" type="radio" name="delivery_type" /> <label for="deliveryType-2">{$conf.delivery_time_des_2}</label> </li> 
		<li> <input id="deliveryType-3" value="3" type="radio" name="delivery_type" /> <label for="deliveryType-3">{$conf.delivery_time_des_3}</label> </li> 
	   </ul> 
	   <hr /> 
	   <h4>配送说明<span>（快递公司由商家根据情况选择，请不要指定。其他要求会尽量协调）</span></h4> 
		<div class="field-group"> 
			<input type="text" id="delivery_msg" name="delivery_msg" class="f-text" />
		</div>
	</div>
  </div>

	 <!-- 
     <div id="big-deal-tips" class="blk-item big-deal" style="display: none;"> 
      <h3>大额单购买提示</h3> 
      <p class="text tip">* 本单总价超过500元，已超出工行口令卡、招行大众版等的单次支付限额。查看<a href="http://help.alipay.com/lab/help_detail.htm?help_id=211661" target="_blank">更多银行支付限额详情</a></p> 
      <p class="text tip">* 您也可以先<a href="account/charge" target="_blank">为美团账户充值，</a>方便您的购买</p> 
     </div> 
	 -->

     <div class="form-submit">
	  <input type="button" class="btn item-auth-nologin" value="登录" onclick="document.location.href='{$app_name}/login.htm?referUrl={$app_name}/cart.htm';return false;" /> 
      <input type="submit" class="form-button item-auth-login" value="提交订单" /> 
     </div> 
    </div> 
   </form> 

  </div>
  <!-- /#content --> 

{include file="macro/f.tpl"}