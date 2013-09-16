$(function(){
	// user already login or not
	Conf.changeAsLogin = function(){
		$('.item-auth-nologin').hide();
		$('.item-auth-login').show();

		$('#J-login-user').text(Conf.getUserLabel());
		if(Conf.loginUser.mobile){
			$('.item-login-mobile').val(Conf.loginUser.mobile);
		}

		// 积分
		$('#showSigninfo').text('您的积分为' + Conf.loginUser.points);
	};
	Conf.changeAsNotLogin = function(){
		$('.item-auth-login').hide();
		$('.item-auth-nologin').show();

		var currentUri = document.location.href;
		var pos = currentUri.indexOf('?');
		if(pos > 0)
			currentUri = currentUri.substring(0, pos);

		var needLogin = false;

		var i = 0;
		for(; i < Conf.needLoginUriLl.length; i++){
			var one = Conf.needLoginUriLl[i];
			if(currentUri.indexOf(one) >= 0){
				needLogin = true;
				break;
			}
		}

		if(needLogin){
			document.location.href = Conf.getAppPath('/');
		}
	};

	if(Conf.isLogin){
		if(!Conf.loginUser){
			var getUserLoginUrl = Conf.getAppPath('/loginuser.htm');
			$.get(getUserLoginUrl, function(data){
				Conf.loginUser = data;
				Conf.changeAsLogin();

				if(!data){
					// get session user failed
				}
			});
		}else{
			Conf.changeAsLogin();
		}
	}else{
		Conf.changeAsNotLogin();

		// auto login
		if('true' == Conf.getCookie('autoLogin')){
			var loginVal = Conf.getCookie('loginVal');
			var loginPwdEncoded = Conf.getCookie('loginPwdEncoded');

			if(loginVal && loginPwdEncoded){
				var autologinUrl = Conf.getAppPath('/autologin.htm');
				$.post(autologinUrl, {loginVal: loginVal, loginPwdEncoded: loginPwdEncoded}, function(data){
					if(data && data.flag){
						Conf.isLogin = true;
						Conf.loginUser = data.user;
						Conf.changeAsLogin();
					}else{
						// login failed
					}
				});
			}
		}
	}

	// logout click
	$('#J-logout').click(function(e){
		$.get(Conf.getAppPath('/logout.htm'), function(data){
			if(data.flag){
				Conf.setCookie('autoLogin', '', -1);

				Conf.isLogin = false;
				Conf.loginUser = null;
				Conf.changeAsNotLogin();
			}
		});
		return false;
	});

	// add referUrl 
	var loginUrlSrc = $('#J-login').attr('href');
	$('#J-login').attr('href', loginUrlSrc + '?referUrl=' + getReferUrl());

	// scroll pictures
	if($('#player').length){
		$('#player').delegate('span', 'click', function(){
			var index = $('#player span').index(this);

			$('#player li.on').removeClass('on').hide();
			$('#player li').eq(index).addClass('on').fadeIn();

			$('#player span.on').removeClass('on');
			$(this).addClass('on');
		});

		var dealImgList = $('#player li');
		var imgLinkList = $('#player span');

		var intervalImgChange;
		var flagImgChange = true;
		var startImgChange = function() {
			if(intervalImgChange)
				return;

			var intervalImgChange = setInterval(function() {
				if (!flagImgChange) {
					console.log('Skip as hover...');
					return;
				}

				var currentActiveLink = imgLinkList.filter('.on');
				if (currentActiveLink.length) {
					var currentIndex = imgLinkList.index(currentActiveLink[0]);
					var targetIndex = currentIndex < (imgLinkList.length - 1) ? (currentIndex + 1) : 0;
					if(currentIndex != targetIndex){
						console.log('Change image to ' + targetIndex);
						imgLinkList.eq(targetIndex).trigger('click');
					}
				}
			},
			1000 * 3);
		};

		startImgChange();

		$('#player ul').hover(function() {
			flagImgChange = false;
		},
		function() {
			flagImgChange = true;
		});
	}

	// hot links
	$('a.hot-link').click(function(e){
		e.preventDefault();
		e.stopPropagation();
		var q = $(this).attr('attr-q');
		$('#search-q').val(q);
		$('#search-q-form').submit();
		return false;
	});

	// daysign
	$('#link-daysign').click(function(e){
		e.preventDefault();
		e.stopPropagation();

		// check if login already
		if(!Conf.isLogin){
			document.location.href = Conf.getAppPath('/login.htm');
			return false;
		}

		var url = Conf.getAppPath('/daysign.htm');
		$.get(url, function(r){
			if(!r.flag && r.needlogin){
				document.location.href = Conf.getAppPath('/login.htm');
			}else{
				$('#showSigntip').text('今日已签到');
				$('#showSigninfo').text('您的积分为' + r.points);
				if(r.duplicate){
					// 提示重复签到
					alert('今日已经签到！');
				}
			}
		});

		return false;
	});

	// 收藏
	$('#link-favorite').click(function(){
		var title = '朝夕购 - 漯河朝夕购将打造漯河团购网第一品牌';
		var url = 'http://www.zhaoxigo.com';

		if(document.all){
			window.external.AddFavorite(url, title);
		}else if(window.opera && window.print){
			return true; 
		} 
	});
});
