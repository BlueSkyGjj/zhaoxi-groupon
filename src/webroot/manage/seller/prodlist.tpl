{include file="header.tpl"}

			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>产品列表</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<form id="query-form" method="post" action="{$app_name}/seller/prodlist.htm">
				<input type="hidden" id="cp" name="cp" value="{$r_cp}" />
				<input type="hidden" name="sortBy" value="{$r_sortBy}" />
				<div id="inner">
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>产品</th> 
							<th>类别</th> 
							<th>分类</th> 
							<th>区域</th> 
							<th>价格区间</th> 
							<th>座位数量</th> 
							<th>品牌</th> 
							<th>价格</th> 
							<th>市场价</th> 
							<th>销售数量</th> 
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td><a href="{$app_name}/deal/{$one.id}.htm" title="{$one.des}" target="_blank">{$one.name}</a></td>
							<td>
								{if $one.type eq 'forgift'}
								<span style="color: red;">赠品</span>
								{elseif $one.type eq 'sheraton'}
								<span style="color: blue;">喜来登专场</span>
								{else}商品
								{/if}
							</td>
							<td>{$one.cateName}</td>
							<td>{$one.addrName}</td>
							<td>{$one.pricerangeName}</td>
							<td>{$one.seatName}</td>
							<td>{$one.brand}</td>
							<td>{$one.price}</td>
							<td>{$one.priceMarket}</td>
							<td>{$one.saleNum}</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
				<div class="pagi">
					{$pagi}
				</div>
				</form>
			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		{literal}
<script>
$(function(){
	$('a.piLink').click(function(){
		$('#cp').val($(this).text());
		$('#query-form').submit();
		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


