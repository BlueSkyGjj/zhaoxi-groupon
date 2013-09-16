package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

// action基类，为子类提供公用方法
class BaseAction extends XAction {
	// ajax error
	protected Map error(String msg){
		return [jsonObj: [error: msg, flag: false, msg: msg]]
	}

	protected Map errorpage(){
		return [responseStatus: '404']
	}

	// add style
	protected Map end(Map r, String action){
		r << StyleService."${action}"()
		return r
	}

	protected Map needlogin(String suf){
		String referUrl = AppPath.WAR_NAME + suf
		log.info(referUrl)
		def r = [r_referUrl: referUrl]
		r << StyleService.login()
		return r
	}

	private static final List WEEK_DAY_NAME = ['日', '一', '二', '三', '四', '五', '六']
	protected Map addBase(Map r){
		// 分类和区域
		r.cateList = Service.getCateList()
		r.cates = Service.getCates()

		r.addrList = Service.getAddrList()
		r.addrs = Service.getAddrs()

		r.seatList = Service.getSeatList()
		r.seats = Service.getSeats()

		r.pricerangeList = Service.getPricerangeList()
		r.priceranges = Service.getPriceranges()

		// 友情链接
		r.confLinkList = Service.getConfLinkList()
		// 广告滚动
		if(r.confLinkList)
			r.confLinkListGuanggao = r.confLinkList.grep{'guanggao' == it.type}

		r.brandSpecialList = Service.getBrandSpecialList()

		// 签到的weekday
		int dayOfWeek = new Date().day
		r.weekday = '星期' + WEEK_DAY_NAME[dayOfWeek]

		return r
	}
}