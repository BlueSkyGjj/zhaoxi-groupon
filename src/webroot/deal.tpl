{include file="macro/h.tpl"}
{include file="macro/nav.tpl"}

     <div class="bread-nav"> 
      <a href="{$confSite.hostUrl}">朝夕购</a> 
      <span>&raquo;</span> 
      <a href="{$app_name}/cate/{if $r_cate}{$r_cate}{else}all{/if}/{if $r_addr}{$r_addr}{else}all{/if}.htm">{$item.cateName}</a> 
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
         <span class="price"><span class="symbol-RMB">&yen;</span> {$item.price}</span> 
         <span class="original">门店价<span class="discount-price">&yen;{$item.priceMarket}</span> <span class="discount-text">{$item.discount}折</span></span> 
        </div> 
        <div class="deal-info"> 
         <div class="deal-buy  deal-price-tag-open"> 
          <a rel="nofollow" href="{$app_name}/cart/{$item.id}.htm">抢购</a> 
          <a rel="nofollow" class="cart link-add-cart" hidefocus="true" href="javascript:void(0);" attr-id="{$item.id}">加入购物车</a> 
         </div> 
         <div class="deal-status"> 
          <p class="deal-status-count"><strong>{$item.saleNum}</strong> 人已团购</p> 
          <p class="deal-status-time-left deal-on">剩余<span id="counter-leave"><strong>3</strong>天以上</span></p> 
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
        <div class="preference-bar" style="height: 20px; padding-left: 400px;"> 
		{include file="macro/bshare.tpl"}
		</div>
	   </div>

      </div> 
      <div id="deal-rating" class="cf"> 
       <a href="#anchor-reviews" data-anchor="#anchor-reviews" class="more inline-block">查看全部评价</a>消费评分： 
       <span class="score-info inline-block"><em>{$item.rate}</em>
		<span class="common-rating rating-16x16 stars">
			<span class="rate-stars" style="width:{$item.rateWidth}%;"></span>
		</span>
	  </span>已有{$item.rateLl|@count}人评价 
      </div> 
	  <!-- 
      <div id="deal-other-biz" data-mod="do"> 
       <h3>水晶之恋的其他团购</h3> 
       <ul class="item-list"> 
        <li> <a href="" class="first" target="_blank"> <span class="sale">2人已购买</span> <span class="money"> <span class="price">&yen;139</span><span class="value-cn">门店价 </span><span class="value">&yen;438</span> </span> <span class="biz-title">【4店通用】烫发套餐，男女不限，长短发不限</span> </a> </li> 
       </ul> 
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
		  <!-- 
          <p class="deal-menu-summary">价值：<span class="inline-block worth">40</span>元</p> 
          <p class="deal-menu-summary">美团价：<span class="inline-block worth price">15</span>元</p> 
		  -->
		  {/if}

		  <!-- 
          <ul class="list"> 
           <li>流程：洗发→剪发→造型，约40分钟 </li> 
          </ul> 
          <div class="deal-term"> 
           <h5>购买须知</h5> 
           <dl> 
            <dt>
              有效期： 
            </dt> 
            <dd>
              2013.5.29 至 2013.8.29（周末、法定节假日通用） 
            </dd> 
            <dt>
              使用时间： 
            </dt> 
            <dd>
              09:00-21:00 
            </dd> 
            <dt>
              预约提醒： 
            </dt> 
            <dd>
              请至少提前24小时致电商家预约 
            </dd> 
            <dt class="deal-term__rule">
              使用规则： 
            </dt> 
            <dd> 
             <ul> 
              <li>凭美团券到店消费不可同时享受店内其他优惠</li> 
              <li>每张美团券限1人使用</li> 
              <li>本单需一次性体验完毕</li> 
              <li>长短发不限</li> 
             </ul> 
            </dd> 
           </dl> 
          </div> 
		  -->

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

         <div id="anchor-reviews" class="user-reviews"> 
          <div class="overview"> 
		   <!-- 
           <div class="overview-head cf"> 
            <h3 class="overview-title">消费评价</h3> 
            <div class="overview-feedback to-rate">
              我买过本单， 
             <a href="javascript:void(0)">我要评价</a> 
            </div> 
           </div> 
		   -->
           <div class="overview-detail cf"> 
			<!-- 
            <div class="rating-area total-detail"> 
             <div class="total-group total-score"> 
              <span><span class="average-score">{$item.rate}</span>分</span> 
             </div> 
             <div class="total-group"> 
              <span class="common-rating rating-16x16"><span class="rate-stars" style="width:{$item.rateWidth}%"></span></span> 
             </div> 
             <div class="total-group total-count">
               已有 
              <strong>{$item.rateLl|@count}</strong>人评价 
             </div> 
            </div> 
			-->

			<!-- 
            <div class="rating-area score-detail"> 
             <div class="score-group"> 
              <span class="score-title">效果</span> 
              <span class="common-rating rating-16x16"><span class="rate-stars" style="width:0%"></span></span>分 
             </div> 
             <div class="score-group"> 
              <span class="score-title">服务</span> 
              <span class="common-rating rating-16x16"><span class="rate-stars" style="width:0%"></span></span>分 
             </div> 
             <div class="score-group"> 
              <span class="score-title">环境</span> 
              <span class="common-rating rating-16x16"><span class="rate-stars" style="width:0%"></span></span>分 
             </div> 
            </div> 
			-->

			<!--
            <div class="rating-area count-detail"> 
             <div class="count-wrapper inline-block"> 
              <div class="count-group">
               <span class="score">5分</span> 
               <span class="percent-box inline-block"><em style="width:{$item.rate5Width}%" class="percent inline-block"></em></span>{$item.rate5}人 
              </div> 
              <div class="count-group"> 
               <span class="score">4分</span> 
               <span class="percent-box inline-block"><em style="width:{$item.rate4Width}%" class="percent inline-block"></em></span>{$item.rate4}人 
              </div> 
              <div class="count-group"> 
               <span class="score">3分</span> 
               <span class="percent-box inline-block"><em style="width:{$item.rate3Width}%" class="percent inline-block"></em></span>{$item.rate3}人 
              </div> 
              <div class="count-group"> 
               <span class="score">2分</span> 
               <span class="percent-box inline-block"><em style="width:{$item.rate2Width}%" class="percent inline-block"></em></span>{$item.rate2}人 
              </div> 
              <div class="count-group"> 
               <span class="score">1分</span> 
               <span class="percent-box inline-block"><em style="width:{$item.rate1Width}%" class="percent inline-block"></em></span>{$item.rate1}人 
              </div> 
             </div> 
            </div> 
			 -->

           </div> 
          </div> 

          <div class="detail"> 
           <ul class="filter cf"> 
            <li class="current"> <a href="javascript:void(0);" data-filter="all">全部评价</a> </li> 
			<!-- 
            <li class="last"> 
				<input name="withcontent" type="checkbox" checked="checked" id="with-content" /> 
				<label class="widthcontent-label" for="with-content">有内容的评价</label>
				<a class="sort-default selected-sort" data-sort="default" hidefocus="true" href="javascript:void(0)">默认</a>
				<a class="sort-time" data-sort="time" hidefocus="true" href="javascript:void(0)">按时间<span class="pngfix sort-icon"></span></a>
			</li> 
			-->
           </ul> 
           <ul class="review-list">

