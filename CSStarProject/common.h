//
//  common.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#ifndef CSStarProject_common_h
#define CSStarProject_common_h

#define CONNECT_MODE 2 //访问模式 1 测试版 2 正式版
#define TIPS_TYPE 2 //提示信息样式 1 白色底图标 2 细线图标
#define PAGESIZE @"5"//列表分页数据
#define CF_PAGESIZE @"5"//列表分页数据
#define STATU_BAR_HEIGHT 20 //状态栏高度
#define NAV_BAR_ICON_WIDTH 32//导航栏图标宽度
#define NAV_BAR_ICON_HEIGHT 32//导航栏图标高度
#define TABBAR_HEIGHT 49//底部导航的高度
#define SCREEN_WIDTH MAIN_FRAME_W//屏幕宽度
#define BTN_WIDTH SCREEN_WIDTH/5//按钮宽度
#define BTN_HEIGHT TABBAR_HEIGHT//按钮高度
#define SLIDER_HEIGHT 4 //滑块的高度
#define NAV_TITLE_WIDTH 100//导航标题宽度        
#define NAV_TITLE_HEIGHT 44//导航标题高度
#define NAV_TITLE_INDEX SCREEN_WIDTH/2//导航标题位置

#define VIEW_FRAME_H self.view.frame.size.height
#define SVIEW_FRAME_H self.view.frame.size.height-64-49
#define MAIN_FRAME [[UIScreen mainScreen] applicationFrame]//屏幕尺寸
#define MAIN_FRAME_X MAIN_FRAME.origin.x
#define MAIN_FRAME_Y MAIN_FRAME.origin.y
#define MAIN_FRAME_W MAIN_FRAME.size.width
#define MAIN_FRAME_H MAIN_FRAME.size.height

//#define main_font(x) DIY_FONT_SIZE(@"Microsoft YaHei",x);
#define main_font(x) Font_Size(x);
#define DIY_FONT_SIZE(n,x) [UIFont fontWithName:n size:x]//自定义字体函数
#define Font_Size(x) [UIFont systemFontOfSize:x]//字体函数
#define Main_Font_Size Font_Size(14)//主字体

//#define BANNER_FONT DIY_FONT_SIZE(@"ZHSRXT-GBK",28)//标题字体
#define BANNER_FONT Font_Size(24)//标题字体
#define TITLE_FONT main_font(18)//标题字体
#define DESC_FONT main_font(14)//描述字体

#define CONTENT_BACK_COLOR @"#F5F5F5"//正文背景
#define CONTENT_BACKGROUND @"background.jpeg"//正文背景
#define TABR_BG_ICON @"tabbarbg@2x.png"//底部导航图
#define TABR_SBG_ICON @"tabbarbgon@2x.png"//底部导航选中图
#define NAVBAR_BG_ICON @"titlebar-gray@2x"//导航背景
#define NAVBAR_LEFT_ICON @"nav_back@2x.png"//返回按钮图标
#define NAVBAR_RIGHT_ICON @"iconi.png"//个人中心图标
#define REFRESH_TITLE @"刷新数据"
#define ERROR_INNER @"请求失败,内部错误！"
#define BLANK_NICK_NAME @"网友"//昵称为空
#define REFRESH_LOADING @"玩命加载中..."
#define SHARE_ICON @"btnshare@2x.png"//分享图片
#define NOIMG_ICON @"imgloading@2X.png"//无图片
#define NOIMG_ICON_TX @"avatarbig.png"//无头像图片
#define NOIMG_ICON_PL @"avatar.png"//无头像图片
#define CG_IMG(x) [UIImage imageNamed:x]//图片
#define NO_IMG [UIImage imageNamed:NOIMG_ICON]//无图片
#define CGIMG() [[UIImageView alloc]init]//创建图片
#define CGIMGF(x)[[UIImageView alloc]initWithFrame:x]//创建图片带位置
#define CGIMAG(x,y,w,h) [[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)]//创建图片带位置
#define IMG_WITH_NAME(x) [[UIImageView alloc]initWithImage:[UIImage imageNamed:x]];
#define DELAY_TIME 2

#define FORWARD_TYPE @"TAB"//登录跳转方式 tab 为点击tabbar

#if CONNECT_MODE==1

#define REMOTE_URL @"http://192.168.1.210:8888"
#define REMOTE_ADMIN_URL @"http://192.168.1.210:888"

#else

#define REMOTE_URL @"http://i.0731zhongchou.com"
#define REMOTE_ADMIN_URL @"http://www.0731zhongchou.com"

#endif

#define SHARE_AT [NSString stringWithFormat:@"%@%@",REMOTE_URL,@"/text.aspx?id="]
#define SHARE_SP [NSString stringWithFormat:@"%@%@",REMOTE_URL,@"/sp.aspx?id="]
#define SHARE_XC [NSString stringWithFormat:@"%@%@",REMOTE_URL,@"/xc.aspx?id="]

#define USER_AGREEMENT_URL @"/cms/GetArticleList/agreement"
#define LOGIN_URL @"/AndroidApi/LoginService/Login"//登录地址
#define REGISTER_URL @"/AndroidApi/RegisterService/Register"//注册地址
#define CHECK_CODE_URL @"/AndroidApi/SmsService/SendSMS"//验证码请求地址
#define USER_CENTER_URL @"/AndroidApi/UsersService/GetUsers"//用户中心接口
#define EDIT_USER_URL @"/AndroidApi/UsersService/EditUsers"//编辑用户信息
#define UPLOAD_IMG_URL @"/tools/ApiUpload.ashx?action=UploadImage"//上传图片接口
#define GET_CITY_URL @"/AndroidApi/UsersService/GetCity"//获取城市
#define GET_PASSWORD_URL @"/AndroidApi/UsersService/FindPassWord"//找回密码
#define EDIT_PASSWORD_URL @"/AndroidApi/UsersService/EditPassWord"//修改密码
#define COMMENT_COUNT_URL @"/Comment/GetCommentTotal"//获取评论信息
#define ADD_COMMENT_URL @"/Comment/AddCommentNew"//提交评论信息
#define GET_COMMENT_URL @"/Comment/GetArticleComments"//获取文章评论

