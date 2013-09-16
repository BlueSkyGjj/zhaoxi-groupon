{include file="../header.tpl"}

			{include file="../sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>销售统计</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<div id="inner">
					<div>
						<label style="display: inline;">商家：</label>
						<select name="storeId" id="sel-store">
						<option value="">--/--</option> 
						{foreach from=$storeList item=one}
						<option value="{$one.id}"{if $r_storeId eq $one.id} selected{/if}>{$one.name}</option> 
						{/foreach}
						</select>
					</div>

					{if $orderStat}
					<div>
					<p class="notification success">
						销售总额：{$orderStat.allAmount}&nbsp;&nbsp;
						进价总额：{$orderStat.allAmountImport}&nbsp;&nbsp;
						利润总额：{$orderStat.allAmount - $orderStat.allAmountImport}&nbsp;&nbsp;
						销售总量：{$orderStat.allNum}</p>
					</div>
					{/if}
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>月份</th> 
							<th>总额</th>
							<th>进价</th>
							<th>总量</th>
							<th>商品</th>
						</tr> 
					</thead>
					<tbody>
						{foreach from=$orderStat.monthSale item=one}
						<tr>
							<td>{$one.month}</td>
							<td>{$one.amount}</td>
							<td>{$one.amountImport}</td>
							<td>{$one.num}</td>
							<td>
								<table>
									{foreach from=$one.ll item=prod}
									<tr>
										<td><a href="{$app_name}/deal/{$prod.id}.htm" title="" target="_blank">{$prod.name}</a></td>
										<td>金额 - {$prod.amount}</td>
										<td>进价 - {$prod.amountImport}</td>
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
	$('#sel-store').change(function(){
		document.location.href = Conf.getAppPath('/managestore/stat.htm?storeId=' + $(this).val());
	});
});
</script>
		{/literal}
	
	</body>
</html>


