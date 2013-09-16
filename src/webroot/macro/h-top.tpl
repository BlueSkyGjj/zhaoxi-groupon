<div id="site-top" class="cf"> 
      <a class="logo" href="{$confSite.hostUrl}"><img src="{$app_name}/image/logo.png" width="138" height="60" title="朝夕购，每天团购一次" alt="朝夕购，每天团购一次" /></a> 
      <div class="city-info"> 
       <h2><a class="city-name" href="{$confSite.hostUrl}">漯河</a></h2> 
	   <!-- 
       <a href="{$app_name}/changecity.htm" class="change-city">[切换城市]</a> 
	   -->
      </div> 
      <div class="site-info"> 
       <ul> 
        <li> <a rel="nofollow" href="{$app_name}/seller/index.htm" target="_blank">商家登录</a> </li> 
        <li> <a rel="nofollow" class="subscribe" href="{$app_name}/subscribe.htm"><span></span>订阅</a> </li> 
        <li> <a rel="nofollow" class="fav" id="link-favorite" href="javascript:void(0);"><span></span>添加收藏</a> </li>
		<!-- 
        <li> <a rel="nofollow" class="refer" href="http://www.meituan.com/account/referrals" target="_blank">邀请好友</a> </li> 
        <li class="last"> <a rel="nofollow" class="" href="http://www.meituan.com/help/faq">帮助</a> </li> 
		-->
       </ul> 
      </div> 
      <div class="search-w"> 
       <div class="search cf"> 
        <form id="search-q-form" action="{$app_name}/search.htm" class="search-form J-search-form" name="searchForm" method="post"> 
         <input tabindex="1" type="text" name="q" id="search-q" autocomplete="off" class="s-text" value="" placeholder="请输入商品名称、地址等" /> 
         <input type="submit" class="s-submit" hidefocus="true" value="搜索" /> 
        </form> 
        <div class="s-hot"> 
		 {foreach from=$confSite.recommandSearchList item=one name=searchList}
         <a class="hot-link {if $smarty.foreach.searchList.last}last{/if}" href="{$app_name}/search.htm" attr-q="{$one}">{$one}</a> 
		 {/foreach}
        </div> 
       </div> 
       <div class="search-suggest J-search-suggest" style="display:none;"> 
        <ul class="search-suggest__list J-search-suggest-list"></ul> 
       </div> 
      </div> 
     </div>