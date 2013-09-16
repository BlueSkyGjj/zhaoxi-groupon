<!DOCTYPE html>
	<head> 
		<meta charset="utf-8" />
		<title>朝夕购管理中心</title> 
		<link rel="stylesheet" href="{$app_name}/manage/css/styles.css" />
	</head>
	
    <body class="blue">

		<div id="login_container">
			<div id="login">
				<div id="login_header">
					<h2>登录</h2>
				</div>
				<div id="login_content">

					<form id="login-form" action="{$app_name}/manage/login.htm" method="post">
						<ul>
							<li>
								<label>Username:</label>
								<input name="login" type="text" value="admin" />
							</li>
							
							<li>
								<label>Password:</label>
								<input name="pwd" type="password" value="" />
							</li>
							<li>
								{if $error}
								<p class="notification information">
								{$error}
								</p>
								{/if}
							</li>
							<li class="clearfix">
								<a href="#" id="link-submit" class="button right">Login</a>
							</li>
						</ul>
					</form>
					
				</div>
			</div>
		</div>
	
		<script src="{$app_name}/public/jquery-1.8.3.min.js"></script>
		<script language="javascript">
		$('#link-submit').click(function(e){
			var u = $('input:first').val();
			var p = $('input:last').val();
			if(!u || !p){
				alert('请输入用户名和密码！');
				return false;
			}
			
			$('#login-form').submit();
			return false;
		});
		</script>
	
	</body>
</html>


