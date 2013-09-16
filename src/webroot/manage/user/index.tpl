{include file="../header.tpl"}

			{include file="../sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>用户列表</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">

				<div id="inner">
					<span style="float: left; margin-right: 4px;">
						<input type="text" id="search-q" />
					</span>
					<span style="float: left;">
						<a href="javascript:void(0);" id="btn-search" class="button">查找</a>
					</span>

					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-add">新增记录</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>ID</th> 
							<th>email</th> 
							<th>mobile</th> 
							<th>昵称</th> 
							<th>第三方登录</th> 
							<th>qq</th> 
							<th>注册时间</th> 
							<th></th>
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td>{$one.id}</td>
							<td>{$one.email}</td>
							<td>{$one.mobile}</td>
							<td>{$one.nickname}</td>
							<td>{$one.thirdPart}</td>
							<td>{$one.qq}</td>
							<td>{$one.dd}</td>
							<td>
								<a href="{$app_name}/manageuser/userorderlist.htm?id={$one.id}" class="button">订单消费</a>
								<br />
								<a href="{$app_name}/manageuser/loginlog.htm?id={$one.id}" class="button_white">登录历史</a>
								<br />
								<a href="#" class="button_white btn-opt" attr-id="{$one.id}">修改信息</a>
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
						Email
					</td>
					<td width="35%">
						<input type="text" name="email" />
					</td>
					<td width="15%">
						昵称
					</td>
					<td width="35%">
						<input type="text" name="nickname" rules="r" />
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
						手机
					</td>
					<td>
						<input type="text" name="mobile" />
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
	$('#btn-search').click(function(){
		var q = $('#search-q').val().trim();
		if(!q){
			alert('请输入关键字！');
			return;
		}

		document.location.href = 'index.htm?q=' + encodeURIComponent(q);
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

	// update
	var getUser = function(id){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return;

		var url = Conf.getAppPath('/manageuser/get.htm?id=' + id);
		$.get(url, function(data){
			if(data.error){
				alert(data.error);
				return;
			}
			
			Conf.bind(context, data);
		});
	};
	var updateUser = function(id){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return;

		var params = Conf.getFormData(context);
		params.id = id;

		// check
		if(!Conf.checkFormData(context, params))
			return false;

		var url = Conf.getAppPath('/manageuser/update.htm');
		$.post(url, params, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			context.find('.notification').text(data.time).show();
		});
	};
	var addUser = function(){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return false;

		var params = Conf.getFormData(context);
		if(!Conf.checkFormData(context, params))
			return false;

		var url = Conf.getAppPath('/manageuser/add.htm');
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
			title: '新增用户', 
			width: 600,
			height: 400,
			content: $('#dialog-opt').html(),

			init: function(){
			},

			button: [
				{
					name: '确定', 
					callback: function(){
						return addUser();
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
			title: '修改用户 - ' + title, 
			width: 600,
			height: 400,
			content: $('#dialog-opt').html(),

			init: function(){
				getUser(id);
			},

			button: [
				{
					name: '确定', 
					callback: function(){
						updateUser(id);
						return false;
					},
					focus: true
				}, 
				{name: '关闭'}
			]
		});
		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


