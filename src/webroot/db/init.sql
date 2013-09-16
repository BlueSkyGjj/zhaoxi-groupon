create table if not exists t_user (
	id int auto_increment primary key,
	email varchar(100), 
	mobile varchar(20), 
	pwd varchar(50), 
	third_part varchar(20),
	nickname varchar(50), 
	level int, 
	qq varchar(20), 
	sina varchar(100), 

	points int not null default 0, 

	verifycode varchar(10), 

	dd timestamp default current_timestamp
);
create index idx_user_nickname on t_user(nickname);

--- 每日签到记录
create table if not exists t_user_daysign (
	id int auto_increment primary key,
	uid int not null, 
	dat varchar(20), 
	dd timestamp default current_timestamp
);
create index idx_user_daysign_uid on t_user_daysign(uid);

create table if not exists t_user_login_log (
	id int auto_increment primary key,
	uid int, 

	dd timestamp default current_timestamp
);
create index idx_user_login_log_uid on t_user_login_log(uid);

create table if not exists t_user_addr (
	id int auto_increment primary key,
	uid int, 
	prov varchar(20), 
	city varchar(20),
	dist varchar(50),
	addr varchar(200),
	addr_code varchar(10), 
	mobile varchar(20), 
	addr_name varchar(20), 

	status char(1) default '1', 
	dd timestamp default current_timestamp
);
create index idx_user_addr_uid on t_user_addr(uid);

create table if not exists t_city (
	code varchar(20),
	name varchar(100)
);

create table if not exists t_cate (
	pcode varchar(20), 
	code varchar(20),
	name varchar(100),
	cc int default 0, 
	seq int default 1
);

create table if not exists t_addr (
	pcode varchar(20), 
	code varchar(20),
	name varchar(100),
	cc int default 0, 
	seq int default 1
);

create table if not exists t_seatnum (
	pcode varchar(20), 
	code varchar(20),
	name varchar(100),
	cc int default 0, 
	seq int default 1
);

create table if not exists t_pricerange (
	pcode varchar(20), 
	code varchar(20),
	name varchar(100),
	cc int default 0, 
	seq int default 1
);

-- 商家
create table if not exists t_store (
	id int auto_increment primary key,
	code varchar(50), 
	pwd varchar(50), 
	name varchar(100), 
	des varchar(500),

	cate varchar(20), 
	addr varchar(20), 

	contact varchar(20), 
	email varchar(100), 
	mobile varchar(20), 
	qq varchar(20), 
	sina varchar(100), 

	is_special tinyint not null default 0, 
	is_special_new tinyint not null default 0, 
	special_nav_name varchar(20), 

	dd timestamp default current_timestamp
);
create index idx_store_name on t_store(name);


create table if not exists t_product (
	id int auto_increment primary key,
	cate varchar(20), 
	city varchar(20), 
	addr varchar(20), 

	pricerange varchar(20), 
	seatnum varchar(20), 

	type varchar(20), 
	points int default 0,

	store_id int, 

	code varchar(20), 
	brand varchar(100), 
	name varchar(100), 
	des varchar(200), 
	price double, 
	price_import double, -- 进货价
	price_market double, 
	discount double,
	discount_my double, -- 提成

	pub_date long, 
	end_date long, 
	sale_num int default 0, 

	image_index varchar(200), 

	mark varchar(20), 

	dd timestamp default current_timestamp
);
create index idx_prod_type on t_product(type);
create index idx_prod_cate on t_product(cate);
create index idx_prod_city on t_product(city);
create index idx_prod_addr on t_product(addr);
create index idx_prod_pricerange on t_product(pricerange);
create index idx_prod_seatnum on t_product(seatnum);
create index idx_prod_name on t_product(name);
create index idx_prod_pub_date on t_product(pub_date);
create index idx_prod_status on t_product(status);
create index idx_prod_store_id on t_product(store_id);

create table if not exists t_product_img (
	id int auto_increment primary key,
	pid int, 
	type varchar(10), 
	seq int default 1, 
	title varchar(200), 
	des varchar(1000), 
	path varchar(200), 

	dd timestamp default current_timestamp
);
create index idx_prod_img_pid on t_product_img(pid);

create table if not exists t_product_price_detail (
	id int auto_increment primary key,
	pid int, 
	type varchar(10), 
	seq int default 1, 
	content varchar(100), 
	price varchar(20), 
	num varchar(20), 
	price_total varchar(20)
);
create index idx_prod_price_detail_pid on t_product_price_detail(pid);

create table if not exists t_order (
	id int auto_increment primary key,
	order_no varchar(20), 
	uid int, 

	amount double, 
	delivery_amount double, 

	addr_id int, 

	addr_mobile varchar(20), 
	addr_msg varchar(200),

	delivery_type char(1) default '0', -- default no_delivery
	delivery_msg varchar(200),

	status char(1) default '1',
	feedback char(1) default '0',

	trade_no varchar(30),
	pay_dd date, 
	dd timestamp default current_timestamp
);
create index idx_order_uid on t_order(uid);
create index idx_order_order_no on t_order(order_no);

create table if not exists t_order_product (
	id int auto_increment primary key,
	order_id int, 
	pid int, 
	price_import double, 
	price double, 
	price_market double, 
	num int default 1
);
create index idx_order_prod_order_id on t_order_product(order_id);
create index idx_order_prod_pid on t_order_product(pid);

-- 评价
create table if not exists t_product_rate (
	id int auto_increment primary key,
	uid int, 
	pid int, 
	rate int, 
	msg varchar(1000), 

	dd timestamp default current_timestamp
);
create index idx_product_rate_pid on t_product_rate(pid);

-- 留言板
create table if not exists t_leavemsg (
	id int auto_increment primary key,
	name varchar(50), 
	mobile varchar(50), 
	content varchar(1000), 

	dd timestamp default current_timestamp
);

-- 合作
create table if not exists t_feedback (
	id int auto_increment primary key,
	name varchar(50), 
	mobile varchar(50), 
	bizname varchar(200), 
	addr varchar(200), 
	contacts varchar(1000), 
	content varchar(1000), 

	dd timestamp default current_timestamp
);

-- 友情链接设置
create table if not exists t_conf_link (
	id int auto_increment primary key,
	type varchar(20) default 'footer', 
	seq int default 1, 
	label varchar(50), 
	link varchar(200), 
	pic varchar(200), 
	target varchar(10) default '_blank', 

	dd timestamp default current_timestamp
);

-- 系统参数设置
create table if not exists t_conf_sys (
	id int auto_increment primary key,
	type varchar(20) default 'sys', 
	seq int default 1, 
	name varchar(20), 
	value varchar(200)
);

-- 短信日志
create table if not exists t_sms_log (
	id int auto_increment primary key,
	msg varchar(500), 
	mobile varchar(1000)
);

-- 批量短信发送队列
create table if not exists t_sms_queue (
	id int auto_increment primary key,
	encode varchar(50), 
	msg varchar(500), 
	mobile varchar(2000),
	status int default 0,
	send_dd datetime, 
	dd timestamp default current_timestamp
);
create index idx_sms_queue_encode on t_sms_queue(encode);

-- 批量邮件发送队列
create table if not exists t_email_queue (
	id int auto_increment primary key,
	encode varchar(50), 
	title varchar(200), 
	content varchar(2000), 
	email varchar(2000),
	status int default 0,
	send_dd datetime, 
	dd timestamp default current_timestamp
);
create index idx_email_queue_encode on t_email_queue(encode);


