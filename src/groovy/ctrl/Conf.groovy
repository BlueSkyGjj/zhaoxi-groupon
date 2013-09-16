package ctrl

class Conf{
	/*
	order_status_label_for_1=暂未付款
	order_status_label_for_2=付款失败
	order_status_label_for_3=交易成功
	order_status_label_for_4=取消订单
	order_status_label_for_5=已过期
	order_status_label_for_9=已经删除
	*/
	static int STATUS_ORDER_NEW = 1
	static int STATUS_ORDER_PAY_FAIL = 2
	static int STATUS_ORDER_SUCCESS = 3
	static int STATUS_ORDER_CANCEL = 4
	static int STATUS_ORDER_OVERTIME = 5
	static int STATUS_ORDER_DELETED = 9

	static int STATUS_PROD_ON = 1
	static int STATUS_PROD_OFF = 0


	// delivery
	// 无需送货
	static int DELI_NO_NEED = 0

}