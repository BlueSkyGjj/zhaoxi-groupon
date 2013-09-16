package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

/*
过滤action，通过filter.properties配置，实现简单的interceptor效果
*/
class FilterAction extends XAction{

	def Map addConfSys(Map params){
		if(!params)
			return null

		// 网站设置
		def confSite = Service.getConfSys()

		// 推荐链接，以英文逗号分隔
		if(confSite.recommandSearch){
			confSite.recommandSearchList = confSite.recommandSearch.split(',')
		}

		params.confSite = confSite

		log.info(confSite)
		return null
	}
}