package ctrl

import java.text.SimpleDateFormat

import com.paic.webx.core.*
import com.paic.webx.tool.*

class KindEditorAction extends XAction {
	private static final String SAVE_DIR = '/userfiles/'

	// 1M
	private int maxSize = 1024 * 1024
	private List extAllow = ['gif', 'jpg', 'jpeg', 'png', 'bmp']

	// kindeditor image upload
	def Map imgjson(Map params){
		String savePath = AppPath.getWarPath(SAVE_DIR)

		File targetDir = new File(savePath)
		if(!targetDir.exists() || !targetDir.isDirectory()){
			targetDir.mkdir()
		}

		if(!params._files){
			return [jsonObj: [error: '请选择文件。']]
		}

		def item = params._files.getOne(0)
		if(!item)
			return [jsonObj: [error: '请选择文件。']]

		if(item.binary.size() > maxSize)
			return [jsonObj: [error: '上传文件大小超过限制。']]

		if(!(item.fileExt in extAllow))
			return [jsonObj: [error: '文件格式不支持。']]

		String name = System.currentTimeMillis() + '_' + new Random().nextInt(1000) + '.' + item.fileExt
		try{
			item.saveToFile(new File(targetDir, name))
		}catch(e){
			return [jsonObj: [error: '上传文件失败。']]
		}

		String imgUrl = AppPath.WAR_NAME + SAVE_DIR + name

		// 网站设置
		def confSite = Service.getConfSys()
		if(confSite && confSite.host){
			imgUrl = confSite.host + imgUrl
		}

		return [jsonObj: [error:0, url: imgUrl]]
	}

	// kindeditor image file browser
	def Map filejson(Map params){
		String savePath = AppPath.getWarPath(SAVE_DIR)

		String path = params.path ?: ''
		String order = params.order ? params.order.toLowerCase() : 'name'
		if(path.indexOf('..') >= 0) 
			return [output: 'No Allow.']

		if(path && !path.endsWith('/')) 
			return [output: 'Parameter Invalid.']

		String upDirPath = ''
		if(path){
			String str = path.substring(0, path.size() - 1)
			int pos = str.lastIndexOf('/')
			upDirPath = pos >= 0 ? str.substring(0, pos + 1) : ''
		}

		// current directory
		File currentDir = new File(savePath + path)
		if(!currentDir.exists() || !currentDir.isDirectory()){
			currentDir.mkdir()
		}

		List files = []
		SimpleDateFormat ff = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss')
		currentDir.eachFile{
			files << [
				filename: it.name,
				datetime: ff.format(it.lastModified()),
				is_dir: it.isDirectory(), 
				has_file: it.isDirectory() && it.listFiles(),
				filesize: it.isFile() ? it.length() : 1L,
				is_photo: it.isFile() && extAllow.contains(it.name.substring(it.name.lastIndexOf('.') + 1).toLowerCase()),
				filetype: it.isFile() ? it.name.substring(it.name.lastIndexOf('.') + 1).toLowerCase() : ''
			]
		}

		files.sort{
			'name' == order ? it.name : ('type' == order ? it.filetype : it.filesize)
		}

		// return json data
		Map rr = [:]
		rr.moveup_dir_path = upDirPath
		rr.current_dir_path = path
		rr.current_url = AppPath.WAR_NAME + SAVE_DIR + path
		rr.total_count = files.size()
		rr.file_list = files

		return [jsonObj: rr]
	}
}
