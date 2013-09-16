{include file="header.tpl"}
	<script language="javascript">
	var pid = '{$r_pid}';
	</script>
			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>产品图片</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<div id="inner">
					<span style="float: right;">
						<a href="javascript:void();" class="button btn-add">新增图片</a>
					</span>

					<span style="float: right; margin-right: 4px;">
						<a href="{$app_name}/manage/index.htm" class="button btn-back">返回</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th width="10%">标题</th> 
							<th width="5%">次序</th> 
							<th width="20%">描述</th> 
							<th width="10%">类型</th> 
							<th width="20%">缩略图</th> 
							<th width="10%">更新时间</th> 
							<th></th> 
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td>{$one.title}</td>
							<td>{$one.seq}</td>
							<td>{$one.des}</td>
							<td>
							{if $one.type eq 'scroll'}
								滚动图
							{elseif $one.type eq 'list'}
								详细内容插图
							{elseif $one.type eq 'index'}
								主页展示图
							{/if}
							</td>
							<td style="text-align: center; vertical-align: middle;"><img class="thumb-img" src="{$one.path}" width="150" height="120" /></td>
							<td>{$one.dd}</td>
							<td>
								<a href="javascript:void();" class="button btn-opt" attr-id="{$one.id}" attr-type="{$one.type}">修改</a>
								{if $one.type neq 'index'}
								<a href="javascript:void();" class="button btn-del" attr-id="{$one.id}">删除</a>
								{/if}
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>

				<fieldset style="width: 500px; margin: 0 auto; margin-top: 6px;">
				<form id="opt-form" method="post" enctype="multipart/form-data" action="{$app_name}/ctrl/ManageAction/addprodimg.gym">
				<input type="hidden" name="pid" value="{$r_pid}" />
				<input type="hidden" name="id" />
				<table>
					<tr>
						<td width="25%">
							标题
						</td>
						<td>
							<input type="text" name="title" rules="r" />
						</td>
					</tr>
					<tr>
						<td>
							次序
						</td>
						<td>
							<input type="text" name="seq" rules="r int" />
						</td>
					</tr>
					<tr>
						<td>
							类型
						</td>
						<td>
							<select name="type">
							<option value="scroll">滚动图</option> 
							<option value="list">详细内容插图</option> 
							<option value="index">主页展示图</option> 
							</select>
						</td>
					</tr>
					<tr>
						<td>
							描述
						</td>
						<td>
							<input type="text" name="des" style="width: 400px;" rules="r" />
						</td>
					</tr>
					<tr>
						<td>
							图片
						</td>
						<td>
							<input type="file" name="one" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							{if $error}
							<p class="notification error">{$error}</p>
							{/if}
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<a href="javascript:void();" id="btn-submit" class="button btn-submit">保存图片信息</a>
						</td>
					</tr>
				</table>
				</form>
				</fieldset>
			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		{literal}
<script>
$(function(){
	$('a.btn-del').click(function(){
		var id = $(this).attr('attr-id');
		var url = Conf.getAppPath('/manage/delprodimg.htm');
		var params = {};
		params.id = id;
		params.pid = pid;

		var _this = $(this);
		$.post(url, params, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			_this.closest('tr').fadeIn().remove();
		});
		return false;
	});

	// add or update
	$('#btn-submit').click(function(){
		var form = $('#opt-form');
		var data = Conf.getFormData(form);
		if(!isInt(data.f_seq)){
			alert('次序请填写整数！');
			form.find('input[name=seq]').val('1').focus();
			return false;
		}

		form.submit();
		return false;
	});
	$('a.btn-add').click(function(){
		$('#btn-submit').text('新增图片').attr('submit-type', 'add');
		var form = $('#opt-form');
		form.find('[name=id]').val('');
		form.find('[name=title]').val('').focus();
		form.find('[name=seq]').val('1');
		form.find('[name=des]').val('');
		form.find('[name=type]').val('scroll').removeAttr('disabled');

		form.attr('action', Conf.getAppPath('/ctrl/ManageAction/addprodimg.gym'));

		return false;
	});
	$('a.btn-opt').click(function(){
		$('#btn-submit').text('更新图片').attr('submit-type', 'add');
		var form = $('#opt-form');
		form.find('[name=title]').focus();

		var id = $(this).attr('attr-id');
		var type = $(this).attr('attr-type');
		var tr = $(this).closest('tr');
		var title = tr.find('td:first').text();
		var seq = tr.find('td:eq(1)').text();
		var des = tr.find('td:eq(2)').text();

		if('index' == type){
			form.find('select[name=type]').val(type).attr('disabled', true);
			form.attr('action', Conf.getAppPath('/ctrl/ManageAction/setprodimg.gym'));
		}else{
			form.find('select[name=type]').val(type).removeAttr('disabled');
			form.attr('action', Conf.getAppPath('/ctrl/ManageAction/updateprodimg.gym'));
		}
		form.find('[name=id]').val(id);
		form.find('input[name=title]').val(title);
		form.find('input[name=seq]').val(seq);
		form.find('input[name=des]').val(des);

		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


