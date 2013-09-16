$(function(){
	var calResize = function(){
		var contentHeight = $(window).height() - $('#header').height();
		$('#container').height(contentHeight);
		$('#content').height(contentHeight - $('#subheader').height() - 1);
		$('div#sidebar').css('min-height', $('a.menu').outerHeight() + $('ul.navigation.visible').outerHeight() + 50);
	};

	$(window).resize(function(){
		calResize();
	}).load(function(){
		calResize();
	});
});