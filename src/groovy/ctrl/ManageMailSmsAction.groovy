package ctrl

import com.paic.webx.core.*
import com.paic.webx.tool.*

import biz.db.*

class ManageMailSmsAction extends BaseAction {
	def Map index(Map params){
		return mail(params)
	}

	def Map mail(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		def r = [v: 'manage/mailsms/mail']
		return addBase(r)
	}

	def Map sms(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		def r = [v: 'manage/mailsms/sms']
		return addBase(r)
	}

	// ajax
	// 根据条件过滤发送邮件和短信的用户
	def Map filter(Map params){
		// login first
		if(!params.s_admin)
			return error('needlogin')

		String target = params.target ?: 'user'
		String type = params.type ?: 'email'
		String cate = params.cate ?: 'all'
		String addr = params.addr ?: 'all'
		String q = params.q

		def queryList = null
		if('user' == target)
			queryList = queryUser(type, cate, addr, q)
		else
			queryList = queryStore(type, cate, addr, q)

		return [jsonObj: [ll: queryList]]
	}

	private List queryUser(String type, String cate, String addr, String q){
		String sql = '''
		select email, mobile from t_user where 1 = 1
		'''

		if('email' == type)
			sql += ' and email is not null'
		else if('mobile' == type)
			sql += ' and mobile is not null'

		if(q && !q.contains(' ')){
			sql += " and (email like '%${q}%' or mobile like '%${q}%' or nickname like '%${q}%')"
		}

		def dao = XDAO.gen()
		return dao.query(sql)
	}

	private List queryStore(String type, String cate, String addr, String q){
		String sql = '''
		select name, email, mobile from t_store where 1 = 1
		'''
		List argv = []

		if(cate != 'all'){
			sql += ' and cate = ?'
			argv << cate
		}
		if(addr != 'all'){
			sql += ' and addr = ?'
			argv << addr
		}
		if(q && !q.contains(' ')){
			sql += " and (name like '%${q}%' or email like '%${q}%' or mobile like '%${q}%')"
		}

		if('email' == type)
			sql += ' and email is not null'
		else if('mobile' == type)
			sql += ' and mobile is not null'

		def dao = XDAO.gen()
		return dao.query(sql, argv)
	}

	def Map mailsend(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		String title = params.title
		String content = params.content
		def emailList = params.l_email
		log.info('Send email : ' + title)
		log.info('Send email : ' + content)
		log.info('Send email : ' + emailList)

		if(!title || !content){
			def r = mail([s_admin: params.s_admin])
			r.error = '请填写邮件标题和内容！'
			return r
		}

		if(!emailList){
			def r = mail([s_admin: params.s_admin])
			r.error = '请选择需要发送的邮件！'
			return r
		}

		// content 把图片路径以/开头的添加host
		// 网站设置
		def confSite = Service.getConfSys()
		if(confSite && confSite.host){
			def pat = /(?m)src="(\/[^"]+)"/
			def mat = content =~ pat
			for(gg in mat){
				String url = gg[1]
				content = content.replace(url, confSite.host + url)
			}
		}

		// 除重并根据邮箱类型排序
		emailList.sort{
			it.substring(it.indexOf('@') + 1)
		}
		addEmailQueue(title, content, emailList)


		def r = mail([s_admin: params.s_admin])
		r.success = '已经发送邮件！总数：' + emailList.size()
		return r
	}

	private int addEmailQueue(String title, String content, List emailList){
		final int batchSendSize = 50

		int len = emailList.size()
		// 添加到发送队列，一次发送50封邮件
		int totalPageNum = len % batchSendSize == 0 ? len / batchSendSize : len / batchSendSize + 1

		def dao = XDAO.gen()
		for(i in 0..<totalPageNum){
			int indexBegin = i * batchSendSize
			int indexEnd = i * batchSendSize + batchSendSize
			if(indexEnd > len)
				indexEnd = len

			def subList = emailList[indexBegin..<indexEnd]
			def item = [title: title, content: content, email: subList.join(',')]
			item.encode = new Date().format('yyyy-MM-dd HH:mm:ss,SSS')
			dao.add(item, 't_email_queue', false)
		}

		return totalPageNum
	}

	def Map smssend(Map params){
		// login first
		if(!params.s_admin)
			return [v: 'manage/login']

		String msg = params.msg
		def mobileList = params.l_mobile
		log.info('Send mobile : ' + msg)
		log.info('Send mobile : ' + mobileList)

		if(!msg){
			def r = sms([s_admin: params.s_admin])
			r.error = '请填写短信内容！'
			return r
		}

		if(!mobileList){
			def r = sms([s_admin: params.s_admin])
			r.error = '请选择需要发送短信的手机号码！'
			return r
		}

		addMobileQueue(msg, mobileList)

		def r = sms([s_admin: params.s_admin])
		r.success = '已经发送短信！总数：' + mobileList.size()
		return r
	}

	private int addMobileQueue(String msg, List mobileList){
		final int batchSendSize = 50

		int len = mobileList.size()
		// 添加到发送队列，一次发送50条短信
		int totalPageNum = len % batchSendSize == 0 ? len / batchSendSize : len / batchSendSize + 1

		def dao = XDAO.gen()
		for(i in 0..<totalPageNum){
			int indexBegin = i * batchSendSize
			int indexEnd = i * batchSendSize + batchSendSize
			if(indexEnd > len)
				indexEnd = len

			def subList = mobileList[indexBegin..<indexEnd]
			def item = [msg: msg, mobile: subList.join(',')]
			item.encode = new Date().format('yyyy-MM-dd HH:mm:ss,SSS')
			dao.add(item, 't_sms_queue', false)
		}

		return totalPageNum
	}

}