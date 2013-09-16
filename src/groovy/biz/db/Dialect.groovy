package biz.db

import org.apache.commons.lang.StringUtils
import com.paic.webx.tool.NamingStyleUtils

// complex ** query sql not support
class Dialect {
	static final String RS_COLUMN = 'NUMS'
	boolean limitSupport = true

	// oracle 9i etc.
	String pagi(String sql, int offset, int limit) {
		sql = sql.trim().toLowerCase()
		def sb = new StringBuffer()

		if(!limitSupport){
			sb << "select * from (select xxx.*, rownum as rrr from ("
			sb << sql
			sb << ") xxx) ttt where ttt.rrr > "
			sb << offset
			sb << " and ttt.rrr <= "
			sb << offset + limit
		}else{
			// mysql style
			sb << "select ttt.* from ("
			sb << sql
			sb << ") ttt limit "
			sb << offset
			sb << ","
			sb << limit
		}

		return sb.toString()
	}

	String getCountSql(String sql){
		sql	= sql.trim().toLowerCase()
		def sb = new StringBuffer()

		sb << "select count(*) as "
		sb << RS_COLUMN
		sb << "	from ("
		sb << sql
		sb << ") ttt"

		return sb.toString()
	}

	// use java instead
	// camel <-> _
	static String toCamel(String str){
		return NamingStyleUtils.toCamel(str)
//		if(!str || str.size() <= 1)
//			return str

//		String r = str.toLowerCase().split('_').collect{cc -> StringUtils.capitalize(cc)}.join('')
//		return r[0].toLowerCase() + r[1..-1]
	}

	static String toUnderline(String str){
		return NamingStyleUtils.toUnderline(str)
//		if(!str || str.size() <= 1)
//			return str

//		str = str[0].toLowerCase() + str[1..-1]
//		return str.collect{cc -> ((char)cc).isUpperCase() ? '_' + cc.toLowerCase() : cc}.join('')
	}

	static void main(args){
		def dialect = new Dialect()
		dialect.limitSupport = false

		String sql = 'select region_name from t_region'
		println dialect.pagi(sql, 0, 5)
		println dialect.getCountSql(sql)
	}
}