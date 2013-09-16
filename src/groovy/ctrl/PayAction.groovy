package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import com.alipay.api.*

import biz.db.*

class PayAction extends BaseAction {
	def Map topay(Map params){
		// for test TODO
		Map requestValues = PayService.genPayParams4Alipay('082119_4_888', 1.0, '/zhaoxi/deal/5.htm')
		def ll = []
		requestValues.each{k, v ->
			ll << [name: k, value: v]
		}
		return [v: 'pay/alipayform', ll: ll]
	}

	def Map notify(Map params){
		log.info(params)
		return [jsonObj: params]
	}

	def Map payed(Map params){
		log.info(params)

		String orderNo = params.out_trade_no
		String tradeNo = params.trade_no

		def dao = XDAO.gen()

		String sql = '''
			update t_order set status = ?, trade_no = ?, pay_dd = ? where order_no = ?
		'''
		dao.db.executeUpdate(sql, [Conf.STATUS_ORDER_SUCCESS, tradeNo, new Date(), orderNo])


		return [jsonObj: params]
	}
}