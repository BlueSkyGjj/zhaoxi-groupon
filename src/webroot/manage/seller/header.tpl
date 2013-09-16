<!DOCTYPE html>
	<head> 
		<meta charset="utf-8" />
		<title>朝夕购商家管理中心</title> 
		<link rel="stylesheet" href="{$app_name}/manage/css/styles.css" />
		<link rel="stylesheet" href="{$app_name}/manage/css/pager.css" />
		<link rel="stylesheet" href="{$app_name}/public/skins/blue.css" />
		<script src="{$app_name}/public/jquery-1.8.3.min.js"></script>
		<script language="javascript">
		var appname = '{$app_name}';
		</script>
		<script src="{$app_name}/js/base.js"></script>
		<script src="{$app_name}/manage/js/base.js"></script>

	<!-- Page specific body class chooses layout colour -->
    <body class="blue">

		<!-- Header -->
		<div id="header">
			<h1>朝夕购商家管理中心</h1>
			<a href="{$app_name}/" class="visit">前往朝夕购</a>
			<p>
				<strong>{$s_seller.name}</strong>
				|
				<a href="{$app_name}/seller/logout.htm">登出</a>
			</p>
		</div>
		<!-- /End Header -->
		
		<!-- Main Area Container -->
		<div id="container">