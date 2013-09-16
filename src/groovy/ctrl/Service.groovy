package ctrl

import org.apache.log4j.Logger
import com.paic.webx.tool.*
import com.paic.webx.tool.cache.CacheServicer
import com.paic.webx.core.AppConf
import com.paic.webx.core.AppPath

import com.paic.webx.upload.FormFileBean

import biz.db.*

class Service {
	static Logger log = Logger.getLogger(Service.class)

	public static boolean isSae(){
		return 'true' == AppConf.c('sae-deploy')
	}

	private static Map list2Map(List ll){
		def item = [:]
		for(one in ll){
			item[one.code] = one.name
		}
		return item
	}

	private static List getCachedByTable(String table){
		def dao = XDAO.gen()
		return dao.cachedQuery('select * from ' + table + ' order by seq', 'cache_table_list_' + table)
	}

	// conf
	static List getConfLinkList(){
		def dao = XDAO.gen()
		return dao.cachedQuery('select * from t_conf_link order by type, seq', 'cache_table_list_t_conf_link')
	}

	// conf link
	static List getConfSysList(){
		def dao = XDAO.gen()
		return dao.cachedQuery('select * from t_conf_sys order by type', 'cache_table_list_t_conf_sys')
	}

	// 专场的品牌链接
	static List getBrandSpecialList(){
		def dao = XDAO.gen()
		return dao.cachedQuery('select id, code, is_special_new, special_nav_name from t_store where is_special = 1', 
			'cache_store_list_brand_special')
	}

	static void refreshBrandSpecialList(){
		def cache = CacheServicer.getInstance()
		cache.remove('cache_store_list_brand_special')
	}

	// conf system
	static Map getConfSys(){
		def ll = getConfSysList()
		def item = [:]
		for(one in ll){
			item[one.name] = one.value
		}
		return item
	}

	// 更新产品个数
	static void refreshCateAndAddrCc(){
		def dao = XDAO.gen()
		def llCate = dao.query('''
			select count(1) as cc, cate 
				from t_product where status = ? group by cate
		'''
		, [Conf.STATUS_PROD_ON])
		def llAddr = dao.query('''
			select count(1) as cc, addr 
				from t_product where status = ? group by addr
		'''
		, [Conf.STATUS_PROD_ON])
		def llSeat = dao.query('''
			select count(1) as cc, seat 
				from t_product where status = ? group by seat
		'''
		, [Conf.STATUS_PROD_ON])
		def llPrice = dao.query('''
			select count(1) as cc, pricerange 
				from t_product where status = ? group by pricerange
		'''
		, [Conf.STATUS_PROD_ON])

		List sqlBatchLl = []
		for(one in llCate){
			sqlBatchLl << "update t_cate set cc = ${one.cc} where code = '${one.cate}'"
		}
		for(one in llAddr){
			sqlBatchLl << "update t_addr set cc = ${one.cc} where code = '${one.addr}'"
		}
		for(one in llSeat){
			sqlBatchLl << "update t_seatnum set cc = ${one.cc} where code = '${one.seat}'"
		}
		for(one in llPrice){
			sqlBatchLl << "update t_pricerange set cc = ${one.cc} where code = '${one.pricerange}'"
		}

		dao.db.withBatch{stmt ->
			for(sql in sqlBatchLl){
				stmt.addBatch(sql)
			}
		}

		// clear cache
		def cache = CacheServicer.getInstance()
		cache.remove('cache_table_list_t_cate')
		cache.remove('cache_table_list_t_addr')
		cache.remove('cache_table_list_t_seatnum')
		cache.remove('cache_table_list_t_pricerange')
	}

	// 更新友情链接配置
	static void refreshConfLink(){
		// clear cache
		def cache = CacheServicer.getInstance()
		cache.remove('cache_table_list_t_conf_link')
	}

	static void refreshConfSys(){
		// clear cache
		def cache = CacheServicer.getInstance()
		cache.remove('cache_table_list_t_conf_sys')
	}

	// 请空分类、区域、配置等缓存
	static void refreshBaseCateAddr(){
		// clear cache
		def cache = CacheServicer.getInstance()
		cache.remove('cache_table_list_t_cate')
		cache.remove('cache_table_list_t_addr')
		cache.remove('cache_table_list_t_seatnum')
		cache.remove('cache_table_list_t_pricerange')
	}

	// cate
	static List getCateList(){
		return getCachedByTable('t_cate')
	}

	static Map getCates(){
		return list2Map(getCateList())
	}

	// addr
	static List getAddrList(){
		return getCachedByTable('t_addr')
	}

	static Map getAddrs(){
		return list2Map(getAddrList())
	}

	// seatnum
	static List getSeatList(){
		return getCachedByTable('t_seatnum')
	}

	static Map getSeats(){
		return list2Map(getSeatList())
	}

	// pricerange
	static List getPricerangeList(){
		return getCachedByTable('t_pricerange')
	}

	static Map getPriceranges(){
		return list2Map(getPricerangeList())
	}

	// province city dist
	static List getProvLl(){
		String sql = 'select region_id, region_name from t_region where parent_id = 1'
		def dao = XDAO.gen()
		return dao.cachedQuery(sql, 'cache_prov_list')
	}

	static List getDistLl(String pid){
		String sql = 'select region_id, region_name from t_region where parent_id = ?'
		def dao = XDAO.gen()
		return dao.query(sql, [pid])
	}

	// product
	static Map getProductBrief(String id){
		def dao = XDAO.gen()
		return dao.queryMap('''
			select code, brand, name, des, image_index, 
				price, price_market, discount from t_product 
				where id = ?
		'''
		, [id])
	}

	// product image
	static final String PROD_IMG_DIR = '/tmp/img/'
	static String writeImg(String pid, FormFileBean fileItem){
		String path = PROD_IMG_DIR + pid + '/' + UUID.randomUUID().toString() + '.' + fileItem.fileExt
		String filePath = AppPath.getWarPath(path)
		fileItem.saveToFile(new File(filePath))

		return AppPath.WAR_NAME + path
	}
	static boolean delImg(String pid, String absPath){
		if(!pid || !absPath)
			return false

		if(!absPath.startsWith(AppPath.WAR_NAME))
			return false

		String path = absPath.substring(AppPath.WAR_NAME.size())
		String filePath = AppPath.getWarPath(path)
		return new File(filePath).delete()
	}

	// 产品分类、地区名称
	static void filterItemExt(Map one){
		if(one.city){
		}

		if(one.cate){
			def cates = Service.getCates()
			one.cateName = cates[one.cate]
		}
		if(one.addr){
			def addrs = Service.getAddrs()
			one.addrName = addrs[one.addr]
		}
		if(one.seatnum){
			def seats = Service.getSeats()
			one.seatName = seats[one.seatnum]
		}
		if(one.pricerange){
			def priceranges = Service.getPriceranges()
			one.pricerangeName = priceranges[one.pricerange]
		}
	}

	// cart

	// feedback
	static void addFeedback(Map params){
		String keys = 'name mobile bizname addr contacts content'
		def item = Utils.getByKeys(params, keys)
		log.info(item)

		if(!item)
			return

		def dao = XDAO.gen()
		dao.add(item, 't_feedback', false)
	}

	// leavemsg
	static void addLeavemsg(Map params){
		String keys = 'name mobile content'
		def item = Utils.getByKeys(params, keys)
		log.info(item)

		if(!item)
			return

		def dao = XDAO.gen()
		dao.add(item, 't_leavemsg', false)
	}
}
