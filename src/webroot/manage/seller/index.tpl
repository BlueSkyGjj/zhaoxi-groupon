{include file="header.tpl"}

			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>销售统计</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<div id="inner">
					<p class="notification success">销售总额：{$orderStat.allAmountImport}&nbsp;&nbsp;销售总量：{$orderStat.allNum}</p>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>月份</th> 
							<th>总额</th>
							<th>总量</th>
							<th>商品</th>
						</tr> 
					</thead>
					<tbody>
						{foreach from=$orderStat.monthSale item=one}
						<tr>
							<td>{$one.month}</td>
							<td>{$one.amountImport}</td>
							<td>{$one.num}</td>
							<td>
								<table>
									{foreach from=$one.ll item=prod}
									<tr>
										<td><a href="{$app_name}/deal/{$prod.id}.htm" title="" target="_blank">{$prod.name}</a></td>
										<td>金额 - {$prod.amountImport}</td>
										<td>数量 - {$prod.num}</td>
									</tr>
									{/foreach}
								</table>
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		{literal}
<script>
$(function(){
});
</script>
		{/literal}
	
	</body>
</html>


