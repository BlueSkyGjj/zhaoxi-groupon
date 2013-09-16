String mobile = '111,222,222'

List mobileList = mobile.split(',')
mobileList.unique()
//mobileList.sort{
//	0 - (it as int)
//}

println mobileList.toArray()