{foreach from=$item.rateLl item=one}
<li>
	<div class="info cf">
		<div class="rate-status">
			<span class="common-rating">
				<span class="rate-stars" style="width:{$one.rateWidth}%"></span>
			</span>
		</div>
		<span class="name">{$one.uid}</span>
		<!-- 
		<span class="growth-info"><i class="level-icon level-icon-0" title="等级VIP0"></i></span>
		-->
		<span class="time">{$one.dd}</span>
	</div>
	<p class="content">{$one.msg}</p>
</li>
{/foreach}
		   </ul> 
           <div class="page-navbar cf"></div> 
          </div> 
         </div> 
        </div> 

        <div class="deal-buy-bottom"> 
         <span class="price num">&yen;{$item.price}</span> 
          <a rel="nofollow" href="{$app_name}/cart/{$item.id}.htm">抢购</a> 
          <a rel="nofollow" class="cart link-add-cart" hidefocus="true" href="javascript:void(0);" attr-id="{$item.id}">加入购物车</a> 
         <ul class="cf"> 
          <li>门店价<br /> 
           <del class="num"> 
            <span>&yen;</span>{$item.priceMarket}
           </del></li> 
          <li>折扣<br /><span class="num">{$item.discount}折</span></li> 
          <li>已购买<br /><span class="num">{$item.saleNum}人</span></li> 
         </ul> 
        </div> 
       </div> 
      </div> 

     </div>
     <!-- /#content --> 

{include file="macro/f-sidebar.tpl"}
{include file="macro/f.tpl"}