//首页数据
#define SLIDE_TOP @"/cms/GetSlides"
#define CITY_TOP @"/cms/GetArticles/city"
#define GIRLS_TOP @"/cms/GetArticles/girl"

#define LOAD_NEW_DATA @"/cms/GetArticlesById"

#define PHOTO_BANNER_URL @"/cms/GetArticles/girl/1/is_top=1"
#define GIRLS_CLIST @"/cms/GetChildList/"
#define GIRLS_SCLIST @"/cms/GetArticleListByCategoryid/"
#define GIRLS_LIST @"/cms/GetArticleList/girl"
#define GET_PHOTO_LIST @"/cms/GetAlbums"

#define GET_ARTICLE_URL @"/cms/GetArticle"
#define GIRL_VIDEO_URL @"/cms/GetArticles/video"

//活动众筹接口
#define HOME_PEOPLE_URL @"/cf/getTopProject"
#define PEOPLE_LIST_URL @"/cf/getTjProjects"
#define SILDER_PEOPLE_URL @"/cf/getTopProjects"
#define GET_PPLIST_URL @"/cf/getprojectlist/"
#define GET_MORE_LIST_URL @"/cf/getMoreprojectlist/"
#define GET_PROJECT_URL @"/cf/getProjectById"
#define GET_RETURNS_URL @"/cf/getReturnsById"
#define GET_RETURN_URL @"/cf/getProjectReturnById"
#define GET_MYPROJECT_NUMS_URL @"/cf/getMyProjectsNums"
#define GET_USERCENTER_NUMS_URL @"/cf/getUsercenterNums"
#define GET_PROJECT_CATS @"/cf/getProjectCats"


#define GET_LOVE_PROJECTS_URL @"/cf/getUserLoveProjects"//喜欢的众筹
#define GET_ORDER_PROJECTS_URL @"/cf/getUserProjects"//发起的众筹
#define GET_OTORDER_PROJECTS_URL @"/cf/getOtherUserProjects"//发起的众筹(其他人)
#define GET_SUPPORT_PROJECTS_URL @"/cf/getUserOrders"//支持的众筹
#define GET_PROJECT_TALKS_URL @"/cf/getProjectTalks"//项目评论列表
#define GET_ADDRESS_LIST_URL @"/cf/getDeliverys"//收货人地址
#define GET_ADDRESS_BID_URL @"/cf/getdeliveryById"//收货地址详情
#define GET_ORDER_BID_URL @"/cf/getOrderDetail"//获取订单
#define GET_DEFAULT_ADDRESS_URL @"/cf/getDefaultDelivery"//默认收货地址详情addDelivery

#define ADD_ADDRESS_URL @"/AndroidApi/CFService/addDelivery"//增加收货地址
#define EDIT_ADDRESS_URL @"/AndroidApi/CFService/updateDelivery"//修改收货地址
#define DEL_ADDRESS_URL @"/AndroidApi/CFService/deleteDelivery"//删除收货地址
#define ADD_TALK_URL @"/AndroidApi/CFService/addTalk"//提交评论
#define ADD_REVIEW_URL @"/AndroidApi/CFService/addReview"//提交回复
#define SUB_ORDER_URL @"/AndroidApi/CFService/SubmitOrder"//提交订单
#define DEL_ORDER_URL @"/AndroidApi/CFService/cancelOrder"//取消订单

#define ADD_ENJOY_PROJECT_URL @"/AndroidApi/CFService/addEnjoyProject"

#define ADDRESS_INFO @"address_info"
#define ADDRESS_CITY_ID @"address_city_id"
#define ADDRESS_PROVINCE_ID @"address_province_id"

#define LOGIN_USER_ID @"login_user_id"
#define LOGIN_USER_NAME @"login_user_name"
#define LOGIN_USER_PSWD @"login_user_pswd"
#define USER_IS_LOGINED @"user_is_logined"
#define USER_ID @"userid"
#define USER_NAME @"username"
#define USER_PASS @"password"
#define USER_NICK_NAME @"nickname"
#define USER_ADDRESS @"address"
#define USER_PHONE @"phone"
#define USER_ZIPCODE @"zipcode"
#define PROVINCE_ID @"provinceid"
#define CITY_ID @"cityid"
#define USER_SEX @"sex"
#define USER_LOGO @"logo"

#define SUCCESS_LOGO @"tips_success.png"
#define ERROR_LOGO @"tips_error.png"
#define WARNN_LOGO @"tips_warnn.png"
#define HAND_LOGO @"hand@2x.png"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

//处理日期格式化
#define SIMPLE_DATE_FORMATER @"yyyy-MM-dd"
#define SIMPLE_DATETIME_FORMATER @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMATER_WITHOUT_SEC @"yyyy-MM-dd HH:mm"
#define DATE_FORMATER_WITHOUT_DATE @"HH:mm:ss"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSION_5_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) ? (YES):(NO))
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define IPHONE4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : 0)//判断是否为iphone4/4s

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)//判断是否为iphone5/5s

#endif

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)singleton##className;
//单例宏模板，定义
#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)singleton##className { \
static className* singleton##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
singleton##className = [[self alloc] init]; \
}); \
return singleton##className; \
}


#import "HttpClient.h"
