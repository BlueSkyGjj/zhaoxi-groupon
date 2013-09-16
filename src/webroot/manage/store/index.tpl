{include file="../header.tpl"}

			{include file="../sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>商家列表</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">

				<div id="inner">
					<form id="query-form" method="post" action="{$app_name}/managestore/index.htm">
					<span style="float: left; margin-right: 4px;">
						<input type="text" id="search-q" name="q" />
					</span>
					<span style="float: left;">
						<a href="javascript:void(0);" id="btn-search" class="button">查找</a>
					</span>

					<span style="float: left;">
						<label style="display: inline;">分类：</label>
						<select name="cate" id="sel-cate">
						<option value="" selected>--/--</option> 
						{foreach from=$cateList item=one}
						<option value="{$one.code}"{if $r_cate eq $one.code} selected{/if}>{$one.name}</option> 
						{/foreach}
						</select>
					</span>
					<span style="float: left;">
						<label style="display: inline;">区域：</label>
						<select name="addr" id="sel-addr">
						<option value="" selected>--/--</option> 
						{foreach from=$addrList item=one}
						<option value="{$one.code}"{if $r_addr eq $one.code} selected{/if}>{$one.name}</option> 
						{/foreach}
						</select>
					</span>
					</form>

					<span style="float: right; margin-right: 4px;">
						<a href="{$app_name}/managestore/uploadbatch.htm" target="blank" class="button">批量导入</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-add">新增记录</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>ID</th> 
							<th>账号</th> 
							<th>名称</th> 
							<th>分类</th> 
							<th>区域</th> 
							<th>email</th> 
							<th>mobile</th> 
							<th>qq</th> 
							<th>是否专场</th> 
							<th></th>
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td>{$one.id}</td>
							<td>{$one.code}</td>
							<td><p title="{$one.des}">{$one.name}</p></td>
							<td>{$one.cateName}</td>
							<td>{$one.addrName}</td>
							<td>{$one.email}</td>
							<td>{$one.mobile}</td>
							<td>{$one.qq}</td>
							<td>{if $one.isSpecial eq 1}<span style="color: red;">是</span>{/if}</td>
							<td>
								<a href="{$app_name}/managestore/stat.htm?storeId={$one.id}" class="button">订单结算</a>
								<br />
								<a href="#" class="button_white btn-reset-pwd" attr-id="{$one.id}">重置密码</a>
								<br />
								<a href="#" class="button_white btn-opt" attr-id="{$one.id}">修改信息</a>
								<br />
								<a href="{$app_name}/managestore/del.htm?id={$one.id}" class="button_white btn-del">删除</a>
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

		<div id="dialog-opt" style="display: none;">
			<table>
				<tr>
					<td width="15%">
						账号
					</td>
					<td width="35%">
						<input type="text" name="code" rules="r" />
					</td>
					<td width="15%">
						名称
					</td>
					<td width="35%">
						<input type="text" name="name" rules="r" />
					</td>
				</tr>
				<tr>
					<td>
						Email
					</td>
					<td>
						<input type="text" name="email" />
					</td>
					<td>
						手机
					</td>
					<td>
						<input type="text" name="mobile" />
					</td>
				</tr>
				<tr>
					<td>
						QQ
					</td>
					<td>
						<input type="text" name="qq" />
					</td>
					<td>
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td>
						分类
					</td>
					<td>
						<select name="cate">
						{foreach from=$cateList item=one}
						<option value="{$one.code}">{$one.name}</option> 
						{/foreach}
						</select>
					</td>
					<td>
						区域
					</td>
					<td>
						<select name="addr">
						{foreach from=$addrList item=one}
						<option value="{$one.code}">{$one.name}</option> 
						{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td>
						是否专场
					</td>
					<td>
						<select name="isSpecial">
						<option value="0">否</option> 
						<option value="1">是</option> 
						</select>
					</td>
					<td>
						是否“最新”提示
					</td>
					<td>
						<select name="isSpecialNew">
						<option value="0">否</option> 
						<option value="1">是</option> 
						</select>
					</td>
				</tr>
				<tr>
					<td>
						专场名称
					</td>
					<td>
						<input type="text" name="specialNavName" />
					</td>
					<td>
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td>
						描述
					</td>
					<td colspan="3">
						<input type="text" name="des" style="width: 400px;" rules="r" />
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<p class="notification success" style="display: none;"></p>
					</td>
				</tr>
			</table>
		</div>

		{literal}
<script>
$(function(){
	$('#sel-cate,#sel-addr').change(function(){
		$('#query-form').submit();
	});
	$('#btn-search').click(function(){
		var q = $('#search-q').val().trim();
		if(!q){
			alert('请输入关键字！');
			return;
		}

		$('#query-form').submit();
		return false;
	});

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

	$('.btn-reset-pwd').click(function(e){
		e.preventDefault();

		var id = $(this).attr('attr-id');
		var url = Conf.getAppPath('/managestore/resetpwd.htm');
		$.dialog.prompt('请输入新的密码',
			function(val){
				if(!val){
					alert('请输入新的密码');
				}else{
					$.post(url, {id:id, pwd: val}, function(r){
						if(r.flag){
							alert('重置成功！');
						}else{
							alert('重置失败！' + r.error);
						}
					});
				}
			});
		
		return false;
	});

	// update
	var getStore = function(id){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return;

		var url = Conf.getAppPath('/managestore/get.htm?id=' + id);
		$.get(url, function(data){
			if(data.error){
				alert(data.error);
				return;
			}
			
			Conf.bind(context, data);
		});
	};
	var updateStore = function(id){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return;

		var params = Conf.getFormData(context);
		params.id = id;

		// check
		if(!Conf.checkFormData(context, params))
			return false;

		var url = Conf.getAppPath('/managestore/update.htm');
		$.post(url, params, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			context.find('.notification').text(data.time).show();
		});
	};
	var addStore = function(){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return false;

		var params = Conf.getFormData(context);
		if(!Conf.checkFormData(context, params))
			return false;

		var url = Conf.getAppPath('/managestore/add.htm');
		$.post(url, params, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			document.location.reload();
		});

		return true;
	};

	$('a.btn-add').click(function(){
		$.dialog({
			title: '新增商家', 
			width: 600,
			height: 400,
			content: $('#dialog-opt').html(),

			init: function(){
			},

			button: [
				{
					name: '确定', 
					callback: function(){
						return addStore();
					},
					focus: true
				}, 
				{name: '关闭'}
			]
		});
		return false;
	});
	$('a.btn-opt').click(function(){
		var id = $(this).attr('attr-id');
		var tr = $(this).closest('tr');
		var title = tr.find('td:first').text();

		$.dialog({
			title: '修改商家 - ' + title, 
			width: 600,
			height: 400,
			content: $('#dialog-opt').html(),

			init: function(){
				getStore(id);
			},

			button: [
				{
					name: '确定', 
					callback: function(){
						updateStore(id);
						return false;
					},
					focus: true
				}, 
				{name: '关闭'}
			]
		});
		return false;
	});

	$('.btn-del').click(function(){
		return confirm('确定要删除该商家信息么？');
	});
});
</script>
		{/literal}
	
	</body>
</html>


