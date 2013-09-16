$(function(){
	var showTip = function(_tip, txt){
		_tip.text(txt).show().closest('.field-group').addClass('field-group--error');
	};

	var tipOn = function(txt, target){
		var _tip = $('#signup-tip');
		target.after(_tip.remove());
		showTip(_tip, txt);
		return false;
	};

	// signup
	if($('#email-signup-form').length){
		$('#reg-type li').click(function(){
			$('#signup-tip').hide();

			var llList = $('#reg-type li');
			var index = llList.index(this);
			llList.not(index).removeClass('current');
			llList.eq(index).addClass('current');

			if(0 == index){
				$('.field-mobile').hide();
				$('.field-email').show();
			}else{
				$('.field-email').hide();
				$('.field-mobile').show();
			}
		});

		$('#email-signup-form').submit(function(){
			var val = $('#email').val().trim();
			if($('#reg-type li:first').is('.current')){
				if(!isEmail(val)){
					tipOn('请填写有效的邮箱地址！', $('#email'));
					return false;
				}
			}else{
				val = $('#mobile').val().trim();
				if(!isMobile(val)){
					tipOn('请填写有效的手机号码！', $('#mobile'));
					return false;
				}
			}

			val = $('#pwd').val().trim();
			if(!val || val.length < 6){
				tipOn('密码至少为6位数字或字母！', $('#pwd'));
				return false;
			}

			val = $('#pwd2').val().trim();
			if(!val || val.length < 6){
				tipOn('密码至少为6位数字或字母！', $('#pwd2'));
				return false;
			}

			if($('#pwd').val().trim() != $('#pwd2').val().trim()){
				tipOn('两次密码输入不一致！', $('#pwd2'));
				return false;
			}

			return true;
		});

		$('#email-signup-form input').blur(function(){
			var input = $(this);
			if(!input.val().trim()){
				var txt = input.siblings('label').text();

				var _tip = $('#signup-tip');
				input.after(_tip.remove());
				showTip(_tip, '请填写' + txt + '！');
			}else{
				input.closest('.field-group').removeClass('field-group--error');
				var _tip = input.siblings('#signup-tip');
				if(_tip.length){
					_tip.text('').hide();
				}
			}
		});
	}
	// *** end signup

	if($('#getpwd-form').length){
		// getpwd
		$('#btn-refresh-img').click(function(e){
			e.preventDefault();
			e.stopPropagation();

			var img = $('#signup-captcha-img');
			img.attr('src', 'verify.img?w=50&sysdate=' + new Date().getTime());
			return false;
		});

		$('#reset-email').blur(function(){
			var val = $('#reset-email').val().trim();
			if(!val){
				$('#reset-email-tip').text('请填写邮箱或手机号码！').show().
					closest('.field-group').addClass('field-group--error');
				return;
			}

			if(!isEmail(val) && !isMobile(val)){
				$('#reset-email-tip').text('请填写有效的邮箱或手机号码！').show().
					closest('.field-group').addClass('field-group--error');
				return;
			}

			$('#reset-email-tip').text('').show().
				closest('.field-group').removeClass('field-group--error');
		});
		$('#getpwd-form').submit(function(){
			var mobileOrEmail = $('#reset-email').val().trim();
			if(!mobileOrEmail){
				$('#reset-email-tip').text('请填写邮箱或手机号码！').show().
					closest('.field-group').addClass('field-group--error');
				return false;
			}

			var isLoginTypeMobile = isMobile(mobileOrEmail);
			var isLoginTypeEmail = isEmail(mobileOrEmail);
			if(!isLoginTypeMobile && !isLoginTypeEmail){
				$('#reset-email-tip').text('请填写有效的邮箱或手机号码！').show().
					closest('.field-group').addClass('field-group--error');
				return false;
			}

			if(!$('#captcha').val().trim()){
				$('#reset-email-tip').text('请填写验证码！').show().
					closest('.field-group').addClass('field-group--error');
				return false;
			}

			$('#login-type').val(isLoginTypeMobile ? 'mobile' : 'email');
			return true;
		});
	}
	// *** end getpwd

	if($('#login-form').length){
		var loginVal = Conf.getCookie('loginVal');
		if(loginVal){
			$('#mobile').val(loginVal);
			$('#remember-username').attr('checked', true);
		}

		if('true' == Conf.getCookie('autoLogin')){
			$('#autologin').attr('checked', true);
		}

		$('#login-form input').blur(function(){
			var input = $(this);
			if(!input.val().trim()){
				var txt = input.siblings('label').text();

				var _tip = $('#signup-tip');
				input.after(_tip.remove());
				showTip(_tip, '请填写' + txt + '！');
			}else{
				input.closest('.field-group').removeClass('field-group--error');
				var _tip = input.siblings('#signup-tip');
				if(_tip.length){
					_tip.text('').hide();
				}
			}
		});
		$('#login-form').submit(function(){
			var loginVal = $('#mobile').val().trim();
			var isValMobile = isMobile(loginVal);
			var isValEmail = isEmail(loginVal);

			if(!isValMobile && !isValEmail){
				tipOn('请填写有效的邮箱地址或手机号码！', $('#mobile'));
				return false;
			}
			$('#loginType').val(isValEmail ? 'email' : 'mobile');

			var pwd = $('#pwd').val().trim();
			if(!pwd || pwd.length < 6){
				tipOn('密码至少为6位数字或字母！', $('#pwd'));
				return false;
			}

			// remember me
			if($('#remember-username').is(':checked')){
				Conf.setCookie('loginVal', loginVal);
			}else{
				Conf.setCookie('loginVal', '', -1);
			}
			// auto login
			if($('#autologin').is(':checked')){
				var loginPwdEncoded = hex_md5(pwd);

				Conf.setCookie('autoLogin', 'true');
				Conf.setCookie('loginVal', loginVal);
				Conf.setCookie('loginPwdEncoded', loginPwdEncoded);
			}else{
				Conf.setCookie('autoLogin', '', -1);
				Conf.setCookie('loginPwdEncoded', '', -1);
			}

			return true;
		});

		// 手机、邮箱登陆
		$('#reg-type li.change-trigger').click(function(){
			var llList = $('#reg-type li.change-trigger');
			var index = llList.index(this);
			llList.not(index).removeClass('current');
			llList.eq(index).addClass('current');

			var labels = ['邮箱', '手机'];
			$('#loginTypeLabel').text(labels[index]);
		});

	}
});