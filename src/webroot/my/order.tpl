{include file="../macro/h.tpl"}
<div id="content"> 
   <div class="dashboard"> 
    <ul> 
     <li class="current"><a href="{$app_name}/orderlist/all.htm" >团购订单</a></li> 
     <li><a href="{$app_name}/orderlist/feebacklist.htm" >我的评价</a></li> 
     <li><a href="{$app_name}/my/growth.htm" >我的成长</a></li> 
     <li><a href="{$app_name}/my/setting.htm" >账户设置</a></li> 
    </ul>
   </div> 
   <div class="mainbox mine"> 
    <h2> 订单详情 <span class="op-area"><a href="{$app_name}/orderlist/all.htm">返回我的订单</a></span> </h2> 
    <dl class="info-section" id="primary-info"> 
     <dt>
      当前订单状态：
      <em>{$order.statusLabel}</em>
     </dt> 
     <dd class="last"> 
      <p>订单金额：{$order.amount}</p> 

	 {if $order.canPay}
		<a href="{$app_name}/orderpay/{$order.id}.htm" target="_blank">付款</a>
	 {/if}
     </dd> 
    </dl> 
    <dl class="bunch-section"> 
     <dt class="bunch-section__label">
      订单信息
     </dt> 
     <dd class="bunch-section__content"> 
      <ul class="flow-list"> 
       <li>订单编号：{$order.orderNo}</li> 
       <li>下单时间：{$order.dd}</li> 
      </ul> 
     </dd> 
	 {if $order.deliveryType neq 0}
     <dt class="bunch-section__label">
       配送信息 
     </dt> 
     <dd class="bunch-section__content"> 
      <ul id="order-address"> 
       <li>收货人：{$addr.addrName}</li> 
       <li>联系电话：{$addr.mobile}</li> 
       <li>送货地址：{$addr.prov} {$addr.city} {$addr.dist} {$addr.addr}，{$addr.addrCode}</li> 
       <li>送货时间：{$order.deliveryTimeDes}</li> 
       <li>配送说明：{$order.deliveryMsg}</li> 
      </ul> 
     </dd> 
	 {/if}
     <dt class="bunch-section__label">
      团购信息
     </dt> 
     <dd class="bunch-section__content"> 
      <table cellspacing="0" cellpadding="0" border="0" class="info-table"> 
       <tbody>
        <tr> 
         <th class="left" width="auto">团购项目</th> 
         <th width="50">单价</th> 
         <th width="10"></th> 
         <th width="30">数量</th> 
         <th width="10"></th> 
         <th width="54">支付金额</th> 
        </tr> 
		{foreach from=$productLl item=prod}
        <tr> 
         <td class="left"> <a class="deal-title" href="{$app_name}/deal/{$prod.id}.htm" target="_blank">{$prod.name}</a> </td> 
         <td><span class="money">&yen;</span>{$prod.price}</td> 
         <td>×</td> 
         <td>{$prod.num}</td> 
         <td>=</td> 
         <td class="total"><span class="money">&yen;</span>{$prod.amount}</td> 
        </tr>
		{/foreach}
       </tbody>
      </table> 
     </dd> 
    </dl> 
   </div> 
  </div>
{include file="../macro/f.tpl"}