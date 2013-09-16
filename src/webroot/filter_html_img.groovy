// 匹配css文件中的image路径的正则  
def	pat	= /.+src="(http[^\"]+)".+/

def getImageName = {url ->
	String imageUrl = url.contains('?') ? url[0..url.lastIndexOf('?') - 1] : url
	return imageUrl.split(/\//)[-1]
}

def	getImg = {url ->  
	String name = getImageName(url)
	def	targetFile = new File('./image-html/' + name)  
	if(!targetFile.exists()){  
		// 下载到文件  
		def	os = new FileOutputStream(targetFile)  
		os << new URL(url).openStream()	 
		println	'done for '	+ name	
	}else{	
		println	'skip for '	+ name	
	}  
}  
def	downImg	= {f ->	
	def	ll = []	 
	f.eachLine{	 
		def	mat	= it =~	pat	 
		if(mat){  
			String url = mat[0][1]
			try	{  
				getImg(url)	 
				String name = getImageName(url)
				it = it.replace(url, './image-html/' + name)  
				ll << it  
			}catch (ex)	{  
				ex.printStackTrace()  
			}  
		}else{	
			ll << it  
		}  
	}  
  
	// 文件内容重新替换，因为图片路径变化
	def os = new OutputStreamWriter(new FileOutputStream(f), 'utf-8')
	for(line in	ll){  
		os << line
		os << "\r\n"
	}
	os.close()
}  
  
downImg(new File('deal.html'))