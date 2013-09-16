{include file="header.tpl"}
			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>系统参数设置</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<div id="inner">
					<span style="float: left">
						<p id="refresh-link-tips" style="display: none; color: red;" class="notification"></p>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button_white" id="refresh-link-cache">更新缓存</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-add">新增参数</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th width="10%">类型</th> 
							<th width="5%">次序</th> 
							<th width="30%">参数名称</th> 
							<th width="30%">参数值</th> 
							<th></th> 
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td>
							{if $one.type eq 'sys'}
								网站设置
							{elseif $one.type eq 'recommand'}
								查询推荐
							{/if}
							</td>
							<td>{$one.seq}</td>
							<td>{$one.name}</td>
							<td>{$one.value}</td>
							<td>
								<a href="javascript:void();" class="button btn-opt" attr-id="{$one.id}" attr-type="{$one.type}">修改</a>
								<a href="javascript:void();" class="button btn-del" attr-id="{$one.id}">删除</a>
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>

				<fieldset style="width: 500px; margin: 0 auto; margin-top: 6px;">
				<form id="opt-form" method="post" action="{$app_name}/manage/addsys.htm">
				<input type="hidden" name="id" />
				<table>
					<tr>
						<td>
							类型
						</td>
						<td>
							<select name="type">
							<option value="sys">网站设置</option> 
							<option value="recommand">查询推荐</option> 
							</select>
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
							参数名称
						</td>
						<td>
							<input type="text" name="name" rules="r" />
						</td>
					</tr>
					<tr>
						<td>
							参数值
						</td>
						<td>
							<input type="text" name="value" style="width: 400px;" rules="r" />
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
							<a href="javascript:void();" id="btn-submit" class="button btn-submit">保存参数信息</a>
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
	$('#refresh-link-cache').click(function(){
		var url = Conf.getAppPath('/manage/refreshsys.htm');
		$.get(url, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			$('#refresh-link-tips').text(data.time).show();
		});

		return false;
	});

	$('a.btn-del').click(function(){
		var id = $(this).attr('attr-id');
		var url = Conf.getAppPath('/manage/delsys.htm');
		var params = {};
		params.id = id;

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
		if(!data.f_name || !data.f_value){
			alert('请填写参数名称和值！');
			form.find('input[name=name]').focus();
			return false;
		}
		if(!isInt(data.f_seq)){
			alert('次序请填写整数！');
			form.find('input[name=seq]').val('1').focus();
			return false;
		}

		form.submit();
		return false;
	});
	$('a.btn-add').click(function(){
		$('#btn-submit').text('新增参数').attr('submit-type', 'add');
		var form = $('#opt-form');
		form.find('[name=id]').val('');
		form.find('[name=seq]').val('1');
		form.find('[name=name]').val('').focus();
		form.find('[name=value]').val('');

		form.attr('action', Conf.getAppPath('/manage/addsys.htm'));

		return false;
	});
	$('a.btn-opt').click(function(){
		$('#btn-submit').text('更新参数').attr('submit-type', 'update');
		var form = $('#opt-form');
		form.find('[name=name]').focus();

		var _el = $(this);

		var id = _el.attr('attr-id');
		var type = _el.attr('attr-type');

		var tr = _el.closest('tr');
		var seq = tr.find('td:eq(1)').text();
		var name = tr.find('td:eq(2)').text();
		var value = tr.find('td:eq(3)').text();

		form.find('[name=id]').val(id);
		form.find('select[name=type]').val(type);
		form.find('input[name=seq]').val(seq);
		form.find('input[name=name]').val(name);
		form.find('input[name=value]').val(value);

		form.attr('action', Conf.getAppPath('/manage/setsys.htm'));

		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


