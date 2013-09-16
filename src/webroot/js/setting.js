$(function(){
	if($('#address-form').length){
		// 取消，隐藏form
		$('#btn-reset').click(function(){
			var f = $('#address-form');
			f.find('input[type=hidden],input[type=text],select').val('');
			$('#btn-save').val('新增');
			f.slideUp();
		});

		$('#address-form').submit(function(){
			var data = {};
			$('#address-form').find('input[type=text],select').each(function(){
				data[this.name] = $(this).val();
				if($(this).is('select')){
					data[this.name + '_label'] = $(this).find('option:selected').text();
				}
			});

			if(!data.prov_id || !data.city_id || !data.dist_id){
				alert('请填写所在地区！');
				return false;
			}

			if(!data.addr){
				alert('请填写接到街道地址！');
				return false;
			}

			if(!data.addr_name){
				alert('请填写收货人名称！');
				return false;
			}

			if(!isMobile(data.mobile)){
				alert('请填写有效的手机号码！');
				return false;
			}

			if(!isAddrCode(data.addr_code)){
				alert('请填写有效的邮政编码！');
				return false;
			}

			var f = $('#address-form');

			f.find('input[name=prov]').val(data.prov_id_label);
			f.find('input[name=city]').val(data.city_id_label);
			f.find('input[name=dist]').val(data.dist_id_label);

			return true;
		});

		// 新增，显示form
		$('#link-add-addr').click(function(e){
			e.preventDefault();

			$('#address-form input[type=hidden]').val('');
			$('#btn-save').val('新增');

			$('#address-form').slideDown();
			return false;
		});
		$('a.del-addr').click(function(e){
			e.preventDefault();

			var id = $(this).attr('attr-id');
			var url = Conf.getAppPath('/my/deladdr.htm');

			var _this = $(this);
			$.post(url, {id: id}, function(r){
				if(r.error){
					alert(r.error);
					return;
				}

				_this.closest('tr').remove();
			});

			return false;
		});
		$('a.edit-addr').click(function(e){
			var id = $(this).attr('attr-id');
			var url = Conf.getAppPath('/my/getaddr.htm?id=' + id);
			$.get(url, function(r){
				if(!r.flag){
					alert(r.msg);
					return;
				}

				if(!r.item){
					alert('无法获取地址信息！');
					return;
				}

				var item = r.item;

				var f = $('#address-form');
				f.find('input[type=hidden]').val(item.id);
				f.find('[name=mobile]').val(item.mobile);
				f.find('[name=addr_name]').val(item.addrName);
				f.find('[name=addr_code]').val(item.addrCode);
				f.find('[name=addr]').val(item.addr);

				$('#sel-prov').val(item.provId).trigger('change', [item.cityId, item.distId]);

				$('#btn-save').val('保存');

				f.slideDown();
			});
			return false;
		});

		// 省市关联
		var appendDist = function(pid, sel, targetId, callback){
			var url = Conf.getAppPath('/getDistLl.htm?pid=' + pid);
			$.get(url, function(r){
				sel.find('option:gt(0)').remove();

				var tpl = '<option value="{0}" {2}>{1}</option>';

				var arr = [];
				var i = 0;
				for(; i < r.ll.length; i++){
					var one = r.ll[i];

					var inner = '';
					if(targetId && one.regionId == targetId){
						inner = tpl.format(one.regionId, one.regionName, 'selected')
					}else{
						inner = tpl.format(one.regionId, one.regionName, '')
					}

					arr.push(inner);
				}
				sel.append(arr.join(''));

				if(callback){
					callback.call();
				}
			});
		};

		$('#sel-prov').change(function(e, targetCityId, targetDistId){
			var val = $(this).val();
			if(!val){
				$('#sel-city').find('option:gt(0)').remove();
			}else{
				if(targetDistId){
					appendDist(val, $('#sel-city'), targetCityId, function(){
						$('#sel-city').trigger('change', [targetDistId]);
					});
				}else{
					appendDist(val, $('#sel-city'), targetCityId);
				}
			}
		});

		$('#sel-city').change(function(e, targetId){
			var val = $(this).val();
			if(!val){
				$('#sel-dist').find('option:gt(0)').remove();
			}else{
				appendDist(val, $('#sel-dist'), targetId);
			}
		});
	}

	// *** *** *** *** ***
	if($('#settings-info-container').length){
		// 对话框关闭
		$('.mt-dialog .close').click(function(e){
			$(this).closest('.dialog-wrapper').hide();
			$('#dialog-overlay').hide();
		});

		// 获取验证码
		$('#mobile-verify').click(function(e){
			var mobile = $('#mobile-input').val().trim();
			if(!mobile || !isMobile(mobile)){
				alert('请输入有效的手机号码！');
				return;
			}

			var url = Conf.getAppPath('/my/getverifycode.htm');
			$.post(url, {mobile: mobile}, function(r){
				if(!r.flag){
					$('#setting-mobile').find('.error').text('发送验证码失败！').show();
					return;
				}

				$('#mobile-verify-tip').text('验证码已经发送，请注意查收！').show();
				$('#setting-mobile').find('.error').text('').hide();
			});
		});

		// 
		$('#settings-mobile-rebind-form').submit(function(){
			var mobile = $('#mobile-input').val().trim();
			if(!mobile || !isMobile(mobile)){
				alert('请输入有效的手机号码！');
				return false;
			}

			var verifycode = $('#verify-code').val().trim();
			if(!verifycode || verifycode.length != 6){
				alert('请输入有效的6位验证码！');
				return false;
			}

			return true;
		});

		// 
		$('#settings-email-rebind-form').submit(function(){
			var email = $('#email-input').val().trim();
			if(!email || !isEmail(email)){
				alert('请输入有效的邮箱地址！');
				$('#email-input').focus();
				return false;
			}

			return true;
		});

		// 
		$('#settings-nickname-rebind-form').submit(function(){
			var nickname = $('#nickname-input').val().trim();
			if(!nickname){
				alert('请输入您的昵称！');
				$('#nickname-input').focus();
				return false;
			}

			return true;
		});

		// 
		$('#settings-password-rebind-form').submit(function(){
			var pwdOld = $('#password-old').val().trim();
			var pwd = $('#password-input').val().trim();
			var pwd2 = $('#password2-input').val().trim();

			if(!pwdOld){
				alert('请输入当前密码！');
				$('#password-old').focus();
				return false;
			}
			if(!pwd){
				alert('请输入新密码！');
				$('#password-input').focus();
				return false;
			}
			if(!pwd2){
				alert('请输入确认密码！');
				$('#password2-input').focus();
				return false;
			}
			if(pwd != pwd2){
				alert('新密码和确认密码不一致！');
				$('#password2-input').focus();
				return false;
			}

			return true;
		});

		// 打开对话框
		$('.settings-mobile-rebind').click(function(e){
			$('#setting-mobile,#dialog-overlay').show();
		});
		$('.settings-email-rebind').click(function(e){
			$('#setting-email,#dialog-overlay').show();
		});
		$('.settings-nickname-reset').click(function(e){
			$('#setting-nickname,#dialog-overlay').show();
		});
		$('.settings-password-reset').click(function(e){
			$('#setting-password,#dialog-overlay').show();
		});
	}
});