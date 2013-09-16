package biz.db

import com.paic.webx.tool.NamingStyleUtils

import com.paic.webx.core.AppConf
import com.paic.webx.core.AppContext
import com.paic.webx.tool.cache.CacheServicer
import com.paic.webx.tool.LManager

import groovy.sql.Sql

import javax.sql.DataSource

class XDAO {
	Sql db
	Dialect dialect

	def logger = LManager.ltrace()

	public XDAO(Sql executor, boolean limitSupport){
		db = executor
		dialect = new Dialect()
		dialect.limitSupport = limitSupport
	}

	// *** *** *** ***
	// factory methods
	// hard coding...
	static XDAO gen(){
		def executor = AppContext.getContext().getBean('sqlExecutor')
		return new XDAO(executor, 'true' == AppConf.c('db_dialect_limit_support'))
	}
	// *** *** *** ***

	// cached refer
	def String genKey(String sql, List args){
		return sql + '--' + (args?(args.join(',')):'null')
	}

	def List cachedQuery(String sql, List args, String key){
		if(!key)
			key = genKey(sql, args)
		List ll = CacheServicer.getInstance().get(key)
		if(!ll){
			ll = query(sql, args)
			CacheServicer.getInstance().put(key, ll)
		}
		return ll
	}

	def List cachedQuery(String sql, String key){
		return cachedQuery(sql, null, key)
	}
	// cached refer end

	def List query(String sql, List args){
		if(!args)
			return query(sql)

		logger.debug(sql)
		logger.debug(args)

		def ll = db.rows(sql, args)
		logger.debug('Query resultset : ' + ll.size())
		return ll.collect{
			NamingStyleUtils.transform(it)

//			def r = [:] as HashMap
//			it.each{k, v ->
//				r[Dialect.toCamel(k)] = v
//			}
//			return r
		}
	}

	def List query(String sql){
		logger.debug(sql)

		def ll = db.rows(sql)
		logger.debug('Query resultset : ' + ll.size())
		return ll.collect{
			NamingStyleUtils.transform(it)

//			def r = [:] as HashMap
//			it.each{k, v ->
//				r[Dialect.toCamel(k)] = v
//			}
//			return r
		}
	}

	def Map queryMap(String sql, List args){
		List r = query(sql, args)
		if(r){
			logger.debug(r[0])
			return r[0]
		}
		return null
	}

	def Map queryMap(String sql){
		return queryMap(sql, null)
	}

	// do insert update or delete <-- map = request parameters
	// BigDecimal/int or void
	// Oracle 10.2.0.1.0版本后的JDBC才支持getGeneratedKeys特性。
	def List add(Map ext, String table, boolean isReturnKey){
		if(!ext)
			return null

		String sql = "insert into ${table} (" + 
			ext.keySet().collect{Dialect.toUnderline(it)}.join(',') + 
			") values (" + 
			ext.keySet().collect{'?'}.join(',') + ")"
		List args = new ArrayList(ext.values())

		logger.debug(sql)
		logger.debug(args)

		if(isReturnKey){
			def ll = db.executeInsert(sql, args)
			return ll[0]
		}else{
			db.executeUpdate(sql, args)
			return null
		}
	}

	def int update(Map ext, String table, String pkCol){
		if(!ext)
			return -1

		pkCol = pkCol ?: "id"
		def pkVal = ext[pkCol]

		ext.remove(pkCol)

		String sql = "update ${table} set " + 
			ext.keySet().collect{Dialect.toUnderline(it) + ' = ?'}.join(',') + 
			" where " + Dialect.toUnderline(pkCol) + " = ?"
		
		List args = new ArrayList(ext.values())
		args << pkVal

		logger.debug(sql)
		logger.debug(args)

		return db.executeUpdate(sql, args)
	}

	def int del(Object pkValue, String table, String pkCol){
		pkCol = pkCol ? Dialect.toUnderline(pkCol) : "id"
		String sql = "delete from ${table} where ${pkCol} = ?"

		logger.debug(sql)
		logger.debug(pkValue)

		return db.executeUpdate(sql, [pkValue])
	}

	def boolean exe(String sql, List args){
		logger.debug(sql)
		logger.debug(args)

		return db.execute(sql, args)
	}

	def boolean exe(String sql){
		logger.debug(sql)
		return db.execute(sql)
	}

	def int call(String sql, args){
		logger.debug(sql)
		logger.debug(args)

		return db.call(sql, args)
	}

	// pagination
	def Pager pagi(String sql, List args, int c, int n){
		Pager pi = new Pager(c, n)
		pi.ll = query(dialect.pagi(sql, pi.getStart(), n), args)
		if(pi.ll){
			Map countItem = queryMap(dialect.getCountSql(sql), args)
			logger.debug(countItem)
			// oracle returns bigdecimal
			pi.totalCount = countItem[Dialect.toCamel(Dialect.RS_COLUMN)] as int
		}
		return pi
	}	
}