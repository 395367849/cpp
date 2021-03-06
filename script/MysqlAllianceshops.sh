#!/bin/bash　　

HOSTNAME="127.0.0.1"                                           #数据库信息
PORT="3306"
USERNAME="wallet"
PASSWORD="Wallet1234"
DBNAME="walletdb"                                                       #数据库名称

echo "start..."

 #创建数据库
sql="create database IF NOT EXISTS ${DBNAME}"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${sql}"


#创建广告表格
#id 广告Id
#lPlatformId 平台号
#lAddTime  添加时间,unix微秒
#sAdvLink  广告链接（OSS地址或其它）
#iState 显示 1 隐藏 0
#iVerify 0未审核 1 审核通过 2 审核不过
sql="CREATE TABLE IF NOT EXISTS adv (
  id bigint NOT NULL AUTO_INCREMENT,
  lPlatformId bigint NOT NULL,
  lAddTime bigint NOT NULL,
  sAdvLink varchar(500) NOT NULL,
  iState int NOT NULL,
  iVerify int DEFAULT '0',
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"
sql=""
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建银行表格
#lPlatformId 平台号
#lAddTime 添加时间,unix微秒
#sName 用户名
#sAccount 帐号
#sBranch 支行
#sBank 银行
sql="CREATE TABLE IF NOT EXISTS bank (
  lPlatformId varchar(128) NOT NULL,
  lAddTime bigint NOT NULL,
  sName varchar(1024) NOT NULL,
  sAccount varchar(128) NOT NULL,
  sBranch varchar(1024) NOT NULL,
  sBank varchar(1024) NOT NULL,
  PRIMARY KEY (lPlatformId),
  CONSTRAINT FK_bank_lPlatformId FOREIGN KEY (lPlatformId) REFERENCES shopdal (sPrimaryKey)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建分类表格
#Id 分类Id
#sName 分类名
#sBigPic 大图标
#sSmallPic 小图标
#sZone 哪些地区能显示，为空表示所有地区
#sAction 跳转
#iLevel 显示优先级 ,用于排序，数字越大优先级越高
sql="CREATE TABLE IF NOT EXISTS class (
  Id int NOT NULL,
  sName varchar(64) NOT NULL,
  sBigPic varchar(1024) NOT NULL DEFAULT '',
  sSmallPic varchar(1024) NOT NULL DEFAULT '',
  sZone varchar(1024) NOT NULL DEFAULT '',
  sAction varchar(1024) NOT NULL DEFAULT '',
  iLevel int NOT NULL DEFAULT '1'
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建评论表格
#id 产品Id
#lPlatformId 平台号
#lProductId 0-表示只是对店铺的评论 其它为产品Id
#lAddTime 添加时间,unix微秒
#lUserId 评论者ID
#sNickName 评论者昵称
#sHeadImage 评论者头像
#sContent 内容
#iScore 评分（满分50） 0~50
#sPics 评论图片列表，json数组
sql="CREATE TABLE IF NOT EXISTS comment (
  id bigint NOT NULL AUTO_INCREMENT,
  lPlatformId bigint NOT NULL,
  lProductId bigint NOT NULL DEFAULT 0,
  lAddTime bigint NOT NULL,
  lUserId bigint NOT NULL,
  sNickName varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  sHeadImage varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '',
  sContent varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '',
  iScore int NOT NULL DEFAULT '50',
  sPics varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#
sql="CREATE TABLE IF NOT EXISTS keysecret (
  sAppKey varchar(128) NOT NULL,
  sAppSecret varchar(500) NOT NULL,
  lPlatformId bigint NOT NULL,
  PRIMARY KEY (sAppKey)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建商店表格
