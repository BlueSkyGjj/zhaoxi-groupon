import groovy.sql.Sql

def p = [
	u: 'root', 
	p: '', 

	driver: 'com.mysql.jdbc.Driver', 
	url: 'jdbc:mysql://localhost:3306/zhaoxi?useUnicode=true&characterEncoding=utf-8'
]

String src = '''
top,meishi,餐饮美食
meishi,huoguo,火锅
meishi,xican,西餐
meishi,zhongcan,中餐
meishi,xiawucha,下午茶
meishi,dangaochadian,蛋糕甜点
top,yule,休闲娱乐
yule,ktv,KTV
yule,jiudian,酒店
yule,dianying,电影
yule,lvyou,旅游
yule,zuliao,足疗按摩
top,fuwu,生活服务
fuwu,meifa,美发
fuwu,meirong,美容美甲
fuwu,qiche,汽车养护
fuwu,sheji,家装设计
fuwu,jiaoyu,教育培训
'''
String table = 't_cate'

src = '''
top,all,全部
top,malujie,马路街
top,taishanlu,泰山路
'''
table = 't_addr'

src = '''
top,all,全部
top,1-2,1-2人
top,3-4,3-4人
top,5-8,5-8人
'''
table = 't_seatnum'

def ll = src.readLines().grep{it.trim()}.collect{
	it.split(/,/)
}

def db = Sql.newInstance(p.url, p.u, p.p, p.driver)
try {
	db.execute('delete from ' + table)
	String sql = """
	insert into ${table}(pcode, code, name) values(?, ?, ?)
	"""
	ll.each{
		db.executeInsert(sql, it)
	}
}catch (ex) {
    ex.printStackTrace()
}
finally {
    db.close()
}