{include file="macro/h.tpl"}
{include file="macro/nav.tpl"}

     <div class="bread-nav"> 
      <a href="{$confSite.hostUrl}">朝夕购</a> 
      <span>&raquo;</span> 
      <a href="{$app_name}/giftlist.htm">积分兑换</a> 
      <span>&raquo;</span>{$item.name} 
     </div> 

	 <!-- /.bread-nav -->
     <div id="content"> 
      <div id="deal-intro" class="cf"> 
       <div class="deal-brand">
         {$item.brand} 
        <h1>{$item.name}</h1> 
       </div> 
       <h2 class="deal-title">{$item.des}</h2> 
       <div class="main"> 
        <div class="deal-discount"> 
         <span class="price"><span class="symbol-RMB">兑换积分</span> {$item.points}</span> 
         <span class="original"></span> 
        </div> 
        <div class="deal-info"> 
         <div class="deal-buy  deal-price-tag-open"> 
          <a rel="nofollow" href="{$app_name}/cart/{$item.id}.htm">抢购</a> 
          <a rel="nofollow" class="cart link-add-cart" hidefocus="true" href="javascript:void(0);" attr-id="{$item.id}">加入购物车</a> 
         </div> 
         <div class="deal-status"> 
          <p class="deal-status-count"><strong>{$item.saleNum}</strong> 人已团购</p> 
         </div> 
         <ul class="consumer-protection"> 
		  <!-- 
          <li class="seven"> <a href="javascript:void(0);" title="支持 “未消费随时退款”" target="_blank"><span class="icon pngfix">&nbsp;</span>支持随时退</a> </li> 
          <li class="expire"> <a href="javascript:void(0);" title="支持 “过期未消费无条件退款”" target="_blank"><span class="icon pngfix">&nbsp;</span>支持过期退</a> </li> 
		  -->
		  <li class="seven"></li>
		  <li class="expire"></li>
         </ul> 
        </div> 
       </div> 
       <div class="deal-buy-cover-img"> 
	    <!-- 轮播 -->
	    <ul id="deal-img-list">
		 {foreach from=$item.imgScrollLl item=one key=key}
	     <li {if $key eq 0}class="first"{/if} style="left: 0px;">
			<img alt="{$item.name}" width="462" height="280" src="{$one.path}" /> 
		 </li>
		 {/foreach}
	    </ul>
		  <div id="img-list"> 
		   {foreach from=$item.imgScrollLl item=one key=key}
		   <a {if $key eq 0}class="active"{/if}>{$key + 1}</a> 
		   {/foreach}
		  </div>

		{if $one.mark}
       <div class="deal-mark"> 
         <span class="deal-mark__item {$one.markStyle}" title="{$one.markTitle}">{$one.markTitle}</span> 
       </div> 
		{/if}
       </div> 

       <div class="deal-preference"> 
	   </div>

      </div> 

	  <!-- 
      <div id="deal-rating" class="cf"> 
       <a href="#anchor-reviews" data-anchor="#anchor-reviews" class="more inline-block">查看全部评价</a>消费评分： 
       <span class="score-info inline-block"><em>{$item.rate}</em>
		<span class="common-rating rating-16x16 stars">
			<span class="rate-stars" style="width:{$item.rateWidth}%;"></span>
		</span>
	  </span>已有{$item.rateLl|@count}人评价 
      </div> 
	  -->

      <div id="deal-stuff"> 
       <div class="mainbox cf"> 
        <div class="main"> 
         <h2 class="content-title" id="anchor-detail">本单详情</h2> 
         <div class="blk detail">

		  {if $item.priceDetailLl|@count != 0}
		  <!-- 
          <p class="standard-bar" style="background-color:#37adb1;"></p> 
		  -->
          <table class="deal-menu"> 
           <tbody> 
            <tr> 
             <th class="name">内容</th> 
             <th class="price">单价</th> 
             <th class="amount">数量/规格</th> 
             <th class="subtotal">小计</th> 
            </tr> 
			{foreach from=$item.priceDetailLl item=one}
            <tr> 
             <td class="name">{$one.content}</td> 
             <td class="price">{$one.price}</td> 
             <td class="amount">{$one.num}</td> 
             <td class="subtotal">{$one.priceTotal}</td> 
            </tr> 
			{/foreach}
           </tbody> 
          </table> 
		  {/if}


          <!--项目介绍--> 
          <ul class="list"> 
           <li style="list-style-type:none;margin-left:-15px"> <strong></strong> </li> 
          </ul> 
          <!--商家介绍--> 
          <div id="anchor-bizinfo"> 

		{foreach from=$item.imgListLl item=one key=key}
		 {if $one.title}
<p class="standard-bar" style="background-color:#37adb1;">{$one.title}</p> 
<p class="standard-center"><b>{$one.des}</b></p>
		 {/if}
<div class="standard-content"> 
	<!-- all image lazy load -->
	{if $key gt 0}
	<img height="267" data-original="{$one.path}" 
		src="{$app_name}/image-html/grey.gif" alt="{$one.title}" class="standard-image" /> 
	{else}
	<img height="267" src="{$one.path}" alt="{$one.title}" class="standard-image" /> 
	{/if}
</div>
		 {/foreach}

          </div> 
         </div> 

        </div> 

        <div class="deal-buy-bottom">
         <span class="price num">兑换积分 - {$item.points}</span> 
          <a rel="nofollow" href="{$app_name}/cart/{$item.id}.htm">抢购</a> 
          <a rel="nofollow" class="cart link-add-cart" hidefocus="true" href="javascript:void(0);" attr-id="{$item.id}">加入购物车</a> 
         <ul class="cf"> 
         </ul> 
        </div>

		<div class="deal-preference"> 
        <div class="preference-bar" style="height: 20px; padding-left: 400px;"> 
		{include file="macro/bshare.tpl"}
		</div>
		</div>

       </div> 
      </div> 

     </div>
     <!-- /#content --> 

{include file="macro/f-sidebar.tpl"}
{include file="macro/f.tpl"}