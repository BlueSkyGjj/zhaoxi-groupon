package biz.db

class Pager implements Serializable {
	int pageNum = 1
	int pageSize = 10
	int totalCount = 0

	List ll = null

	public Pager(int c, int n){
		pageNum = c
		pageSize = n
	}

	public int getTotalPage(){
		return (totalCount % pageSize == 0)?totalCount/pageSize:(totalCount/pageSize + 1)
	}

	public int getStart(){
		return (pageNum - 1) * pageSize
	}

	public int getEnd(){
		if(totalCount < pageSize || !hasNext())
			return totalCount
		else
			return pageNum * pageSize
	}

	public boolean hasNext(){
		return pageNum < getTotalPage()
	}

	public boolean hasPre(){
		return pageNum > 1 && getTotalPage() > 1
	}

	public String genHtml(String style){
		style = style ?: 'digg'

		int totalPage = getTotalPage()
		String inner = ''

		// 有记录
		if(totalPage){
			def sb = new StringBuffer()
			String pre = '<a href="javascript:void();" class="piLink">' 
			String suf = '</a>'

			for(page in 1..totalPage){
				if(page == pageNum){
					sb << '<span class="current">'
					sb << page
					sb << '</span>'
				}else{
					sb << pre
					sb << page
					sb << suf
				}
			}
			inner = sb.toString()
		}

		String tpl = """
			<div class="${style}">
			<span style="font-size: 13px; color: blue;">总页数 - ${totalPage}</span>
			${inner}
			<span style="font-size: 13px; color: blue;">总记录数 - <span style="color: red;">${totalCount}</span></span>
			</div>
		"""

		return tpl
	}
}