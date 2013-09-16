$(document).ready(function() {
	$(".dropdown ul li").hover(function(){
    $('ul:first',this).each(function() {
      if ( $(this).parents("ul ul").length==0 ) {
        var center = ( $(this).parent('li').width() - $(this).width() ) / 2
        $(this).css({ left: center });
      }

      $(this).css({visibility: 'visible' });
    });
    
	}, function(){
    $('ul:first',this).css('visibility', 'hidden');
	});
	
  $("#menu ul li ul li ul").parent("li").addClass("submenu");
});