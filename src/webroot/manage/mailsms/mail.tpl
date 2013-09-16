<!DOCTYPE html>
	<head> 
		<meta charset="utf-8" />
		<title>朝夕购管理中心</title> 
		<link rel="stylesheet" href="{$app_name}/manage/css/styles.css" />

		<link rel="stylesheet" href="{$app_name}/public/kindeditor/skins/default.css" media="screen" />
		<script type="text/javascript" charset="utf-8" src="{$app_name}/public/kindeditor/kindeditor.js"></script>

		<script src="{$app_name}/public/jquery-1.8.3.min.js"></script>
		<script src="{$app_name}/public/jquery.blockUI.min.js"></script>
		<script language="javascript">
		var appname = '{$app_name}';
		</script>
		<script src="{$app_name}/js/base.js"></script>
		<script src="{$app_name}/manage/js/base.js"></script>

	<!-- Page specific body class chooses layout colour -->
    <body class="blue">

		<!-- Header -->
		<div id="header">
			<h1>朝夕购管理中心</h1>
			<a href="{$app_name}/" class="visit">前往朝夕购</a>
			<p>
				<strong>{$s_admin}</strong>
				|
				<a href="{$app_name}/manage/logout.htm">登出</a>
			</p>
		</div>
		<!-- /End Header -->
		
		<!-- Main Area Container -->
		<div id="container">

			{include file="../sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>邮件发送</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">

				<div id="inner">
					<span style="float: left;">
						<label style="display: inline;">发送群体：</label>
						<select name="cate" id="sel-target">
						<option value="user" selected>注册用户</option> 
						<option value="store">商家</option> 
						</select>
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
					<span style="float: left; margin-right: 4px;">
						<input type="text" id="search-q" name="q" />
					</span>
					<span style="float: left;">
						<a href="javascript:void(0);" id="btn-search" class="button">过滤</a>
					</span>
				</div>

				<div style="clear: both; margin-top: 6px; padding: 0px 4px;">
				{if $error}
				<p class="notification error">{$error}</p>
				{/if}
				{if $success}
				<p class="notification success">{$success}</p>
				{/if}
				</div>

				<form method="post" action="{$app_name}/managemailsms/mailsend.htm">
				<div style="margin-top: 6px;" style="width: 100%;">
					 
					<div style="float: left; width: 200px; height: 450px; overflow: auto; margin-left: 4px; border: 1px solid silver;">
						<h2 style="font-size: 14px; padding: 2px;">To邮件列表</h2>
						<ul id="target-ll" style="padding: 2px;">
						</ul>
					</div>

					<div style="float: left; width: 600px; overflow: auto; margin-left: 4px;">
						<input type="text" style="width: 400px;" name="title" placeholder="请填写邮件标题" {if $title}value="{$title}"{/if} />
						<textarea id="ke" style="width: 600px; height: 400px;" name="content"></textarea>
					</div>

				</div>

				<div style="margin: 2px 0 0 10px;">
					<input type="submit" class="button" value="发送" />
				</div>
				</form>

			</div>
			<!-- /End Content Area -->

		</div>
		<!-- End Main Area Container -->

		{literal}
<script>
KE.show({
	id : 'ke',
	imageUploadJson : appname + '/ctrl/KindEditorAction/imgjson.gym',
	fileManagerJson : appname + '/ctrl/KindEditorAction/filejson.gy',
	allowFileManager : true
});

$(function(){
	$('#btn-search').click(function(e){
		e.preventDefault();
		var q = $('#search-q').val();
		var cate = $('#sel-cate').val();
		var addr = $('#sel-addr').val();
		var target = $('#sel-target').val();

		var url = Conf.getAppPath('/managemailsms/filter.htm');

		$.blockUI({message: '查询中', overlayCSS: {opacity: 0.2}, onBlock: function(){
			$.post(url, {type: 'email', target: target, q: q, cate: cate, addr: addr}, function(r){
				if(r.error){
					alert(r.error);
					$.unblockUI({fadeOut: 1000});
					return;
				}

				var arr = [];

				var tpl = '<li><input type="checkbox" name="l_email" value="{0}" checked="checked" />&nbsp;{0}</li>';
				var i = 0;
				for(; i < r.ll.length; i++){
					var one = r.ll[i];
					arr.push(tpl.format(one.email));
				}

				$('#target-ll').html(arr.join(''));

				$.unblockUI({fadeOut: 1000});
			});
		}});
		
		return false;
	});
});
</script>
		{/literal}
	
	</body>
</html>


