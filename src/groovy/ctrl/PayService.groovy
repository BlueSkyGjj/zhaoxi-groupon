package ctrl

import java.net.URLEncoder
import com.paic.webx.tool.*

import org.apache.log4j.Logger

class PayService {
	static Logger log = Logger.getLogger(PayService.class)

	static Map genPayParams4Alipay(String orderNo, double price, String showUrlSuf){
		final String encoding = 'utf-8'
		final String site = 'www.zhaoxigo.com'

		String hostPre = 'http://segment11.oicp.net'
		final String notifyUrl = hostPre + '/zhaoxi/pay/notify.htm'
		final String payedReturnUrl = hostPre + '/zhaoxi/pay/payed.htm'

		String partnerId = '2088002238219944'
		String securityCode = 'rufx1wa9qc2tx0re1l0h0rwmfzprx5o0'
		String sellerEmail = '7462004@qq.com'

		def r = [:]

		// create_direct_pay_by_user=直接付款,trade_create_by_buyer 担保付款    
		r['service'] = 'create_direct_pay_by_user' 
		r['partner'] = partnerId
		r['_input_charset'] = encoding
		// 支付类型 1=商品购买,2=服务购买
		r['payment_type'] = 2
		// 客户付款后,支付宝调用的页面
		r['notify_url'] = notifyUrl
		// 客户付款成功后,显示给客户的页面   
		r['return_url'] = payedReturnUrl 
		// 你的支付宝账户email
		r['seller_email'] = sellerEmail 

		// 外部交易号,最好具有唯一性,在获取支付宝发来的付款信息时使用
		r['out_trade_no'] = orderNo
		// 填写在跳到支付宝页面上显示的付款标题信息   
		r['subject'] = site + '的订单'
		// 订单金额信息   
		r['total_fee'] = price 

		// 填写在跳到支付宝页面上显示的付款内容信息
		r['body'] = '您在' + site + '上的订单，订单编号' + orderNo 
		r['show_url'] = hostPre + showUrlSuf

		// 防钓鱼时间戳
//		r['anti_phishing_key'] = ''
		// 非局域网的外网IP地址
//		r['exter_invoke_ip'] = ''

		mergeConf(r)

		// 获取sign
		r.sign = getSign(r, securityCode)
		r.sign_type = 'MD5'

		return r
	}

	private static void mergeConf(Map r){
		// 网站设置，如果有支付部分的配置，就优先使用
		final String confKeyPre = 'alipay_'
		def confSysList = Service.getConfSysList()
		if(!confSysList)
			return

		for(one in confSysList){
			String key = one.name
			if(!key.startsWith(confKeyPre))
				continue

			r[key.substring(confKeyPre.size())] = one.value
		}
	}

	private static String getSign(Map r, String securityCode){
		List keys = new ArrayList(r.keySet())
		keys.sort()

		def sb = new StringBuffer()
		int i = 0
		for(; i < keys.size(); i++){
			String key = keys[i]

			sb << key
			sb << '='
			sb << r[key]
			if(i != keys.size() -1)
				sb << '&'
		}
		sb << securityCode
		log.info(sb.toString())
		return MD5.encode(sb.toString())
	}
}