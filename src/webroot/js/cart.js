$(function(){
	var prodMaxNumInCart = 9999;

	// 计算合计
	var calSum = function(){
		$('input.J-quantity').each(function(){
			var tr = $(this).closest('tr');
			var priceUnit = parseInt(tr.find('.J-price').text());
			var num = parseInt($(this).val().trim() || '1');
			var priceTotal = priceUnit * num;
			tr.find('.J-total').text(priceTotal);
		});

		// 总额合计
		var ll = $('.J-total').map(function(){
			return parseInt($(this).text());
		}).get();

		var sum = 0;
		var i = 0;
		for(; i < ll.length; i++){ 
			sum += ll[i];
		}
		$('#J-cart-total').text(sum);
	};

	var updateCartNum = function(link, isInput){
		calSum();

		// ajax to change product number in session
		var input = isInput ? link : link.siblings('input');
		var num = input.val();
		var id = input.attr('attr-prod-id');

		var url = '/ctrl/CartAction/updateCart.gy';
		$.post(Conf.getAppPath(url), {id: id, num: num});
	};

	$('.minus-disabled').each(function(){
		var input = $(this).siblings('input');
		if(parseInt(input.val()) != 1){
			$(this).removeClass('minus-disabled');
		}
	});

	$('.plus-disabled').each(function(){
		var input = $(this).siblings('input');
		if(parseInt(input.val()) < prodMaxNumInCart){
			$(this).removeClass('plus-disabled');
		}
	});

	$('.minus').click(function(e){
		var input = $(this).siblings('input');
		var num = parseInt(input.val() || '0');
		if(num > 0){
			input.val(num - 1);
			updateCartNum($(this));
		}else{
			$(this).addClass('minus-disabled');
		}
		return false;
	});

	$('.plus').click(function(e){
		var input = $(this).siblings('input');
		var num = parseInt(input.val() || '0');
		if(num < prodMaxNumInCart){
			if(num > 0){
				$(this).siblings('.minus').removeClass('minus-disabled');
			}else{
				$(this).siblings('.minus').addClass('minus-disabled');
			}

			input.val(num + 1);
			updateCartNum($(this));
		}else{
			alert('数量超过最大限制——' + prodMaxNumInCart);
		}
		return false;
	});

	// 修改数量
	$('input.J-quantity').keyup(function(e){
		var val = $(this).val().trim();
		if(!val){
			$(this).val(1);
			return false;
		}

		if(!val.match(/^\d+$/)){
			$(this).val(val.replace(/[^0-9.]/g, ''));
			return false;
		}

		if(val.length > 4){
			return false;
		}

		var num = parseInt(val);
		if(num > 0){
			$(this).siblings('.minus').removeClass('minus-disabled');
		}else{
			$(this).siblings('.minus').addClass('minus-disabled');
		}

		updateCartNum($(this), true);
	});

	$('a.delete-prod').click(function(e){
		var id = $(this).attr('attr-prod-id');
		var url = '/ctrl/CartAction/updateCart.gy';

		$(this).closest('tr').slideUp().remove();

		$.post(Conf.getAppPath(url), {idDel: id}, function(){
			var cartNum = $('a.delete-prod').length;

			// 更新购物车产品数量
			var _div = $('.cart-count');
			var tpl= '您的购物车内有';
			var tplSuf = '种商品，共可放20种商品';
			_div.attr('title', tpl + cartNum + tplSuf);
			
			var cartLlLengthPercent = cartNum / 20 * 100;
			_div.find('span.current').width(cartLlLengthPercent + '%');
			_div.find('span.number').text('' + cartNum + '/20');

			calSum();
		});
		return false;
	});

	// 
	calSum();

	// 收货地址列表
	var refreshAddrList = function(list){
		var tpl = '<li> <input type="radio" name="addr_id" id="deal-buy-address{0}" value="{0}" /> <label class="detail" for="deal-buy-address{0}">{1}</label> ' + 
			'<span><a href="#" class="cart-addr-del">删除</a></span></li>';

		var arr = [];
		var i = 0;
		for(; i < list.length; i++){
			var it = list[i];
			arr.push(tpl.format(it.id, it.des));
		}

		$('#deal-buy-address-other').parent().before(arr.join(''));
	};

	var showTip = function(msg){
//		if(msg){
//			$('#J-common-tip .content').text(msg);
//			$('#J-common-tip').show();
//		}

		alert(msg);
	};

	$('#J-common-tip .close').click(function(){
		$('#J-common-tip').slideUp();
	});

	// form submit
	$('#J-cart-form').submit(function(){
		// 检查是否登录
		
		// 检查购物车中是否有物品
		if(!$('.cart-item-tr').length){
			showTip('购物车中没有任何物品！');
			return false;
		}

		// 检查购物车中是否有为数量0的商品
		if($('input.J-quantity[value=0]').length){
			showTip('购物车中物品数量为0！');
			return false;		
		}

		if($('#deal-buy-address-not-required').is(':checked')){
			var mobile = $('#addr_mobile').val();

			if(!mobile || !isMobile(mobile)){
				showTip('请填写有效的手机号码！');
				$('#addr_mobile').focus();
				return false;
			}
		}

		if($('#deal-buy-address-other').is(':checked')){
			showTip('请保存收货地址！');
			return false;
		}

		return true;
	});

	// 省市关联
	var appendDist = function(pid, sel){
		var url = Conf.getAppPath('/getDistLl.htm?pid=' + pid);
		$.get(url, function(r){
			sel.find('option:gt(0)').remove();

			var tpl = '<option value="{0}">{1}</option>';

			var arr = [];
			var i = 0;
			for(; i < r.ll.length; i++){
				var one = r.ll[i];
				arr.push(tpl.format(one.regionId, one.regionName));
			}
			sel.append(arr.join(''));
		});
	};

	$('#sel-prov').change(function(){
		var val = $(this).val();
		if(!val){
			$('#sel-city').find('option:gt(0)').remove();
		}else{
			appendDist(val, $('#sel-city'));
		}
	});

	$('#sel-city').change(function(){
		var val = $(this).val();
		if(!val){
			$('#sel-dist').find('option:gt(0)').remove();
		}else{
			appendDist(val, $('#sel-dist'));
		}
	});

	$('[name=addr_id]').live('click', function(e, targetIndex){
		$('#address-list li').removeClass('selected');
		if(targetIndex == null){
			$('[name=addr_id]:checked').parent().addClass('selected');
		}else{
			$('#address-list li').eq(targetIndex).addClass('selected');
		}

		if($('#deal-buy-address-other').is(':checked')){
			$('#add-addr-field').show();
		}else{
			$('#add-addr-field').hide();
		}

		if($('#deal-buy-address-not-required').is(':checked')){
			$('#no-addr-field').show();
			$('#deal-delivery-type').hide();
		}else{
			$('#no-addr-field').hide();
			$('#deal-delivery-type').show();
		}
	});

	// 删除收货地址
	$('.cart-addr-del').live('click', function(e){
		e.preventDefault();

		var li = $(this).closest('li');
		var id = li.find('input').val();
		var url = Conf.getAppPath('/my/deladdr.htm');
		$.post(url, {id: id}, function(r){
			if(r.error){
				alert(r.error);
				return;
			}

			if(li.is('.selected')){
				$('#deal-buy-address-not-required').attr('checked', true).trigger('click');
			}
			li.remove();
		});

		return false;
	});

	// 新增其他收货地址
	$('#btn-save-addr').click(function(){
		var data = {};

		var keys = 'prov city dist addr addr_code addr_name mobile';
		var arr = keys.split(' ');
		var i = 0;
		for(; i < arr.length; i++){
			var key = arr[i];
			var input = $('#add-addr-field').find('[name="{0}"]'.format(key));
			var val = input.val().trim();

			if(!val){
				var label = input.siblings('label');
				if(!label.length){
					label = input.parent().siblings('label');
				}
				alert('请填写{0}！'.format(label.text()));
				return false;
			}

			// 取省市名称非编号
			if('prov city dist'.indexOf(key) != -1){
				data[key + '_id'] = val;
				val = $('select[name="{0}"]'.format(key)).find('option:selected').text();
			}

			data[key] = val;
		}

		if(!isMobile(data.mobile)){
			alert('请填写有效的手机号码！');
			return;
		}
		if(!isAddrCode(data.addr_code)){
			alert('请填写有效的邮政编码！');
			return;
		}

		var url = Conf.getAppPath('/my/addaddr.htm');
		$.post(url, data, function(r){
			if(r.error){
				return;
			}

			// 更新收货列表并选择新增的地址
			refreshAddrList([r]);
			var radioLl = $('[name=addr_id]');
			// 新增的在其他、无需送货之前
			var targetIndex = radioLl.length - 3;
			radioLl.eq(targetIndex).trigger('click', targetIndex);
			$('#add-addr-field').hide();
		});

		return false;
	});

	// 登录窗口
	$('#J-login-button').click(function(){
		var content = $('#login-window').html();
		$.dialog({
			title: '登录', 
			lock: true,
			width: '400px',
			height: '200px',
			max: false,
			min: false,
			content: content,
			init: function(){
				var loginVal = Conf.getCookie('loginVal');
				if(loginVal){
					$('#login-win-username').val(loginVal);
				}
			},
			ok: function(){
				var flag = true;

				var username = $('#login-win-username').val();
				var pwd = $('#login-win-pwd').val();
				if(!username || !pwd){
					$('.login-win .error-tip').text('请输入用户名和密码！').show();
					flag = false;
				}else{
					var url = Conf.getAppPath('/loginpostajax.htm');
					$.ajax({
						url: url,
						async: false, 
						type: 'POST',
						data: {mobile: username, pwd: pwd, referAddrList: '1'}, 
						dataType: 'text', 

						success: function(txt){
							var item = JSON.parse(txt);
							if(item.error){
								$('.login-win .error-tip').text(item.error).show();
								flag = false;
							}else{
								// 登录成功
								flag = true;
								Conf.loginUser = item.user;
								Conf.changeAsLogin();

								// 收货地址
								if(item.addrList){
									refreshAddrList(item.addrList);
								}
							}
						}, 

						error: function(xhr, statusText){
							$('.login-win .error-tip').text('请求失败！').show();
							flag = false;
						}
					}); 
				}
				return flag;
			},
			cancel: true
		});
	});
});