#sPrimaryKey 平台号
#lAddTime 创建时间 unix微秒
#lUpTime 更新时间 unix微秒
#iState 0-正常    2-资料未补全 8-旧的商家（无效商家） 333-删除
#lUpdateId 没用
#iSync 没用
#lUserId 店主用户号
#sAccount 店的帐号
#sPassWord 店的登录密码
#sShopName 店名
#sCompanyName 公司名
#sShopPhone 店主手机号
#sBusiness  经营产品
#sShopType 店铺类型(比如电影，美食）
#iOffLineDisCount 线下支付折扣(0~100，90表示90%)
#sLicensePhoto 营业执照(存放执照的路径)
#sIdPhoto 身份证照片(存放照片的路径)
#sShopFrontPhoto 门店照片(存放照片的路径)
#sShopDetailPhoto 店的详细图(存放照片的路径，多个时用,分隔)
#sAddress 经营地址
#sCity 所属区代
#dGpsLat 纬度
#dGpsLon 经度
#sHours 营业时间(格式：10:00-22:00）
#sPosNum POS机器号(可以多个号，用，分隔）
#lPerAgentId 个代用户ID
#iAwardingPoints 是否兑奖地点,0不是，1是
#lServiceUserId 客服用户ID
#sSevvicePhone 客服手机号
#iAvgConsume 人均消费,单位：分
#iShowNearby 是否显示附近消费，0 不显示 ，1显示
#iProrate  是否分帐，0分帐，1不分帐
#sRemark  头两个字节存入申请变更的折扣
#iVerify 0未审核 1 审核通过 2 审核不过
#iAuth 认证 0 未认证 1 认证不过 2 认证通过
#sOtherCerPhoto 其它证书照片(存放照片的路径，多个时用,分隔)
#sTradeMark 商家的商标图（存放照片的路径）
#sPushArea 没用
#sGpsZone GPS坐标所在的行政区
#iCoinPercent 特殊促销赠送比例（90表示90%）
#iPromotionDiscount 特殊促销折扣
#iCoinType 赠送购物币类型 0 -购物币 1 -专属购物币
#iScore 评价平均分（满分50） 0~50
#sInerPhoto 店内照片(数组)
#sPartnerPhone 合伙人手机号

#--------------新增字段--------------
#sType 0新入驻店铺 1正常店铺
#sWaithandle 处理状态 0未派单 1已派单
#sHandlephone 接单人电话
#lUserName 联系人名称
#Idel 黑名单 0正常 1加入黑名单
#sPCA 省市区
#--------------End------------------

