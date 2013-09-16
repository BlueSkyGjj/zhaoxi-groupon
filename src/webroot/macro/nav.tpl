     <div id="filter"> 
      <div class="hot-tag-outer-box"> 
       <div class="filter-label-list hot-tag-wrapper" data-mod="it"> 
        <div class="label">
          分类： 
        </div> 
        <div class="inline-block-list"> 
		 {foreach from=$cateList item=one}
         <a href="{$app_name}/latest/{$one.code}/{$r_addr}/{$r_pricerange}/{$r_seatnum}.htm" class="item {if $r_cate eq $one.code}hot{/if}">{$one.name}</a> 
		 {/foreach}
        </div> 
       </div> 
      </div><!-- /.hot-tag-outer-box -->

      <div class="filter-sortbar-outer-box"> 
       <div class="filter-section-wrapper"> 
        <div class="filter-label-list filter-section category-filter-wrapper first-filter" data-mod="ic"> 
         <div class="label has-icon"> 
          <i></i>区域： 
         </div> 
         <ul class="inline-block-list"> 
		 {foreach from=$addrList item=one}<li class="item {if $r_addr eq $one.code}current{/if}"><a 
			href="{$app_name}/cate/{$r_cate}/{$one.code}/{$r_pricerange}/{$r_seatnum}.htm">{$one.name}<span>{if $one.cc}{$one.cc}{else}0{/if}</span></a></li>{/foreach}
         </ul> 
        </div> 
       </div><!-- /.filter-section-wrapper --> 

      <div class="price-tag-outer-box"> 
       <div class="filter-label-list hot-tag-wrapper" data-mod="it"> 
        <div class="label">
          价格： 
        </div> 
        <div class="inline-block-list"> 
		 {foreach from=$pricerangeList item=one}
         <a href="{$app_name}/latest/{$r_cate}/{$r_addr}/{$one.code}/{$r_seatnum}.htm" class="item {if $r_pricerange eq $one.code}hot{/if}">{$one.name}</a> 
		 {/foreach}
        </div> 
       </div> 
      </div><!-- /.hot-tag-outer-box -->

      <div class="num-tag-outer-box"> 
       <div class="filter-label-list hot-tag-wrapper" data-mod="it"> 
        <div class="label">
          数量： 
        </div> 
        <div class="inline-block-list"> 
		 {foreach from=$seatList item=one}
         <a href="{$app_name}/latest/{$r_cate}/{$r_addr}/{$r_pricerange}/{$one.code}.htm" class="item {if $r_seatnum eq $one.code}hot{/if}">{$one.name}</a> 
		 {/foreach}
        </div> 
       </div> 
      </div><!-- /.hot-tag-outer-box -->

       <div class="sort-bar"> 
        <div class="button-strip inline-block"> 
         <a href="{$app_name}/cate/{$r_cate}/{$r_addr}/{$r_pricerange}/{$r_seatnum}.htm" title="默认排序" class="button-strip-item inline-block button-strip-item-right {if $r_sortBy eq 'all'}button-strip-item-checked{/if}"><span class="inline-block button-outer-box"><span class="inline-block button-content">默认排序</span></span></a> 
         <a href="{$app_name}/hot/{$r_cate}/{$r_addr}/{$r_pricerange}/{$r_seatnum}.htm" title="销量从高到低" class="button-strip-item inline-block button-strip-item-left button-strip-item-right button-strip-item-desc {if $r_sortBy eq 'hot'}button-strip-item-checked{/if}"><span class="inline-block button-outer-box"><span class="inline-block button-content">销量</span><span class="inline-block button-img"></span></span></a> 
         <a href="{$app_name}/asc/{$r_cate}/{$r_addr}/{$r_pricerange}/{$r_seatnum}.htm" title="价格从低到高" class="button-strip-item inline-block button-strip-item-left button-strip-item-right button-strip-item-asc {if $r_sortBy eq 'asc'}button-strip-item-checked{/if}"><span class="inline-block button-outer-box"><span class="inline-block button-content">价格</span><span class="inline-block button-img"></span></span></a> 
         <a href="{$app_name}/desc/{$r_cate}/{$r_addr}/{$r_pricerange}/{$r_seatnum}.htm" title="价格从高到低" class="button-strip-item inline-block button-strip-item-left button-strip-item-right button-strip-item-desc {if $r_sortBy eq 'desc'}button-strip-item-checked{/if}"><span class="inline-block button-outer-box"><span class="inline-block button-content">价格</span><span class="inline-block button-img"></span></span></a> 
         <a href="{$app_name}/latest/{$r_cate}/{$r_addr}/{$r_pricerange}/{$r_seatnum}.htm" title="发布时间从新到旧" class="button-strip-item inline-block button-strip-item-left button-strip-item-desc large-button {if $r_sortBy eq 'latest'}button-strip-item-checked{/if}"><span class="inline-block button-outer-box"><span class="inline-block button-content">发布时间</span><span class="inline-block button-img"></span></span></a> 
        </div> 
		<!-- 
        <a class="inline-block checkbox pngfix checkbox-nocheck" hidefocus="true" href="b=1.html">免预约</a> 
        <a class="inline-block checkbox pngfix checkbox-nocheck" hidefocus="true" href="voucher=1.html">代金券</a> 
		-->
       </div> 
      </div><!-- /.filter-sortbar-outer-box --> 
     </div><!-- /.filter -->

{include file="scroll-img.tpl"}