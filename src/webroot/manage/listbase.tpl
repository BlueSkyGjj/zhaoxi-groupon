{include file="header.tpl"}

			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>基础分类信息列表</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<form id="update-form" method="post" action="{$app_name}/manage/updatebase.htm">
				<input type="hidden" id="type" name="type" value="{$r_type}" />
				<div id="inner">
					<span style="float: left;">
						<label style="display: inline;">分类：</label>
						<select id="sel-type">
						<option value="">--/--</option> 
						<option value="cate" {if $r_type eq 'cate'}selected{/if}>分类</option>
						<option value="addr" {if $r_type eq 'addr'}selected{/if}>区域</option>
						<option value="seatnum" {if $r_type eq 'seatnum'}selected{/if}>数量</option>
						<option value="pricerange" {if $r_type eq 'pricerange'}selected{/if}>价格</option>
						</select>
					</span>

					<span style="float: left">
						<p id="refresh-link-tips" style="display: none; color: red;" class="notification"></p>
					</span>

					{if $time}
					<span style="float: left; margin-right: 4px; color: red;">
						最后保存时间 - {$time}
					</span>
					{/if}

					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button_white" id="refresh-link-cache">更新缓存</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-add">新增项目</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-save">保存</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>次序</th> 
							<th>编码（英文或拼音）</th> 
							<th>内容描述</th> 
							<th></th> 
						</tr> 
					</thead>
					<tbody id="base-rows">
						{foreach from=$ll item=one}
						<tr>
							<td><input type="text" name="l_seq" value="{$one.seq}" style="width: 50px;" /></td>
							<td><input type="text" name="l_code" value="{$one.code}" /></td>
							<td><input type="text" name="l_name" value="{$one.name}" /></td>

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
			<td><input type="text" name="l_code" value="" /></td>
			<td><input type="text" name="l_name" value="" /></td>

			<td>
				<a href="javascript:void();" class="button btn-del">删除</a>
			</td>
		</tr>
		</table>
		</div>


		{literal}
<script>
$(function(){
	$('#refresh-link-cache').click(function(){
		var url = Conf.getAppPath('/manage/refreshBaseCateAddr.htm');
		$.get(url, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			$('#refresh-link-tips').text(data.time).show();
		});

		return false;
	});

	$('#sel-type').change(function(){
		var type = $(this).val();
		document.location.href = Conf.getAppPath('/manage/listbase.htm?type=' + type);
	});

	$('input[name=l_seq]').mask('9');

	$('a.btn-save').click(function(){
		$('#update-form').submit();
		return false;
	});
	$('a.btn-add').click(function(){
		$('#tpl-row').clone().appendTo($('#base-rows'));
		$('#base-rows tr:last').find('input[name=l_seq]').mask('9');
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


