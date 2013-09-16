{include file="header.tpl"}

			{include file="sidebar.tpl"}
	
			<!-- Subheader -->
			<div id="subheader" class="clearfix">
				<h2>产品列表</h2>
			</div>
			<!-- /End Subheader -->
			
			<!-- Main Content Area -->
			<div id="content">
				<form id="query-form" method="post" action="{$app_name}/manage/index.htm">
				<input type="hidden" id="cp" name="cp" value="{$r_cp}" />
				<input type="hidden" name="sortBy" value="{$r_sortBy}" />
				<div id="inner">
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
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-refresh-cc">更新产品分类、区域数量</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="{$confSite.managePicUrl}" target="blank" class="button">管理图片</a>
					</span>
					<span style="float: right; margin-right: 4px;">
						<a href="javascript:void();" class="button btn-add">新增产品</a>
					</span>
				</div>

				<table class="tbl tablesorter hover">
					<thead> 
						<tr> 
							<th>产品</th> 
							<th>类别</th> 
							<th>分类</th> 
							<th>区域</th> 
							<th>价格区间</th> 
							<th>座位数量</th> 
							<th>品牌</th> 
							<th>价格</th> 
							<th>市场价</th> 
							<th>上架状态</th> 
							<th>销售数量</th> 
							<th></th> 
						</tr> 
					</thead>
					<tbody>
						{foreach from=$ll item=one}
						<tr>
							<td><a href="{$app_name}/deal/{$one.id}.htm" title="{$one.des}" target="_blank">{$one.name}</a></td>
							<td>
								{if $one.type eq 'forgift'}
								<span style="color: red;">赠品</span>
								{elseif $one.type eq 'sheraton'}
								<span style="color: blue;">喜来登专场</span>
								{else}商品
								{/if}
							</td>
							<td>{$one.cateName}</td>
							<td>{$one.addrName}</td>
							<td>{$one.pricerangeName}</td>
							<td>{$one.seatName}</td>
							<td>{$one.brand}</td>
							<td>{$one.price}</td>
							<td>{$one.priceMarket}</td>
							<td>{if $one.status eq '1'}上架{else}<span style="color: red;">下架</span>{/if}</td>
							<td>{$one.saleNum}</td>
							<td>
								<a href="javascript:void();" class="button btn-opt" attr-id="{$one.id}">修改</a>
								<br />
								<a href="{$app_name}/manage/listprodimg.htm?id={$one.id}" class="button_white">上传图片</a>
								<br />
								<a href="{$app_name}/manage/setprodprice.htm?id={$one.id}" class="button_white">详细价格</a>
							</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
				<div class="pagi">
					{$pagi}
				</div>
				</form>
			</div>
			<!-- /End Content Area -->
			
		</div>
		<!-- End Main Area Container -->

		<div id="dialog-opt" style="display: none;">
			<table>
				<tr>
					<td width="15%">
						名称
					</td>
					<td width="35%">
						<input type="text" name="name" rules="r" />
					</td>
					<td width="15%">
						编号
					</td>
					<td width="35%">
						<input type="text" name="code" rules="r" />
					</td>
				</tr>
				<tr>
					<td>
						类别
					</td>
					<td>
						<select name="type">
							<option value="forsale" selected>商品</option>
							<option value="forgift">赠品</option>
							<option value="sheraton">喜来登专场</option>
						</select>
					</td>
					<td>
						赠品积分
					</td>
					<td>
						<input type="text" name="points" style="width: 50px;" rules="r int" />
					</td>
				</tr>
				<tr>
					<td>
						品牌
					</td>
					<td>
						<input type="text" name="brand" />
					</td>
					<td>
						标示
					</td>
					<td>
						<select name="mark">
							<option value="">--/--</option>
							<option value="big">放大显示</option>
							<option value="new">新品</option>
						</select>
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
						价格区间
					</td>
					<td>
						<select name="pricerange">
						{foreach from=$pricerangeList item=one}
						<option value="{$one.code}">{$one.name}</option> 
						{/foreach}
						</select>
					</td>
					<td>
						座位数量
					</td>
					<td>
						<select name="seatnum">
						{foreach from=$seatList item=one}
						<option value="{$one.code}">{$one.name}</option> 
						{/foreach}
						</select>
					</td>
				</tr>
				<tr>
					<td>
						价格
					</td>
					<td>
						<input type="text" name="price" style="width: 50px;" rules="r int" />
					</td>
					<td>
						市场价
					</td>
					<td>
						<input type="text" name="priceMarket" style="width: 50px;" rules="r int" />
					</td>
				</tr>
				<tr>
					<td>
						进货价格
					</td>
					<td>
						<input type="text" name="priceImport" style="width: 50px;" rules="r int" />
					</td>
					<td>
						提成
					</td>
					<td>
						<input type="text" name="discountMy" style="width: 50px;" rules="r int percent" />&nbsp;%&nbsp;
					</td>
				</tr>
				<tr>
					<td>
						发布时间
					</td>
					<td>
						<input type="text" name="pubDate" />
					</td>
					<td>
						截止时间
					</td>
					<td>
						<input type="text" name="endDate" />
					</td>
				<tr>
					<td>
						上架状态
					</td>
					<td>
						<select name="status">
							<option value="1">上架</option>
							<option value="0">下架</option>
						</select>
					</td>
					<td>商家</td>
					<td>
						<select name="storeId">
						{foreach from=$storeList item=one}
						<option value="{$one.id}">{$one.name}</option> 
						{/foreach}
						</select>
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
	$('a.piLink').click(function(){
		$('#cp').val($(this).text());
		$('#query-form').submit();
		return false;
	});

	$('a.btn-refresh-cc').click(function(){
		var url = Conf.getAppPath('/manage/refreshprodnum.htm');
		$.get(url, function(r){
			alert('更新成功！请刷新首页查看！');
		});
		return false;
	});

	// update
	var getProduct = function(id){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return;

		var url = Conf.getAppPath('/manage/getprod.htm?id=' + id);
		$.get(url, function(data){
			if(data.error){
				alert(data.error);
				return;
			}
			
			Conf.bind(context, data);

			// 日期处理
			var dat = data.pubDate ? new Date(data.pubDate) : new Date();
			context.find('[name=pubDate]').val(dat.format()).datepicker({dateFormat: 'yy-mm-dd'});

			if(data.endDate){
				context.find('[name=endDate]').val(new Date(data.endDate).format()).datepicker({dateFormat: 'yy-mm-dd'});
			}else{
				context.find('[name=endDate]').datepicker({dateFormat: 'yy-mm-dd'});
			}
		});
	};
	var updateProduct = function(id){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return;

		var params = Conf.getFormData(context);
		params.id = id;

		// check
		if(!Conf.checkFormData(context, params))
			return false;

		// 不是forsale的为下架
		if('forsale' != params.type){
			params.status = '0';
		}

		var url = Conf.getAppPath('/manage/updateprod.htm');
		$.post(url, params, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

			context.find('.notification').text(data.time).show();
		});
	};
	var addProduct = function(){
		var context = $('.ui_content');
		if(!context.length || context.is(':hidden'))
			return false;

		var params = Conf.getFormData(context);
		if(!Conf.checkFormData(context, params))
			return false;

		// 不是forsale的为下架
		if('forsale' != params.type){
			params.status = '0';
		}


		var url = Conf.getAppPath('/manage/addprod.htm');
		$.post(url, params, function(data){
			if(data.error){
				alert(data.error);
				return;
			}

//			context.find('.notification').text(data.time).show();

			document.location.reload();
		});

		return true;
	};

	$('a.btn-add').click(function(){
		$.dialog({
			title: '新增产品', 
			width: 600,
			height: 400,
			content: $('#dialog-opt').html(),

			init: function(){
				var context = $('.ui_content');
				context.find('[name=pubDate]').val(new Date().format()).datepicker({dateFormat: 'yy-mm-dd'});
				context.find('[name=endDate]').datepicker({dateFormat: 'yy-mm-dd'});
			},

			button: [
				{
					name: '确定', 
					callback: function(){
						return addProduct();
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
			title: title, 
			width: 600,
			height: 400,
			content: $('#dialog-opt').html(),

			init: function(){
				getProduct(id);
			},

			button: [
				{
					name: '确定', 
					callback: function(){
						updateProduct(id);
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


