package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class CartAction extends BaseAction {

	private boolean addCart(String id, List cartLl, boolean addNum){
		// 已经存在
		def one = cartLl.find{it.id == id}
		if(one){
			if(addNum){
				one.num = (one.num ?: 1) + 1
			}
			return true
		}

		def prod = Service.getProductBrief(id)
		if(!prod)
			return false

		// 不存在
		def item = [:]
		item.id = id
		item.num = 1
		item << prod

		cartLl << item
	}

	private void delCart(String id, List cartLl){
		cartLl.removeAll{it.id == id}
	}

	private void updateCart(String id, String num, List cartLl){
		if(!(num ==~ /^\d+$/))
			num = '1'

		def one = cartLl.find{it.id == id}
		if(one){
			one.num = Integer.parseInt(num)
		}
	}

	// 显示购物车页面
	def Map cart(Map params){
		// 先判断是否登录
		if(!params.s_user)
			return needlogin('/cart.htm')

		List cartLl = params.s_cartLl ?: []

		// 新增产品到购物车
		if(params.id && params.id ==~ /^\d+$/){
			if(!addCart(params.id, cartLl, true)){
				log.warn('Add product that not exists!')
			}
		}

		def r = [s_cartLl: cartLl]

		// 购物车容量
		final int allCartSize = 20
		r.cartLlLength = cartLl.size()
		r.cartLlLengthPercent = Utils.round('' + r.cartLlLength / allCartSize * 100, 0)

		if(params.s_user){
			// 省列表
			r.provLl = Service.getProvLl()
			// 收货地址
			r.addrList = AuthService.getAddrList(params.s_user.id)
		}

		r << StyleService.cart()
		return r
	}

	// 显示支付页面
	def Map cartcheck(Map params){
		if('POST' != params._method){
//			log.error('Access pay page not post!')
//			return null
			return cart(params)
		}

		// 先判断是否登录
		if(!params.s_user)
			return needlogin('/cart.htm')

		// 购物车无商品
		if(!params.s_cartLl){
			def r = cart(params)
			r.commonError = '购物车中没有任何物品！'
			return r
		}
		
		Map orderInfo = null

		// 无需送货
		boolean noDelivery = false
		if('-1' == params.addr_id){
			if(!params.addr_mobile){
				def r = cart(params)
				r.commonError = '请填写有效的手机号码！'
				return r
			}

			// 下订单，无需送货类型
			orderInfo = OrderService.addOrder(params, true)
			noDelivery = true
		}else{
			// 下订单
			orderInfo = OrderService.addOrder(params, false)
		}

		if(!orderInfo){
			def r = cart(params)
			r.commonError = '下单失败！'
			return r
		}

		// send sms TODO

		def r = [:]
		r.orderInfo = orderInfo
		r.cartSummary = getCartSummary(params.s_cartLl)

		r.noDelivery = noDelivery
		if(noDelivery){
		}else{
			r.delivery = AuthService.getAddrById(params.s_user.id, params.addr_id)
			if(r.delivery){
				def conf = AppConf.loadConf()

				r.delivery.type = params.delivery_type
				r.delivery.timeDes = conf['delivery_time_des_' + r.delivery.type]
			}
		}

		r << StyleService.cartcheck()
		r.s_del_cartLl = true
		return r
	}

	private Map getCartSummary(List cartLl){
		double amount = 0
		for(one in cartLl){
			amount += one.price * one.num
		}

		def item = [:]
		item.amount = amount
		return item
	}

	// get cart data by ajax
	def Map getCartData(Map params){
		// 先判断是否登录
		if(!params.s_user)
			return [jsonObj: ['needlogin': true]]

		List cartLl = params.s_cartLl ?: []
		if(params.id && params.id ==~ /^\d+$/){
			if(!addCart(params.id, cartLl, false)){
				log.warn('Add product that not exists!')
			}
		}

		return [s_cartLl: cartLl, jsonObj: cartLl]
	}

	// 清空购物车
	def Map clearCartData(Map params){
		def r = [jsonObj: [flag: true]]
		r.s_cartLl = []
		return r
	}

	def Map updateCart(Map params){
		List cartLl = params.s_cartLl ?: []

		boolean updateSessionCart = false

		// 删除购物车产品
		if(params.idDel){
			if(cartLl){
				delCart(params.idDel, cartLl)
				updateSessionCart = true
			}
		}

		// 更新购物车产品数量
		if(params.id && params.num){
			if(cartLl){
				updateCart(params.id, params.num, cartLl)
				updateSessionCart = true
			}
		}
	
		def r = [jsonObj: [flag: true]]
		if(updateSessionCart){
			r.s_cartLl = cartLl
		}
		return r
	}
}