package ctrl

import biz.db.*

import com.paic.webx.tool.*
import org.apache.log4j.Logger

class AuthService {
	static Logger log = Logger.getLogger(AuthService.class)

	static Map addUserLoginLog(int uid){
		def dao = XDAO.gen()
		dao.add([uid: uid], 't_user_login_log', false)
	}

	static Map addUserDaysign(int uid){
		def dao = XDAO.gen()
		// 今日是否已经签到
		String dat = new Date().format('yyyy-MM-dd')
		def item = dao.queryMap('select id from t_user_daysign where uid = ? and dat = ?', [uid, dat])

		def r = [flag: true]

		// 未签到
		if(!item){
			// TODO
			// 每日签到只添加一个积分
			dao.db.executeUpdate('update t_user set points = points + 1 where id = ?', [uid])
			dao.add([uid: uid, dat: dat], 't_user_daysign', false)
		}else{
			r.duplicate = true
		}

		def user = dao.queryMap('select points from t_user where id = ?', [uid])
		r.points = user.points
		return r
	}

	// 注册
	static Map addUser(Map params){
		String keys = 'email mobile pwd pwd2'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return [error: '参数缺失！']

		if(!item.email && !item.mobile)
			return [error: '邮箱、手机号码必须有一个！']

		if(!item.pwd || !item.pwd2)
			return [error: '参数缺失！']

		if(item.pwd != item.pwd2)
			return [error: '两次密码输入不一致！']

		item.remove('pwd2')

		String sqlEmail = 'select id from t_user where email = ?'
		String sqlMobile = 'select id from t_user where mobile = ?'

		def dao = XDAO.gen()

		// 判断是否已经注册
		Map one = null
		String tips = '邮箱'
		if(item.email){
			item.remove('mobile')
			one = dao.queryMap(sqlEmail, [item.email])
		}else{
			item.remove('email')
			one = dao.queryMap(sqlMobile, [item.mobile])
			tips = '手机号码'
		}

		if(one){
			log.info('user already exists : ' + item)
			return [error: '该' + tips + '已经存在！']
		}

		item.pwd = MD5.encode(item.pwd)
		def id = dao.add(item, 't_user', true)
		return [id: id, email: item.email, mobile: item.mobile]
	}

	// 登录
	static Map getUser(Map params){
		String keys = 'mobile pwd loginType'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return [error: '参数缺失！']

		if(!item.mobile || !item.pwd)
			return [error: '邮箱、手机号码、密码没有填写！']

		String sqlEmail = 'select * from t_user where email = ? and pwd = ?'
		String sqlMobile = 'select * from t_user where mobile = ? and pwd = ?'
		String sqlMobileOrEmail = 'select * from t_user where (mobile = ? or email = ?) and pwd = ?'

		def dao = XDAO.gen()

		Map user = null

		if(item.loginType){
			List argv = [item.mobile, MD5.encode(item.pwd)]
			if('email' == item.loginType){
				user = dao.queryMap(sqlEmail, argv)
			}else{
				user = dao.queryMap(sqlMobile, argv)
			}
		}else{
			List argv = [item.mobile, item.mobile, MD5.encode(item.pwd)]
			user = dao.queryMap(sqlMobileOrEmail, argv)
		}

		if(user){
			// 今日是否已经签到
			String dat = new Date().format('yyyy-MM-dd')
			user.isDaysign = dao.queryMap('select id from t_user_daysign where uid = ? and dat = ?', [user.id, dat]) != null
		}

		return user
	}

	// 自动登录
	static Map getUserByPwdEncoded(Map params){
		String keys = 'loginVal loginPwdEncoded'
		def item = Utils.getByKeys(params, keys)
		if(!item)
			return [error: '参数缺失！']

		if(!item.loginVal || !item.loginPwdEncoded)
			return [error: '邮箱、手机号码、密码没有填写！']

		String sqlQuery = 'select * from t_user where (email = ? or mobile = ?)and pwd = ?'
		List argv = [item.loginVal, item.loginVal, item.loginPwdEncoded]

		def dao = XDAO.gen()
		def user = dao.queryMap(sqlQuery, argv)
		if(user){
			// 今日是否已经签到
			String dat = new Date().format('yyyy-MM-dd')
			user.isDaysign = dao.queryMap('select id from t_user_daysign where uid = ? and dat = ?', [user.id, dat]) != null
		}
		return user
	}

	static Map getUserByLogin(String login, String loginType){
		String sql = 'select id from t_user where email = ?'
		if('mobile' == loginType)
			sql = 'select id from t_user where mobile = ?'

		def dao = XDAO.gen()
		return dao.queryMap(sql, [login])
	}

	// 为找回密码，设置验证码
	static void updateVerifycode4getpwd(int uid, String verifycode){
		def dao = XDAO.gen()
		def item = [id: uid, verifycode: verifycode]
		dao.update(item, 't_user', '')
	}

	static boolean checkVerifycode4getpwd(String uid, String verifycode){
		def dao = XDAO.gen()
		String sql = 'select id from t_user where id = ? and verifycode = ?'
		def user = dao.queryMap(sql, [uid, verifycode]) 
		return user != null
	}

	// 重置新密码
	static void resetPwd(String uid, String newPwd){
		def dao = XDAO.gen()
		def item = [id: uid, pwd: MD5.encode(newPwd)]
		dao.update(item, 't_user', '')
	}

	// 合并地址说明
	static void mergeAddr(Map it){
		it.des = it.addrName + ' - ' + [it.prov, it.city, it.dist, it.addr, it.addrCode, it.mobile].join(',')
	}

	static void mergeAddrUnderline(Map it){
		it.des = it.addr_name + ' - ' + [it.prov, it.city, it.dist, it.addr, it.addr_code, it.mobile].join(',')
	}

	// 获取地址列表
	static List getAddrList(int uid){
		def dao = XDAO.gen()
		def ll = dao.query('select * from t_user_addr where status = ? and uid = ?', ['1', uid])
		if(!ll)
			return ll

		for(it in ll){
			mergeAddr(it)
		}
		return ll
	}

	static Map getAddrById(int uid, String id){
		def dao = XDAO.gen()
		def it = dao.queryMap('select * from t_user_addr where status = ? and uid = ? and id = ?', 
			['1', uid, id])

		if(it)
			mergeAddr(it)

		return it
	}
}
