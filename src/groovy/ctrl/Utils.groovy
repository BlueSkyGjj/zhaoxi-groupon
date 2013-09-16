package ctrl

import biz.db.*

import com.paic.webx.core.*
import com.paic.webx.tools.*
import com.paic.webx.tool.mail.EmailSender

import org.apache.log4j.Logger
import com.github.kevinsawicki.http.HttpRequest

class Utils {
	static Logger log = Logger.getLogger(Utils.class)

	// cate
	static double round(String str, int num){
		return Double.valueOf(str).round(num)
	}

	static boolean isToday(Date dat){
		if(!dat)
			return false

		def today = new Date()
		return today.year == dat.year && today.month == dat.month && 
			today.date == dat.date
	}

	// 根据字符串以空格隔开，从params中获取新的参数键值对
	static Map getByKeys(Map params, String keys){
		def item = [:]
		keys.split(' ').each{
			item[it] = params[it]
		}
		return item
	}

	// 生成6位随即验证码，用于短信验证
	static String genVerifyCode(){
		def rand = new Random()
		String r = ''
		6.times{
			r += rand.nextInt(10)
		}
		return r
	}

	// 使用亿美的短信http接口发送
	static final String smsTargetUrl = 'http://sdkhttp.eucp.b2m.cn/sdkproxy/sendsms.action'
	static final String smsKey = '3SDK-TYD-0130-MDRQN'
	static final String smsPwd = '187495'

	// send sms
	static void sendSms(String mobile, String msg){
		def item = [:]
		item.mobile = mobile
		item.msg = msg

		def dao = XDAO.gen()
		dao.add(item, 't_sms_log', false)

		// 
		Map params = [:]
		params.cdkey = smsKey
		params.password = smsPwd
		params.phone = mobile
		params.message = msg

		String body = HttpRequest.post(smsTargetUrl, params, true).body()
		log.info('Send sms result : ' + body)
	}

	static void sendEmailSingle(String title, String content, String email){
		if(!title || !email || !content)
			return

		String[] to = [email]
		EmailSender.send(AppConf.c('stmp.email.from'), title, content, to)
	}

	static void sendSmsSingle(String title, String msg, String mobile){
		if(!title || !mobile || !msg)
			return

		// TODO
	}

	// 从t_email_queue队列中取记录，批量发送邮件
	static void sendEmailBatch(Map item){
		String title = item.title
		String email = item.email
		String content = item.content
		if(!title || !email || !content)
			return

		List emailList = email.split(',')
		emailList.unique()

		String[] to = emailList.toArray()

		// send(String from, String title, String content, String[] toList)
		EmailSender.send(AppConf.c('stmp.email.from'), title, content, to)
	}

	// 从t_sms_queue队列中取记录，批量发送短信
	static void sendSmsBatch(Map item){
		String mobile = item.mobile
		String msg = item.msg
		if(!mobile || !msg)
			return

		List mobileList = mobile.split(',')
		mobileList.unique()

		// TODO
	}

	// 密码找回的模板 TODO
	static String getTpl4getpwd(String type, int uid, String verifycode){
		if('email' == type){
			String url = 'http://localhost/zhaoxi/getpwdrepost.htm?uid=' + uid + '&verifycode=' + verifycode
			return """
				<p>朝夕购用户密码重置</p>
				<a href="${url}" title="点击链接重置密码">${url}</a>
			"""
		}else if('sms' == type){
			return '朝夕购用户密码重置，您的验证码是：' + verifycode
		}else{
			return ''
		}
	}
}
