{include file="../macro/h.tpl"}
  <div id="content" class="coupons-box"> 
   <div class="dashboard"> 
    <ul> 
     <li class="current"><a href="{$app_name}/orderlist/all.htm" >团购订单</a></li> 
	 <!-- 
     <li><a href="{$app_name}/orderlist/feebacklist.htm" >我的评价</a></li> 
     <li><a href="{$app_name}/my/growth.htm" >我的成长</a></li> 
	 -->
     <li><a href="{$app_name}/my/setting.htm" >账户设置</a></li> 
    </ul> 
   </div> 
   <div class="mainbox mine"> 
    <ul class="filter cf" data-mtnode="Amymeituan.Borders"> 
     <li{if $r_type eq 'all'} class="current"{/if}><a href="{$app_name}/orderlist/all.htm" >全部</a></li> 
     <li{if $r_type eq 'nopay'} class="current"{/if}><a href="{$app_name}/orderlist/nopay.htm" >待付款</a></li> 
     <li{if $r_type eq 'nofeedback'} class="current"{/if}><a href="{$app_name}/orderlist/nofeedback.htm" >待评价</a></li> 
    </ul> 
    <div class="table-section"> 
     <table id="order-list" cellspacing="0" cellpadding="0" border="0"> 
      <tbody>
       <tr> 
        <th width="auto" class="item-info">团购项目</th> 
        <th width="70">金额</th> 
        <th width="80">订单状态</th> 
        <th width="112">操作</th> 
       </tr>

	   {foreach from=$orderLl item=one}
       <tr class="alt">
        <td class="deal">
         <table class="deal-info">
          <tbody>
		   {foreach from=$one.productLl item=prod}
           <tr>
            <td class="pic"><a href="{$app_name}/deal/{$prod.id}.htm" target="_blank" title="{$prod.des}">
				<img src="{$prod.imageIndex}" width="75" height="46" />
				<span class="mask">&yen;&nbsp;{$prod.price}</span>
				<!-- 
				<span class="status">{$prod.statusLabel}</span>
				-->
				</a>
			</td>
            <td class="text">
				<a class="deal-title" href="{$app_name}/deal/{$prod.id}.htm" title="{$prod.des}" target="_blank">{$prod.name}</a>
			</td>
			<td class="num">
				<span class="deal-num">×&nbsp;&nbsp;{$prod.num}</span>
			</td>
           </tr>
		   {/foreach}
          </tbody>
         </table></td>
        <td>
		&yen;&nbsp;{$one.amount}
		<!-- 
		<br />
		<span class="delivery-text">含运费: <span class="money">&yen;</span>{$one.delivery_amount}</span>
		-->
		</td>
        <td>
			<span class="fade">{$one.statusLabel}</span>
			<br />
			<a href="{$app_name}/order/{$one.id}.htm" target="_blank">订单详情</a>
		</td>
        <td class="op">
		 {if $one.canDelete}
         <form action="{$app_name}/orderdel/{$one.id}.htm" method="post">
          <input class="order-cancel" type="submit" value="删除订单" />
         </form>
		 {/if}

		 {if $one.canPay}
			<a href="{$app_name}/orderpay/{$one.id}.htm" target="_blank">付款</a>
		 {/if}
		 </td>
       </tr>
	   {/foreach}
      </tbody>
     </table> 
    </div> 
   </div> 
  </div>
{include file="../macro/my-sidebar.tpl"}
{include file="../macro/f.tpl"}