#iFansTrad 0-可以交易 1-禁止交易
sql="CREATE TABLE IF NOT EXISTS shopdal (
  sPrimaryKey varchar(50) NOT NULL,
  lAddTime bigint(20) NOT NULL,
  lUpTime bigint(20) NOT NULL,
  iState int(11) DEFAULT '0',
  lUpdateId bigint(20) DEFAULT '0',
  iSync int(11) DEFAULT '0',
  lUserId bigint(20) NOT NULL,
  sAccount varchar(50) NOT NULL,
  sPassWord varchar(50) NOT NULL,
  sShopName varchar(100) NOT NULL,
  sCompanyName varchar(100) DEFAULT '',
  sShopPhone varchar(12) DEFAULT '',
  sBusiness varchar(100) DEFAULT '',
  sShopType varchar(50) NOT NULL,
  iOffLineDisCount int(11) NOT NULL,
  sLicensePhoto varchar(500) DEFAULT '',
  sIdPhoto varchar(500) DEFAULT '',
  sShopFrontPhoto varchar(500) DEFAULT '',
  sShopDetailPhoto varchar(2000) DEFAULT '',
  sAddress varchar(500) DEFAULT '',
  sCity varchar(50) NOT NULL,
  dGpsLat double(10,7) DEFAULT '0.0000000',
  dGpsLon double(10,7) DEFAULT '0.0000000',
  sHours varchar(50) DEFAULT '',
  sPosNum varchar(500) DEFAULT '',
  lPerAgentId bigint(20) NOT NULL DEFAULT '0',
  iAwardingPoints int(11) DEFAULT '0',
  lServiceUserId bigint(20) DEFAULT '0',
  sSevvicePhone varchar(50) DEFAULT '',
  iAvgConsume int(11) DEFAULT '0',
  iShowNearby int(11) DEFAULT '0',
  iProrate int(11) DEFAULT '0',
  sRemark varchar(50) DEFAULT '',
  iVerify int(11) DEFAULT '0',
  iAuth int(11) DEFAULT '0',
  sOtherCerPhoto varchar(2000) DEFAULT '',
  sTradeMark varchar(500) DEFAULT '',
  sPushArea varchar(128) DEFAULT '',
  sGpsZone varchar(50) DEFAULT '',
  iCoinPercent int not null default 0,
  iPromotionDiscount int not null default 0,
  PRIMARY KEY (sPrimaryKey),
  UNIQUE KEY sAccount (sAccount),
  KEY shop_city (sCity),
  iCoinType int(11) DEFAULT '0',
  iScore int NOT NULL DEFAULT 30,
  sInerPhoto varchar(2000) DEFAULT '',
  sPartnerPhone varchar(16) DEFAULT ''
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建配置开关表格
#lPlatformId 平台号
#lAddTime 创建时间 unix微秒
#iCashBack 返现开关 0 -关  1 -开
#iCoinBack 返购物币开关 0 -关  1 -开
#lStartTime 返现生效时间
#iRecommend 推荐开关（0 -关 1-开）
#iRestrict 特殊商家开关 0-非特殊  1-特殊
#iPark 停车  0-不免费   1-免费
#iWifi WIFI  0-没wifi   1-有wifi
#iDelivery 送货  0-没有 1-免费送货
#sCheckPwd 查看收款记录密码
sql="CREATE TABLE IF NOT EXISTS shopsetting (
  lPlatformId varchar(128) NOT NULL,
  lAddTime bigint(20) NOT NULL,
  iCashBack int(11) NOT NULL,
  iCoinBack int(11) NOT NULL,
  lStartTime bigint(20) NOT NULL,
  iRecommend int(11) DEFAULT '0',
  iRestrict int(11) DEFAULT '0',
  iPark int(11) DEFAULT '0',
  iWifi int(11) DEFAULT '0',
  iDelivery int(11) DEFAULT '0',
  sCheckPwd varchar(128) DEFAULT 'b3f821e872c29b660f737b843f0a667e',
  PRIMARY KEY (lPlatformId),
  CONSTRAINT FK_shopsetting_lPlatformId FOREIGN KEY (lPlatformId) REFERENCES shopdal (sPrimaryKey)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建展示产品表格
#id 自增id
#lPlatformId 平台ID
#lAddTime 创建时间 unix微秒 
#sPicLink 产品图片链接（OSS地址或其它）
#sName 产品名称
#dPrice 现金价格或绑定现金价格
#dCoin 购物币价格或专属购物币,由iCoinType决定
#iCoinType 0 -购物币 1 -专属购物币
#iVerify 0未审核 1 审核通过 2 审核不过
#iState  1-显示  0-隐藏 333-delete
#sContent 内容介绍
#sExpireTime 到期时间 2017-08-08
#sCanot 不可用日期 
#sUtime 使用时间 
#sLaw 使用规则 json数组
#sDetailPics 图文详情 json数组
#iSallNum 销量
#sSpecification 产品规格
sql="CREATE TABLE IF NOT EXISTS showpro (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  lPlatformId bigint(20) NOT NULL,
  lAddTime bigint(20) NOT NULL,
  sPicLink varchar(500) NOT NULL,
  sName varchar(500) NOT NULL,
  dPrice double(10,2) NOT NULL,
  dCoin double(10,2) NOT NULL,
  iCoinType int NOT NULL DEFAULT 0,
  iVerify int(11) DEFAULT '0',
  iState int(11) NOT NULL DEFAULT '1',
  sContent varchar(1024) NOT NULL DEFAULT '',
  sExpireTime varchar(24) NOT NULL DEFAULT '',
  sCanot varchar(64) NOT NULL DEFAULT '',
  sUtime varchar(64) NOT NULL DEFAULT '',
  sLaw varchar(1024) NOT NULL DEFAULT '',
  sDetailPics LongText NOT NULL DEFAULT '',
  iSallNum int not null default 0,
  sSpecification varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建主题表格
