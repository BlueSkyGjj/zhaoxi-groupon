{include file="macro/h.tpl"}
{include file="macro/nav.tpl"}

     <div id="content" class="normal-deal-list cf" data-mod="id"> 

  {foreach from=$llBig item=one key=key}
  <div class="primary"> 
   <h1><a href="{$app_name}/deal/{$one.id}.htm" target="_blank">{$one.des}</a></h1> 
   <div class="main"> 
    <div class="deal-buy"> 
     <div class="deal-price-tag-open"></div> 
     <p class="deal-price"><strong>&yen;{$one.price}</strong><span><a href="{$app_name}/deal/{$one.id}.htm" target="_blank"></a></span> </p> 
    </div> 
    <table class="discount">
     <tbody> 
      <tr> 
       <th>原价</th> 
       <th>折扣</th> 
       <th>节省</th> 
      </tr> 
      <tr class="number"> 
       <td>
        <del>
         &yen;{$one.priceMarket}
        </del></td> 
       <td>{$one.discount}折</td> 
       <td>&yen;{$one.priceSave}</td> 
      </tr> 
      <tr> 
       <td class="status-box" colspan="3"> 
        <div class=" deal-status deal-status-open">
         <p class="deal-buy-tip-top"><strong>{$one.saleNum}</strong> 人已购买</p>
        </div>
        <div class="item-time" attr-time-end="{$one.endDate}"> 
		 {if $one.endDate}
         <ul>
          <li><span></span>天</li>
          <li><span></span>小时</li>
          <li><span></span>分钟</li>
         </ul> 
		 {/if}
        </div> 
	   </td> 
      </tr> 
     </tbody>
    </table> 
   </div> 
   <div class="sidebar"> 
    <div class="cover"> 
     <a href="{$app_name}/deal/{$one.id}.htm" target="_blank"> <img src="{$one.imageIndex}" alt="{$one.des}" title="点击查看详情" /></a> 
    </div> 
   </div> 
  </div>
  {/foreach}

	  {foreach from=$ll item=one key=key}
      <div class="item {if ($key + 1) is div by 2}odd{/if} {if $one.saleStatus}common-deals{/if}"> 
       <h3><a target="_blank" href="{$app_name}/deal/{$one.id}.htm" title="{$one.name}"> 
	   【{$one.brand}】{$one.des} 
	   </a></h3> 
       <div class="cover">
	    {if $one.saleStatus}
	    <a class="pngfix {$one.saleStatus}" href="{$app_name}/deal/{$one.id}.htm" target="_blank">卖光了</a>
		{/if}
        <a target="_blank" href="{$app_name}/deal/{$one.id}.htm"><img width="312" height="189" 
			alt="【{$one.brand}】{$one.name}" 
			{if $key gt 7}src="{$app_name}/image-html/grey.gif" data-original="{$one.imageIndex}"{else}src="{$one.imageIndex}"{/if} /></a> 
       </div> 
		<div class="deal-buy">
			<div class="deal-price-tag-open"></div>
			<div class="deal-price-tag"></div>
			<p class="deal-price">
				<strong>¥{$one.price}</strong>
				<span><a href="#" rel="nofollow" target="_blank"></a></span>
			</p>
		</div>

		<table class="deal-discount"><tbody>
			<tr>
				<th>现价</th>
				<td class="price"><strong>¥{$one.price}</strong></td>
			</tr>
			<tr>
				<th>原价</th>
				<td><del><strong>¥{$one.priceMarket}</strong></del></td>
			</tr>
			<tr>
				<th>折扣</th>
				<td><strong>{$one.discount}折</strong></td>
			</tr>
		</tbody></table>
		<div class="item-time" attr-time-end="{$one.endDate}">
			{if $one.endDate}
			<ul>
			<li><span></span>天</li>
			<li><span></span>小时</li>
			<li><span></span>分钟</li>
			</ul>
			{/if}
		</div>
		<div class="deal-status deal-status-open">
			<p class="deal-buy-tip-top"><strong>{$one.saleNum}</strong> 人已购买</p>
		</div>

		{if $one.mark and 1 != 1}
       <div class="deal-mark"> 
        <a href="{$app_name}/deal/{$one.id}.htm" class="deal-mark__item {$one.markStyle}" 
			target="_blank" rel="nofollow" hidefocus="true" title="{$one.markTitle}">{$one.markTitle}</a> 
       </div> 
		{/if}
      </div> 
	  {/foreach}

     </div> 
     
{include file="macro/f-sidebar.tpl"}
{include file="macro/f.tpl"}