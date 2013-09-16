{include file="../header.tpl"}

			{include file="../sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>用户登录历史</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>昵称</th>
							<th>登录时间</th> 
							<th></th>
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td>{$one.nickname}</td>
							<td>{$one.dd}</td>
							<td>
								<a href="{$app_name}/manageuser/userorderlist.htm?id={$one.uid}" class="button">消费订单</a>
								<br />
								<a href="{$app_name}/manageuser/loginlog.htm?id={$one.uid}" class="button_white">登录历史</a>
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
				<div class="pagi">
					{$pagi}
				</div>
			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		{literal}
<script>
$(function(){
	$('a.piLink').click(function(){
		var cp = $(this).text();
		var url = document.location.href;
		if(url.indexOf('?') != -1){
			url += '&cp=' + cp;
		}else{
			url += '?cp=' + cp;
		}

		document.location.href = url;

		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


