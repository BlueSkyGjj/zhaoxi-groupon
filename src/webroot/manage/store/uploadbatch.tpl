{include file="../header.tpl"}

			{include file="../sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>商家信息批量上传</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">

				<div id="inner">
					<form method="post" enctype="multipart/form-data" action="{$app_name}/ctrl/ManageStoreAction/uploadbatchpost.gym">
					<span style="float: left; margin-right: 4px;">
						<input type="file" name="file" />
					</span>
					<span style="float: left;">
						<input type="submit" class="button" value="提交" />
					</span>
					</form>

					<span style="float: right; margin-right: 4px;">
						<a href="{$app_name}/public/files/template.xls" target="blank" class="button">下载样板文件</a>
					</span>
				</div>

				<div style="clear: both; margin-top: 6px; padding: 0px 4px;">
				{if $error}
				<p class="notification error">{$error}</p>
				{/if}
				</div>

			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->


		{literal}
<script>
$(function(){
});
</script>
		{/literal}
	
	</body>
</html>


