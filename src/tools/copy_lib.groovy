// write
//new File('jar_list.txt').withPrintWriter{w ->
//	new File('../../lib').eachFile{
//		w.println it.name
//	}
//}

// copy
def ant = new AntBuilder()
def jarNameLl = new File('jar_list.txt').readLines()
String dir = 'E:/ReferOld/jdic_test/libserver'
new File(dir).listFiles().grep{
	it.name in jarNameLl
}.each{
	ant.copy file: it.absolutePath, tofile: '../../lib/' + it.name
}
