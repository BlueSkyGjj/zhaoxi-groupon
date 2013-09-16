def f = new File('../')

def extLl = ['tpl', 'js', 'groovy', 'sql', 'xml']
def ll = []
f.eachFileRecurse{
	if(it.isFile() && it.name.split(/\./)[-1] in extLl){
		ll << it
	}
}

ll.each{
	println it
}

println ll.collect{it.readLines().size()}.sum()