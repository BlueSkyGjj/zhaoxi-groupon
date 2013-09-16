{include file="../macro/h.tpl"}
 <div id="content" class="pg-check pg-cart-check"> 
   <div class="mainbox"> 
    <ol class="buy-process-bar"> 
     <li class="step-first current"> 1.选择支付方式 <span class="highlight"></span> <span class="arrow"></span> </li> 
     <li class="step-last"> 2.购买成功 </li> 
    </ol> 
    <div class="cart-info-field"> 
     <h4>订单编号-<span style="color: red;">{$order.orderNo}</span>，项目名称及数量：</h4> 
     <ul class="orders-detail">
	 {foreach from=$productLl item=one}
      <li><p>{$one.name}：<a href="{$app_name}/deal/{$one.id}.htm" target="_blank">{$one.des}</a><span class="item-quantity">共{$one.num}份</span>/<span class="item-price">单价-&yen;{$one.price}</span></p></li> 
	 {/foreach}
     </ul> 
    </div> 
	<!-- 
    <div class="cart-info-field"> 
     <h4>接收美团券密码的手机号：</h4> 
     <strong class="mobile">186****4494，</strong>凭美团券密码去商家消费。 
    </div> 
	-->
    <div class="cart-info-field"> 
	{if $order.noDelivery}
     <ul> 
      <li><span class="delivery-info">手机号码：</span>{$order.addrMobile}</li> 
      <li><span class="delivery-info">留言：</span>{$order.addrMsg}</li> 
     </ul> 
	{else}
     <h4>物流单的收货地址：</h4> 
     <ul> 
      <li><span class="delivery-info">配送地址：</span>{$addr.addrName} - {$addr.mobile}，{$addr.prov} {$addr.city} {$addr.dist} {$addr.addr}，{$addr.addrCode}</li> 
      <li><span class="delivery-info">配送时间：</span>{$order.deliveryTimeDes}</li> 
     </ul> 
	{/if}
    </div> 

    <form id="order-check-type-form" class="common-form" action="{$app_name}/orderlist/paypost.htm" method="post" target="_blank"> 
     <input type="hidden" name="order_id" value="{$order.id}" /> 
     <div id="J-pay-choice" class="pay-choice"> 
      <p class="pay-choice-tip">应付总额<span class="money">&yen;{$order.amount}</span></p> 
      <input type="hidden" name="pay-method" value="no-credit" id="J-pay-use-other" /> 
     </div> 
     <div id="J-pay-types" class="blk-item paytype" style="display:block"> 
      <div id="order-check-typelist" class="paytype-list" data-uix="collapse">
       <div class="bank-area"> 
        <h3 class="bank-type"><i class="bank-type__icon"></i>支付宝/财付通支付</h3> 
        <ul class="bank-list bank-list--xpay"> 
         <li class="item left"> <input id="check-alipay" class="radio" type="radio" name="paytype" value="alipay" checked="true" /> <label for="check-alipay" class="bank bank--alipay">支付宝</label> </li> 
         <li class="item"> <input id="check-tenpay" class="radio" type="radio" name="paytype" value="tenpay" /> <label for="check-tenpay" class="bank bank--tenpay">财付通</label> </li> 
        </ul> 
       </div> 
      </div> 
     </div> 
     <p class="pay-total" id="J-pay-total">支付<span class="money">&yen;{$order.amount}</span></p> 
     <div class="form-submit"> 
	  <input type="button" class="form-button" value="返回我的订单" onclick="javascript:location.href='{$app_name}/orderlist/all.htm';" /> 
      <input id="J-order-pay-button" type="submit" class="form-button" value="去付款" /> 
     </div> 
    </form> 
   </div> 
  </div>
  <!-- /#content --> 

  <div id="sidebar"> 
   <div class="side-single"> 
    <div class="inner-blk pay-consolation"> 
     <h3>请放心购买</h3> 
     <p>采用第三方平台支付，最大限度保证您支付安全。</p> 
    </div> 
    <div class="inner-blk side-tips last" data-uix="collapse"> 
     <h3>需要帮助？</h3> 
     <div class="uix-collapse"> 
      <h4 class="uix-collapse__trigger">是否支持信用卡支付？</h4> 
      <p class="uix-collapse__content" style="display: block;"> 朝夕购建议您通过&quot;支付宝&quot;或&quot;财付通&quot;选择对应银行完成支付。 </p> 
     </div> 
    </div> 
   </div> 
  </div>

{include file="../macro/f.tpl"}