package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

class TestAction extends XAction {
	def Map test(Map params){
		return [v: 'test', itemList: 1..20]
	}

	def Map md5(Map params){
		return [output: MD5.encode(params.key ?: '18620304494')]
	}

	def Map reloadConf(Map params){
		AppConf.reload()
		return [output: 'ok']
	}

	def Map viewConf(Map params){
		return [jsonObj: AppConf.loadConf()]
	}
}