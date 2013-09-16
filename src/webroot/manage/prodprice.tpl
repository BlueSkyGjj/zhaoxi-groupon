{include file="header.tpl"}

			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>产品列表</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<form id="update-form" method="post" action="{$app_name}/manage/setprodpricepost.htm">
				<input type="hidden" id="pid" name="pid" value="{$r_pid}" />
				<div id="inner">
					{if $time}
					<span style="float: left; margin-right: 4px; color: red;">
						最后保存时间 - {$time}
					</span>
					{/if}
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-add">新增价格项目</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-save">保存</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="{$app_name}/manage/index.htm" class="button btn-back">返回</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>次序</th> 
							<th>内容</th> 
							<th>单价</th> 
							<th>数量</th> 
							<th>合计</th> 
							<th></th> 
						</tr> 
					</thead>
					<tbody id="price-rows">
						{foreach from=$ll item=one}
						<tr>
							<td><input type="text" name="l_seq" value="{$one.seq}" style="width: 50px;" /></td>
							<td><input type="text" name="l_content" value="{$one.content}" /></td>
							<td><input type="text" name="l_price" value="{$one.price}" style="width: 50px;" /></td>
							<td><input type="text" name="l_num" value="{$one.num}" style="width: 50px;" /></td>
							<td><input type="text" name="l_priceTotal" value="{$one.priceTotal}" style="width: 50px;" /></td>

							<td>
								<a href="javascript:void();" class="button btn-del">删除</a>
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
				</form>
			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		<div style="display: none;">
		<table>
		<tr id="tpl-row">
			<td><input type="text" name="l_seq" value="" style="width: 50px;" /></td>
			<td><input type="text" name="l_content" value="" /></td>
			<td><input type="text" name="l_price" value="" style="width: 50px;" /></td>
			<td><input type="text" name="l_num" value="" style="width: 50px;" /></td>
			<td><input type="text" name="l_priceTotal" value="" style="width: 50px;" /></td>

			<td>
				<a href="javascript:void();" class="button btn-del">删除</a>
			</td>
		</tr>
		</table>
		</div>


		{literal}
<script>
$(function(){
	$('input[name=l_seq]').mask('9');

	$('a.btn-save').click(function(){
		$('#update-form').submit();
		return false;
	});
	$('a.btn-add').click(function(){
		$('#tpl-row').clone().appendTo($('#price-rows'));
		$('#price-rows tr:last').find('input[name=l_seq]').mask('9');
		return false;
	});
	$('a.btn-del').live('click', function(){
		$(this).closest('tr').slideUp().remove();
		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


