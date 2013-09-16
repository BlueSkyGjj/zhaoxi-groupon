(function(g){
	var easyTemplate = function(s, d) {
		if (!s) {
			return '';
		}
		if (s !== easyTemplate.template) {
			easyTemplate.template = s;
			easyTemplate.aStatement = easyTemplate
					.parsing(easyTemplate.separate(s));
		}
		var aST = easyTemplate.aStatement;
		var process = function(d2) {
			if (d2) {
				d = d2;
			}
			return arguments.callee;
		};
		process.toString = function() {
			return (new Function(aST[0], aST[1]))(d);
		};
		return process;
	};
	easyTemplate.separate = function(s) {
		var r = /\\'/g;
		var sRet = s.replace(
				/(<(\/?)#(.*?(?:\(.*?\))*)>)|(')|([\r\n\t])|(\$\{([^\}]*?)\})/g,
				function(a, b, c, d, e, f, g, h) {
					if (b) {
						return '{|}' + (c ? '-' : '+') + d + '{|}';
					}
					if (e) {
						return '\\\'';
					}
					if (f) {
						return '';
					}
					if (g) {
						return '\'+(' + h.replace(r, '\'') + ' || \'\')+\'';
					}
				});
		return sRet;
	};
	easyTemplate.parsing = function(s) {
		var mName, vName, sTmp, aTmp, sFL, sEl, aList, aStm = [ 'var aRet = [];' ];
		aList = s.split(/\{\|\}/);
		var r = /\s/;
		while (aList.length) {
			sTmp = aList.shift();
			if (!sTmp) {
				continue;
			}
			sFL = sTmp.charAt(0);
			if (sFL !== '+' && sFL !== '-') {
				sTmp = '\'' + sTmp + '\'';
				aStm.push('aRet.push(' + sTmp + ');');
				continue;
			}
			aTmp = sTmp.split(r);
			switch (aTmp[0]) {
			case '+macro':
				mName = aTmp[1];
				vName = aTmp[2];
	//			aStm.push('aRet.push("<!--' + mName + ' start--\>");');
				break;
			case '-macro':
	//			aStm.push('aRet.push("<!--' + mName + ' end--\>");');
				break;
			case '+if':
				aTmp.splice(0, 1);
				aStm.push('if' + aTmp.join(' ') + '{');
				break;
			case '+elseif':
				aTmp.splice(0, 1);
				aStm.push('}else if' + aTmp.join(' ') + '{');
				break;
			case '-if':
				aStm.push('}');
				break;
			case '+else':
				aStm.push('}else{');
				break;
			case '+list':
				aStm.push('if(' + aTmp[1] + '.constructor === Array){with({i:0,l:'
						+ aTmp[1] + '.length,' + aTmp[3] + '_index:0,' + aTmp[3]
						+ ':null}){for(i=l;i--;){' + aTmp[3] + '_index=(l-i-1);'
						+ aTmp[3] + '=' + aTmp[1] + '[' + aTmp[3] + '_index];' 
						+ 'if(!' + aTmp[3] + '){break;}');
				break;
			case '-list':
				aStm.push('}}}');
				break;
			default:
				break;
			}
		}
		aStm.push('return aRet.join("");');
		if (!vName) {
			aStm.unshift('var data = arguments[0];');
		}
		return [ vName, aStm.join('') ];
	};
	// end template

	String.prototype.format = function() {
		var args = arguments;
		return this.replace(/\{(\d+)\}/g, 
			function(m, i){
				return args[i];
			});
	};

	Date.prototype.format = function(pat){
		var year = this.getFullYear();
		var month = this.getMonth() + 1;
		var day = this.getDate();
		var hour = this.getHours();
		var minute = this.getMinutes();
		var second = this.getSeconds();
		// 两位补齐
		month = month > 9 ? month : "0" + month;
		day = day > 9 ? day : "0" + day;
		hour = hour > 9 ? hour : "0" + hour;
		minute = minute > 9 ? minute : "0" + minute;
		second = second > 9 ? second : "0" + second;

		pat = pat || "yyyy-MM-dd";
		pat = pat.replace(/yyyy/g, year);
		pat = pat.replace(/MM/g, month);
		pat = pat.replace(/dd/g, day);
		pat = pat.replace(/HH/gi, hour);
		pat = pat.replace(/mm/g, minute);
		pat = pat.replace(/ss/g, second);
		return pat;
	}

	g.isEmail = function(val){
		var pat = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		return pat.test(val);
	};
	g.isMobile = function(val){
		var pat = /^\d{11}$/;
		return pat.test(val);
	};
	g.isAddrCode = function(val){
		var pat = /^\d{5,10}$/;
		return pat.test(val);
	};
	g.isInt = function(val){
		var pat = /^\d+$/;
		return pat.test(val);
	};

	// begin configuration object
	var Conf = {appname: ''};
	if(g.appname){
		Conf.appname = '/' == g.appname ? '' : g.appname;
	}

	Conf.getAppPath = function(path){
		return this.appname + path;
	};

	// use easy template
	Conf.formatTpl = function(scriptId, data){
		var tpl = $('#' + scriptId).html();
		if(!tpl)
			return '';

		return easyTemplate(tpl, data).toString();
	};

	// cookie helper
	Conf.getCookie = function(cookieName) {
		var cookieStart = document.cookie.indexOf(cookieName);
		var cookieEnd = document.cookie.indexOf(";", cookieStart);
		return cookieStart == -1 ? '': unescape(document.cookie.substring(cookieStart + cookieName.length + 1, (cookieEnd > cookieStart ? cookieEnd: document.cookie.length)));
	};

	Conf.setCookie = function(cookieName, cookieValue, seconds, path, domain, secure) {
		var expires = new Date();
		expires.setTime(expires.getTime() + seconds);
		document.cookie = escape(cookieName) + '=' + escape(cookieValue)
		+ (expires ? '; expires=' + expires.toGMTString() : '')
		+ (path ? '; path=' + path: '/')
		+ (domain ? '; domain=' + domain: '')
		+ (secure ? '; secure': '');
	};

	// form
	Conf.bind = function(context, data){
		context.find('input,select,textarea').each(function(){
			$(this).val(data[this.name]);
		});
	};

	Conf.getFormData = function(context, pre){
		pre = pre || 'f_';
		var data = {};
		context.find('input,select,textarea').each(function(){
			data[pre + this.name] = $(this).val();
		});
		return data;
	};

	Conf.checkField = function(val, rules){
		if(!rules)
			return {flag: true};

		var arr = rules.split(' ');
		if(arr.indexOf('r') != -1 && !val)
			return {flag: false, tips: '不能为空！'};

		if(arr.indexOf('int') != -1 && val && !val.match(/^\d+$/))
			return {flag: false, tips: '请输入数字！'};

		if(arr.indexOf('percent') != -1 && val){
			var intVal = parseInt(val);
			if(intVal < 0 || intVal > 100)
				return {flag: false, tips: '请输入百分比例，大于0小于100！'};
		}

		// TODO add rule check

		return {flag: true};
	};

	Conf.checkFormData = function(context, data, pre){
		pre = pre || 'f_';

		var flag = true;
		context.find('input,select,textarea').each(function(){
			if(!flag)
				return;

			var val = data[pre + this.name];
			var r = Conf.checkField(val, $(this).attr('rules'));
			if(!r.flag){
				flag = false;
				Conf.tips($(this), r.tips);
			}else{
				Conf.tipsOff($(this));
			}
		});

		return flag;
	};

	Conf.tips = function(el, tips){
		tips = tips || el.attr('tips');

		var offset = el.offset();
		var top = (offset.top + 20);
		var left = (offset.left + 20);

		var id = 'tips_id_' + el.attr('name');

		// 如果该vtip的div已经存在，则修改其内容和css属性
		if($("#vtip_" + id).size() > 0){
			$("#vtip_" + id).html('<img class="vtip_arrow " src="' + Conf.getAppPath('/manage/images/vtip_arrow.png') + '" />' + tips)
				.css({"top": top + "px", "left": left + "px"});
		}else{
			var html = '<p id="vtip_' + id + '" class="vtip"><img class="vtip_arrow" src="' + Conf.getAppPath('/manage/images/vtip_arrow.png') + '" />' + tips + '</p>';
			$(html).css({"top": top + "px", "left": left + "px"}).appendTo($('body'));
		}
	};

	Conf.tipsOff = function(el){
		var id = 'tips_id_' + el.attr('name');
		$("#vtip_" + id).remove();
	};

	// auth
	Conf.getUserLabel = function(){
		if(!this.loginUser){
			return '未知用户';
		}

		// 第三方平台的用户
		if(this.loginUser.nickname){
			return this.loginUser.nickname;
		}

		// 本站注册用户默认是手机号码或邮箱地址
		return this.loginUser.mobile || this.loginUser.email;
	};

	Conf.needLoginUriLl = ['/my/', '/orderlist/', 'cartcheck.html'];

	g.Conf = Conf;
})(this);