#Id 主题Id
#lAddTime 创建时间 unix微秒
#sName 主题名字
#sBigTopPic 顶部大图
#sBigBottonPic 低部大图
#sSmallTopPic 顶部小图
#sSmallBottonPic 低部小图
#sRemark 备注
#iState 状态 0 正常 
sql="CREATE TABLE IF NOT EXISTS subject (
  Id int(11) NOT NULL,
  lAddTime bigint(20) NOT NULL,
  sName varchar(64) NOT NULL,
  sBigTopPic varchar(1024) NOT NULL DEFAULT '',
  sBigBottonPic varchar(1024) NOT NULL DEFAULT '',
  sSmallTopPic varchar(1024) NOT NULL DEFAULT '',
  sSmallBottonPic varchar(1024) NOT NULL DEFAULT '',
  sRemark varchar(128) NOT NULL DEFAULT '',
  iState int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (Id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"



#创建优惠券订单
#orderNo 订单号
#userId 购买者Id
#addTime 创建时间 unix微秒
#idPlatform 券所属平台号
#idProduct 产品Id
#expireTime 到期时间 2017-08-08
#payTime 付款时间售出时间 2017-08-08 12:12:12
#endTime 结束时间 2017-08-08 12:12:12
#price 单份de现金或绑定现金  
#coin 单份de购物币
#num 份数
sql="CREATE TABLE IF NOT EXISTS coupon_order (
  orderNo varchar(128) NOT NULL,
  userId bigint NOT NULL,
  addTime bigint NOT NULL,
  idPlatform bigint NOT NULL,
  idProduct bigint NOT NULL,
  expireTime varchar(24) NOT NULL,
  payTime varchar(24) NOT NULL,
  endTime varchar(24) NOT NULL,
  price Decimal(10,2) NOT NULL,
  coin Decimal(10,2) NOT NULL,
  num INT NOT NULL,
  PRIMARY KEY (orderNo)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"



#创建优惠券验证码
#orderNo 所属订单号
#state 验证码状态 1可使用 2待评价 3退款中 4退款成功 5拒绝退款 6已消费 7已过期 8已评价
#backTime 退款时间 2017-08-08 12:12:12
#consumTime 消费时间验证时间 2017-08-08 12:12:12
#reqTime 申请时间 2017-08-08 12:12:12
#code 验证码 
#reason 退款原因
#rejReason 拒绝原因
#mark 标记 0-默认 1-已结算给商家 2-"退款或结算"失败 
sql="CREATE TABLE IF NOT EXISTS coupon_code (
  orderNo varchar(128) NOT NULL,
  state INT NOT NULL,
  backTime varchar(24) NOT NULL,
  consumTime varchar(24) NOT NULL,
  reqTime varchar(24) NOT NULL,
  code varchar(128) NOT NULL,
  reason varchar(1024) NOT NULL,
  rejReason varchar(1024) NOT NULL,
  mark INT NOT NULL default 0
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建用户权限
#power 1 -收款
sql="CREATE TABLE IF NOT EXISTS user_power (
  id bigint NOT NULL AUTO_INCREMENT,
  power int NOT NULL,
  idPlatform bigint NOT NULL,
  userId bigint NOT NULL,
  account varchar(24) NOT NULL,
  nickName varchar(128) NOT NULL,
  headImage varchar(1024) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建个代表
#id		自增ID
#addTime			添加时间
#upTime			更新时间
#state			状态 0正常
#city		工作区
#pushZone		推荐区
#pushPhone		推广人手机号
#pushId			推广人UserId
#activationState	激活状态 0:未激活 1试用激活 2:到期关闭 3:正式开通
#activationTime		试用激活时间
#dealTime		正式开通时间
#trialDays		试用可用天数
#peragentPhone			个代手机号
#userId			个代UserId
#orderNo		订单号
#totalMoney		订单总额
#payMoney		付款金额
#payCount		付款次数
#peragentName			个代姓名
#extendType		个代分成模板ID（非0的都是VIP个代）
sql="CREATE TABLE IF NOT EXISTS peragent (
  addTime  datetime not null,
  upTime  datetime not null,
  state int not null default 0 ,
  city varchar(256) NOT NULL,
  pushZone varchar(256) NOT NULL,
  pushPhone varchar(24) NOT NULL,
  pushId bigint not null,
  activationState int not null default 0,
  activationTime datetime not null,
  dealTime datetime not null,
  trialDays int not null default 0,
  peragentPhone varchar(24) NOT NULL,
  userId bigint not null,
  orderNo varchar(64) NOT NULL,
  totalMoney double(10,2) NOT NULL,
  payMoney double(10,2) NOT NULL,
  payCount int not null default 0,
  peragentName varchar(64) NOT NULL,
  extendType int not null default 0,
  PRIMARY KEY (userId)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建创建区代表
#sPrimaryKey 帐号
#lUserId   区代天天兑号
#lAddTime    添加时间，微秒
#lUpTime    更新时间，微秒
#iState    状态 0正常
#lUpdateId  不用
#iSync       不用
#sAccount    帐号
#sPhone     区代手机号
#sPassWord   登陆密码
#sName       名称
#sUnit      单位
#sID        级别 市代理或省代理
#sCity       代理区 （当sID是市代理时，只有一个区；当sID是省代理时，是一批区，格式：深圳盐田区-深圳龙岗区-深圳宝安区-深圳南山区-深圳罗湖区-深圳福田区）
#sRemark   备注  
sql="CREATE TABLE IF NOT EXISTS zoneagentdal (
  sPrimaryKey varchar(50) NOT NULL,
  lUserId bigint NOT NULL,
  lAddTime  bigint NOT NULL,
  lUpTime bigint NOT NULL,
  iState int NOT NULL default 0,
  lUpdateId bigint not null default 0,
  iSync int not null default 0,
  sAccount varchar(50) not null,
  sPhone varchar(24) not null,
  sPassWord varchar(50) not null,
  sName varchar(50) ,
  sUnit varchar(50) ,
  sID varchar(50) not null,
  sCity varchar(2000) not null,
  sRemark varchar(200),
  PRIMARY KEY (sPrimaryKey),
  UNIQUE KEY(sAccount)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"



#创建错误详情
#addTime 添加时间
#errorType 错误类型
#errorDetails 错误详情
#state	int 状态 默认0-未处理
sql="CREATE TABLE IF NOT EXISTS errorexception (
  id bigint NOT NULL AUTO_INCREMENT,
  addTime varchar(24) NOT NULL,
  errorType  varchar(24) NOT NULL,
  errorDetails varchar(1028) NOT NULL,
  state int NOT NULL default 0,
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建登陆信息
#addTime 添加时间
#account 帐号
#action 动作 登陆或退出
sql="CREATE TABLE IF NOT EXISTS login_info (
  id bigint NOT NULL AUTO_INCREMENT,
  addTime varchar(24) NOT NULL,
  account  varchar(48) NOT NULL,
  action varchar(24) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"



#创建健值对
#k
#value 
sql="CREATE TABLE IF NOT EXISTS configinfo (
  k varchar(24) NOT NULL,
  value  varchar(1024) NOT NULL,
  PRIMARY KEY (k)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"




#创建线下订单
#orderNo 订单号
#money 付款总金额
#payType 支付方式 eg:现金 
#payState    支付状态 0-未付款，1-已付款
#platformId  平台号 
#shopName 平台名称
#shopPhone 平台主手机号
#zone 平台所属区
#payUserId 消费者天天兑号
#payNickName 消费者昵称
#payPhone 消费者手机号
#payHeadImage 消费者头像
#addTime 添加时间
#upTime 更新时间
#remark 备注
#notDividedMoney 不分账金额
#offLineDisCount 折扣 1~100
#recType 收款方式  0商家收款，1个人收款
#coin 购物币数
#coinType 购物币类型 0普通购物币 1专属购物币
#isFans 消费者是否为粉丝 0- 1-
#unPushDivided 未结算用户推广分成
#unPlatformDivided 未结算平台推广分成
sql="CREATE TABLE IF NOT EXISTS offline_order (
  orderNo varchar(64) NOT NULL,
  money  Decimal(10,2) NOT NULL,
  payType varchar(64) NOT NULL,
  payState int not null,
  platformId bigint not null,
  shopName varchar(64) not null,
  shopPhone varchar(12) not null,
  zone varchar(64) not null,
  payUserId bigint not null,
  payNickName varchar(64) not null,
  payPhone varchar(12) not null,
  payHeadImage varchar(256) not null,
  addTime varchar(64) not null,
  upTime varchar(64) not null,
  remark varchar(1024) not null,
  notDividedMoney Decimal(10,2) NOT NULL,
  offLineDisCount int not null,
  recType int not null,
  coin Decimal(10,2) NOT NULL,
  coinType int not null,
  isFans int not null,
  unPushDivided Decimal(10,2) NOT NULL,
  unPlatformDivided Decimal(10,2) NOT NULL,
  PRIMARY KEY (orderNo)
) ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建行业分类信息表
sql="create table IF NOT EXISTS industry 
(
  id bigint NOT NULL AUTO_INCREMENT comment '唯一标记',
  name VARCHAR(128) NOT NULL comment '行业名称',
  url VARCHAR(256) NOT NULL comment '主题图片',
  num int NOT NULL default 0 comment '名单个数',
  count int NOT NULL default 0 comment '总票数',
  agentId bigint NOT NULL default 0  comment  '指定的个代Id',
  platformId bigint NOT NULL default 0 comment '指定的商家平台Id',
  state int NOT NULL default 0 comment '状态0-正常 1-关闭 333-册除',
  lmt int NOT NULL default 0 comment '投票限制 0-跨项目限制 1-帐号限制',
  content text NOT NULL default '' comment '说明',
  level int NOT NULL default 0 comment '显示次序，越大越前',
  PRIMARY KEY(id),
  UNIQUE KEY(name)
) comment='行业分类信息表' ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建投票名单信息表
sql="create table IF NOT EXISTS association 
(
  id bigint NOT NULL AUTO_INCREMENT comment '唯一标记',
  count int NOT NULL default 0  comment '票数',
  fackTick int NOT NULL default 0  comment ' 假的票数,这个字段是由后台修改，给用户看的',
  name VARCHAR(128) NOT NULL comment '对像名称',
  industry int NOT NULL default 1 comment '行业id',
  level int NOT NULL default 0 comment '显示次序，越大越前',
  state int NOT NULL default 0 comment '状态0-正常 1-关闭 333-册除',
  content text NOT NULL default '' comment '说明',
  PRIMARY KEY(id),
  UNIQUE KEY(name)
) comment='投票名单信息表' ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"


