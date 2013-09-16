package ctrl

class StyleService {
	// *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** ***
	// login
	static Map loginqq(){
		return [output: 'test']
	}

	static Map login(){
		return [v: 'auth/login', cssList: ['main', 'account'], 
			jsList: ['account', 'md5'], bodyId: 'login', noGoTop: true]
	}

	static Map signup(){
		return [v: 'auth/signup', cssList: ['main', 'account'], 
			jsList: ['account'], bodyId: 'signup', noGoTop: true]
	}

	static Map getpwd(){
		return [v: 'auth/getpwd', cssList: ['main', 'account'], 
			jsList: ['account'], bodyId: 'reset', noGoTop: true]
	}

	static Map getpwdpost(){
		return [v: 'auth/getpwdpost', cssList: ['main', 'account'], 
			jsList: ['account'], bodyId: 'reset', noGoTop: true]
	}

	// *** *** *** *** *** *** *** *** *** *** *** ***
	// *** *** *** *** *** *** *** *** *** *** *** ***
	static Map index(){
		return [v: 'index', cssList: ['main'], 
			jsList: [], bodyId: 'index']
	}

	static Map deal(){
		return [v: 'deal', cssList: ['deal', 'deal2'], 
			jsList: ['deal'], bodyId: 'deal-default']
	}

	static Map leavemsg(){
		return [v: 'leavemsg', cssList: ['main'], 
			jsList: ['feedback'], noGoTop: true]
	}

	static Map leavemsgpost(){
		return [v: 'leavemsgpost', cssList: ['main'], noGoTop: true]
	}

	static Map feedback(){
		return [v: 'feedback', cssList: ['main'], 
			jsList: ['feedback'], noGoTop: true]
	}

	static Map feedbackpost(){
		return [v: 'feedbackpost', cssList: ['main'], noGoTop: true]
	}

	// cart
	static Map cart(){
		return [v: 'cart', cssList: ['main', 'cart'], 
			jsList: ['cart'], bodyId: 'cart', noGoTop: true]
	}

	static Map cartcheck(){
		return [v: 'cartcheck', cssList: ['main', 'cartcheck'], 
			jsList: ['cart'], bodyId: 'cart-check', noGoTop: true]
	}

	// order 
	static Map orderlist(){
		return [v: 'my/orderlist', cssList: ['main', 'order'], 
			bodyId: 'orders', 
			noGoTop: true]
	}

	static Map order(){
		return [v: 'my/order', cssList: ['main', 'order'], 
			bodyId: 'order-detail', 
			noGoTop: true]
	}

	static Map pay(){
		return [v: 'my/pay', cssList: ['main', 'cartcheck'], 
			jsList: ['cart'], bodyId: 'cart-check', noGoTop: true]
	}

	// setting
	static Map setting(){
		return [v: 'my/setting', cssList: ['main', 'account'], 
			jsList: ['setting'], bodyId: 'settings', noGoTop: true,
			withAccountSetting: true]
	}

	static Map settingaddr(){
		return [v: 'my/settingaddr', cssList: ['main', 'account'], 
			jsList: ['setting'], bodyId: 'settings', noGoTop: true]
	}
}