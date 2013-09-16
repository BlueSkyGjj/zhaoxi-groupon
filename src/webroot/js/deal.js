if (!window.console) {
	window.console = {};
}
if (!window.console.log) {
	window.console.log = function() {};
}
$(function() {
	// 滚动图片
	var dealImgList = $('#deal-img-list li');

	if(dealImgList.length){
		var imgLinkList = $('#img-list a');
		imgLinkList.click(function() {
			var imgLink = $(this);
			imgLinkList.not(imgLink).removeClass('active');
			imgLink.addClass('active');

			var index = imgLinkList.index(this);
			var targetDealImg = dealImgList.eq(index);

			dealImgList.not(targetDealImg).fadeOut();
			targetDealImg.fadeIn();
		});

		var intervalImgChange;
		var flagImgChange = true;
		var startImgChange = function() {
			if (intervalImgChange)
				return;

			var intervalImgChange = setInterval(function() {
				if (!flagImgChange) {
					console.log('Skip as hover...');
					return;
				}

				var currentActiveLink = imgLinkList.filter('.active');
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

		$('#deal-img-list').hover(function() {
			flagImgChange = false;
		},
		function() {
			flagImgChange = true;
		});
	}

	// image lazy load
	$('img[data-original]').lazyload({
		effect: 'fadeIn'
	});

	// 添加购入车
	$('#cart-bottum .close').live('click', function(){
		$('#cart-bottum').hide();
	});
	$('a.link-add-cart').click(function(e){
		e.preventDefault();
		e.stopPropagation();

		// show cart image TODO
		var offset = $(this).offset();

		var props = {};
		props.position = 'absolute';
		props.left = offset.left + 120;
		props.top = offset.top - 100;

		var menu = $('#cart-bottum');
		if(!menu.length){
			menu = $('<div id="cart-bottum"><div class="dropdown-menu dropdown-menu--deal dropdown-menu--cart dropdown-menu--loading"></div></div>');
		}
		menu.css(props).appendTo($('body')).show();

		var id = $(this).attr('attr-id');
		var url = Conf.getAppPath('/ctrl/CartAction/getCartData.gy?id=' + id);
		$.get(url, function(ll){
			if(ll && ll.needlogin){
				var referUrl = Conf.getAppPath('/deal/' + id + '.htm');
				document.location.href = Conf.getAppPath('/cart.htm?referUrl=' + referUrl);
				return;
			}

			var tpl;
			if(!ll || !ll.length){
				tpl = '<ul><li class="dropdown-menu__item" style="text-align: center;">没有商品！</li></ul>';
			}else{
				var i = 0;
				for(; i < ll.length; i++){
					var item = ll[i];
					item.url = Conf.getAppPath('/deal/' + item.id + '.htm');
				}
				var data = {ll: ll, withClose: true, app_name: window.appname};
				tpl = Conf.formatTpl('tplItemOne', data);
			}

			menu.find('.dropdown-menu').html(tpl).removeClass('dropdown-menu--loading');
		});

		return false;
	});
});