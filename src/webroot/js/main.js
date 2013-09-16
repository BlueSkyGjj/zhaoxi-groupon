var Main = {};

// site-nav history show
//Main.addHistory = function(){
//
//};
//Main.getHistoryList = function(){
//	return [];
//};
//
//Main.getHistoryTpl = function(){
//	var ll = [];
//	var data = {ll: ll};
//	var tpl = Conf.formatTpl('tplItemOne', data);
//};

Main.getCartTpl = function(fn){
	var url = Conf.getAppPath('/ctrl/CartAction/getCartData.gy');

	$.ajax({
		url: url,
		async: false, 
		type: 'GET',
		dataType: 'text', 

		success: function(txt){
			var ll = JSON.parse(txt);
			var tpl;
			if(!ll || !ll.length){
				tpl = '<ul><li class="dropdown-menu__item" style="text-align: center;">没有商品！</li></ul>';
			}else{
				var i = 0;
				for(; i < ll.length; i++){
					var item = ll[i];
					item.url = Conf.getAppPath('/deal/' + item.id + '.htm');
				}
				var data = {ll: ll};
				tpl = Conf.formatTpl('tplItemOne', data);
			}
			fn(tpl);
		}, 

		error: function(xhr, statusText){
		}
	}); 
};

$(function() {
	if($('#J-go-top').length){
		$('#J-go-top').click(function() {
			$('body,html').animate({
				scrollTop: 0
			},
			1000);
			return false;
		});
		$(window).scroll(function(e) {
//			var _qrcode = $('#stick-qrcode');
			var _toTop = $('#J-go-top');
			var scrollTop = $(document).scrollTop();
			var docHeight = $(document).height();

			var headerHeight = $('#hdw').height();
			var mainHeight = $('#bdw').height();
			var footerHeight = $('#ftw').height();

			// $('#bdw').height() + $('#hdw').height() - $(window).height()
			if (scrollTop > 20) {
				_toTop.fadeIn();
			} else {
				_toTop.fadeOut();
			}

			if (scrollTop > mainHeight + headerHeight - $(window).height()) {
				_toTop.css({
					bottom: (100 + 50) + 'px'
				});
			} else {
				_toTop.css({
					bottom: '50px'
				});
			}

//			var bottomHeight = docHeight - scrollTop;
//			if (bottomHeight < 700) {
//				_qrcode.css({
//					top: '50px'
//				});
//			}
//			if (bottomHeight > mainHeight) {
//				_qrcode.css({
//					top: '150px'
//				});
//			}
		});
	}

	// 我的团品
	if($('#J-my-account-nav').length){
		$('#J-my-account-nav').hover(function(){
			$('#J-my-account-menu').show();
		}, function(){
			$('#J-my-account-menu').hide();
		});
	}
	if($('#J-my-cart-nav').length){
		$('#J-my-cart-nav').hover(function(){
			$('#J-my-cart').show();
		}, function(){
			$('#J-my-cart').hide();
		});
	}

	// cart view
//	if($('#J-my-cart-nav').length){
//		var menu = $('#J-my-cart-menu');
//		$('#J-my-cart').mouseover(function(){
//			menu.fadeIn('normal', function(){
//				Main.getCartTpl(function(tpl){
//					menu.html(tpl).removeClass('dropdown-menu--loading');
//				});
//			});
//		});
//
//		$('#J-my-cart-menu').mouseout(function(){
//			menu.hide().html('').addClass('dropdown-menu--loading');
//		});
//	}

	// history view
//	if($('#J-my-history').length){
//		var menu = $('#J-my-history-menu');
//		$('#J-my-history').hover(function(){
//			menu.fadeIn('normal', function(){
//				// show history list
//				var tpl = Main.getHistoryTpl();
//				menu.html(tpl).removeClass('dropdown-menu--loading');
//			});
//		}, function(){
//			menu.hide().html('').addClass('dropdown-menu--loading');
//		});
//	}

	// image lazy load
	$('img[data-original]').lazyload({
		effect: 'fadeIn'
	});

	// 截止时间
	var refreshEndTime = function(){
		var now = new Date();
		var currentTimeMillis = now.getTime();
		var dayMillis = 60 * 60 * 24 * 1000;
		$('.item-time').each(function(){
			var timeEnd = $(this).attr('attr-time-end');
			if(!timeEnd)
				return;

			var monthSub = timeEnd.substr(5, 2);
			if('0' == monthSub.substr(0, 1)){
				monthSub = parseInt(monthSub.substr(1, 1)) - 1;
			}else{
				monthSub = parseInt(monthSub) - 1;
			}

			var dd = new Date(timeEnd.substr(0, 4), monthSub, timeEnd.substr(8, 2));
			var endTimeMillis = dd.getTime();

			if(endTimeMillis <= currentTimeMillis){
				$(this).find('ul').html('<li><span class="item-time-over">已经结束<span></li>');
				return;
			}

			var diff = endTimeMillis - currentTimeMillis;
			var dayDiff = Math.floor(diff / dayMillis);
			var hourDiff = Math.floor((diff - dayDiff * dayMillis) / (60 * 60 * 1000));
			var minDiff = Math.floor((diff - dayDiff * dayMillis - hourDiff * 60 * 60 * 1000) / (60 * 1000));

			var spans = $(this).find('ul span');
			spans.eq(0).text(dayDiff);
			spans.eq(1).text(hourDiff);
			spans.eq(2).text(minDiff);
		});
	};

	// 一分钟更新一次
	refreshEndTime();
	setInterval(refreshEndTime, 1000 * 60);
});