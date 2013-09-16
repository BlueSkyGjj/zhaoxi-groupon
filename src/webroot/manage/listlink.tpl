{include file="header.tpl"}
			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>友情链接</h2>
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
						<a href="javascript:void();" class="button btn-add">新增链接</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th width="10%">标题</th> 
							<th width="5%">次序</th> 
							<th width="30%">链接</th> 
							<th width="10%">类型</th> 
							<th width="10%">链接类型</th> 
							<th width="20%">更新时间</th> 
							<th></th> 
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td>{$one.label}</td>
							<td>{$one.seq}</td>
							<td><a href="{$one.link}" target="_blank">{$one.link}</a></td>
							<td>
							{if $one.type eq 'bangzhu'}
								用户帮助
							{elseif $one.type eq 'gengxin'}
								获取更新
							{elseif $one.type eq 'hezuo'}
								商务合作
							{elseif $one.type eq 'gongsi'}
								公司信息
							{elseif $one.type eq 'guanggao'}
								滚动广告
							{/if}
							</td>
							<td>
							{if $one.target eq '_blank'}
								新打开窗口
							{elseif $one.target eq '_self'}
								自身窗口
							{/if}
							</td>
							<td>{$one.dd}</td>
							<td>
								<a href="javascript:void();" class="button btn-opt" attr-id="{$one.id}" attr-type="{$one.type}" attr-target="{$one.target}">修改</a>
								<a href="javascript:void();" class="button btn-del" attr-id="{$one.id}">删除</a>
								<input type="hidden" value="{$one.pic}" />
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>

				<fieldset style="width: 500px; margin: 0 auto; margin-top: 6px;">
				<form id="opt-form" method="post" action="{$app_name}/manage/addlink.htm">
				<input type="hidden" name="id" />
				<table>
					<tr>
						<td width="25%">
							标题
						</td>
						<td>
							<input type="text" name="label" rules="r" />
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
							<option value="bangzhu">用户帮助</option> 
							<option value="gengxin">获取更新</option> 
							<option value="hezuo">商务合作</option> 
							<option value="gongsi">公司信息</option> 
							<option value="guanggao">滚动广告</option> 
							</select>
						</td>
					</tr>
					<tr>
						<td>
							链接类型
						</td>
						<td>
							<select name="target">
							<option value="_blank">新打开窗口</option> 
							<option value="_self">自身窗口</option> 
							</select>
						</td>
					</tr>
					<tr>
						<td>
							链接地址
						</td>
						<td>
							<input type="text" name="link" style="width: 400px;" rules="r" />
						</td>
					</tr>
					<tr>
						<td>
							图片地址
						</td>
						<td>
							（滚动广告请填写图片路径）
							<input type="text" name="pic" style="width: 400px;" rules="" />
							<br />
							<a href="javascript:void();" id="opt-pic-path">打开图片</a>
							<br />
							<a href="{$confSite.managePicUrl}" class="button" target="_blank">管理图片</a>
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
							<a href="javascript:void();" id="btn-submit" class="button btn-submit">保存链接信息</a>
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
	$('#opt-pic-path').click(function(){
		var path = $(this).siblings('input').val().trim();
		if(path)
			window.open(path);

		return false;
	});

	$('#refresh-link-cache').click(function(){
		var url = Conf.getAppPath('/manage/refreshlink.htm');
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
		var url = Conf.getAppPath('/manage/dellink.htm');
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
		if(!isInt(data.f_seq)){
			alert('次序请填写整数！');
			form.find('input[name=seq]').val('1').focus();
			return false;
		}

		form.submit();
		return false;
	});
	$('a.btn-add').click(function(){
		$('#btn-submit').text('新增链接').attr('submit-type', 'add');
		var form = $('#opt-form');
		form.find('[name=id]').val('');
		form.find('[name=label]').val('').focus();
		form.find('[name=seq]').val('1');
		form.find('[name=link]').val('');
		form.find('[name=target]').val('_blank');

		form.attr('action', Conf.getAppPath('/manage/addlink.htm'));

		return false;
	});
	$('a.btn-opt').click(function(){
		$('#btn-submit').text('更新链接').attr('submit-type', 'update');
		var form = $('#opt-form');
		form.find('[name=label]').focus();

		var _el = $(this);

		var id = _el.attr('attr-id');
		var type = _el.attr('attr-type');
		var target = _el.attr('attr-target');

		var pic = _el.siblings('input').val();

		var tr = _el.closest('tr');
		var label = tr.find('td:first').text();
		var seq = tr.find('td:eq(1)').text();
		var link = tr.find('td:eq(2)').text();

		form.find('[name=id]').val(id);
		form.find('select[name=type]').val(type);
		form.find('select[name=target]').val(target);
		form.find('input[name=label]').val(label);
		form.find('input[name=seq]').val(seq);
		form.find('input[name=link]').val(link);
		form.find('input[name=pic]').val(pic);

		form.attr('action', Conf.getAppPath('/manage/setlink.htm'));

		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


