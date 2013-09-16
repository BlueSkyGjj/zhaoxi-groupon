$(function(){
	var showTip = function(_tip, txt){
		_tip.text(txt).show().closest('.field-group').addClass('field-group--error');
	};

	if($('#feedback-form').length){
		$('#feedback-form').submit(function(){
			var tipOn = function(txt, target){
				var _tip = $('#signup-tip');
				target.after(_tip.remove());
				showTip(_tip, txt);
				return false;
			};

			var val = $('#feedback-name').val().trim();
			if(!val){
				tipOn($('#feedback-name').attr('data-tips'), $('#feedback-name'));
				return false;
			}

			val = $('#feedback-mobile').val().trim();
			if(!val){
				tipOn($('#feedback-mobile').attr('data-tips'), $('#feedback-mobile'));
				return false;
			}
			if(!isMobile(val)){
				tipOn('请填写有效的电话号码', $('#feedback-mobile'));
				return false;
			}

			val = $('#feedback-addr').val().trim();
			if(!val){
				tipOn($('#feedback-addr').attr('data-tips'), $('#feedback-addr'));
				return false;
			}

			val = $('#feedback-bizname').val().trim();
			if(!val){
				tipOn($('#feedback-bizname').attr('data-tips'), $('#feedback-bizname'));
				return false;
			}

			val = $('#feedback-content').val().trim();
			if(!val){
				tipOn($('#feedback-content').attr('data-tips'), $('#feedback-content'));
				return false;
			}

			return true;
		});

		$('#feedback-form input').blur(function(){
			var input = $(this);
			var txt = input.attr('data-tips');
			if(!input.val().trim() && txt){
				var _tip = $('#signup-tip');
				input.after(_tip.remove());
				showTip(_tip, txt);
			}else{
				input.closest('.field-group').removeClass('field-group--error');
				var _tip = input.siblings('#signup-tip');
				if(_tip.length){
					_tip.text('').hide();
				}
			}
		});
	}


	if($('#leavemsg-form').length){
		$('#leavemsg-form').submit(function(){
			var tipOn = function(txt, target){
				var _tip = $('#signup-tip');
				target.after(_tip.remove());
				showTip(_tip, txt);
				return false;
			};

			var val = $('#leavemsg-name').val().trim();
			if(!val){
				tipOn($('#leavemsg-name').attr('data-tips'), $('#leavemsg-name'));
				return false;
			}

			val = $('#leavemsg-mobile').val().trim();
			if(!val){
				tipOn($('#leavemsg-mobile').attr('data-tips'), $('#leavemsg-mobile'));
				return false;
			}
			if(!isMobile(val)){
				tipOn('请填写有效的电话号码', $('#leavemsg-mobile'));
				return false;
			}

			val = $('#leavemsg-content').val().trim();
			if(!val){
				tipOn($('#leavemsg-content').attr('data-tips'), $('#leavemsg-content'));
				return false;
			}

			return true;
		});

		$('#leavemsg-form input').blur(function(){
			var input = $(this);
			var txt = input.attr('data-tips');
			if(!input.val().trim() && txt){
				var _tip = $('#signup-tip');
				input.after(_tip.remove());
				showTip(_tip, txt);
			}else{
				input.closest('.field-group').removeClass('field-group--error');
				var _tip = input.siblings('#signup-tip');
				if(_tip.length){
					_tip.text('').hide();
				}
			}
		});
	}
});