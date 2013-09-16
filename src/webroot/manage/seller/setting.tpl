{include file="header.tpl"}

			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>用户信息</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<div id="inner">
					{if $success}
					<p class="notification success">{$success}</p>
					{/if}
					{if $error}
					<p class="notification error">{$error}</p>
					{/if}
				</div>

				<form id="main-form" method="post" action="{$app_name}/seller/settingpost.htm">
				<table class="tbl tablesorter hover">
				<tr>
					<td width="15%">
						账户
					</td>
					<td width="35%">
						{$s_seller.code}
					</td>
					<td width="15%">
						名称
					</td>
					<td width="35%">
						{$s_seller.name}
					</td>
				</tr>
				<tr>
					<td>
						联系人
					</td>
					<td>
						<input type="text" name="contact" value="{$s_seller.contact}" />
					</td>
					<td>
						手机
					</td>
					<td>
						<input type="text" name="mobile" value="{$s_seller.mobile}" />
					</td>
				</tr>
				<tr>
					<td>
						邮箱
					</td>
					<td>
						<input type="text" name="email" value="{$s_seller.email}" />
					</td>
					<td>
						QQ
					</td>
					<td>
						<input type="text" name="qq" value="{$s_seller.qq}" />
					</td>
				</tr>
				<tr>
					<td>
						描述
					</td>
					<td colspan="3">
						<textarea name="des" style="width: 400px; height: 100px">{$s_seller.des}</textarea>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="text-align: center;">
						<input type="submit" value="保存" />
					</td>
				</tr>
				</table>
				</form>

			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		{literal}
<script>
$(function(){
	$('#main-form').submit(function(){
		var val = $('input[name=contact]').val().trim();
		if(!val){
			alert('请填写联系人！');
			$('input[name=contact]').focus();
			return false;
		}

		val = $('input[name=mobile]').val().trim();
		if(val && !isMobile(val)){
			alert('请填写有效的手机号码！');
			$('input[name=mobile]').focus();
			return false;
		}

		val = $('input[name=email]').val().trim();
		if(val && !isEmail(val)){
			alert('请填写有效的邮箱！');
			$('input[name=email]').focus();
			return false;
		}

		val = $('input[name=qq]').val().trim();
		if(val && !(/^\d+$/.test(val))){
			alert('请填写有效的QQ！');
			$('input[name=qq]').focus();
			return false;
		}

		return true;
	});
});
</script>
		{/literal}
	
	</body>
</html>


