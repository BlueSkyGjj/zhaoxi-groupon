import groovy.sql.Sql

def p = [
	u: 'root', 
	p: '', 

	driver: 'com.mysql.jdbc.Driver', 
	url: 'jdbc:mysql://localhost:3306/zhaoxi?useUnicode=true&characterEncoding=utf-8'
]

def lineKeys = [
	'cate',
	'city',
	'addr',
	'code',
	'image_index', 
	'brand', 
	'name', 
	'des', 
	'price', 
	'price_market', 
	'discount', 
	'pub_date', 
	'end_date',
	'sale_num',
	'mark'
]

def keySize = lineKeys.size()

def ll = new File('prod-item.txt').readLines().grep{it.trim()}
def itemLl = []

(0..<ll.size() / keySize).each{
	int begin = it * keySize
	int end = it * keySize + keySize
	def subLl = ll[begin..<end]
	def item = [:]
	subLl.eachWithIndex{line, i ->
		item[lineKeys[i]] = line
	}
	itemLl << item
}

def db = Sql.newInstance(p.url, p.u, p.p, p.driver)
try {
	String keys = lineKeys.join(',')
	String placeHoders = lineKeys.collect{'?'}.join(',')
	String sql = """
	insert into t_product(${keys}) values(${placeHoders})
	"""

	for(item in itemLl){
		db.executeUpdate('delete from t_product where code = ?', [item.code])
		db.executeInsert(sql, new ArrayList(item.values()))
	}
}catch (ex) {
    ex.printStackTrace()
}
finally {
    db.close()
}