#创建用户投票记录
sql="create table IF NOT EXISTS vote 
(
  id bigint NOT NULL AUTO_INCREMENT comment '唯一标记',
  addTime datetime NOT NULL comment '投票时间',
  userId bigint NOT NULL comment '谁投了票',
  phone VARCHAR(12) NOT NULL default '' comment '投票手机号码',
  ip VARCHAR(48) NOT NULL default '' comment 'IP地址',
  associationId bigint NOT NULL comment '对像id',
  UNIQUE KEY (userId),
  PRIMARY KEY(id)
) comment='用户投票记录' ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建投票后台管理帐号
sql="create table IF NOT EXISTS account_vote 
(
  id bigint NOT NULL AUTO_INCREMENT comment '唯一标记',
  account VARCHAR(48) NOT NULL default '' comment '帐号',
  pwd VARCHAR(48) NOT NULL default '' comment '密码',
  UNIQUE KEY (account),
  PRIMARY KEY(id)
) comment='投票后台管理帐号' ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"

#创建分享数据
sql="create table IF NOT EXISTS sharedata 
(
  id bigint NOT NULL AUTO_INCREMENT comment '唯一标记',
  url VARCHAR(256) NOT NULL comment '网页地址',
  shareIcon VARCHAR(256) NOT NULL comment '分享图标路径',
  shareTitle VARCHAR(256) NOT NULL comment '分享标题',
  shareContent VARCHAR(1024) NOT NULL comment '分享内容',
  PRIMARY KEY(id)
) comment='分享数据' ENGINE=INNODB DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD}  -D ${DBNAME} -e "${sql}"
