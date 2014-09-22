//
//  common.h
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#ifndef CSStarProject_common_h
#define CSStarProject_common_h

#define PAGESIZE @"2"//列表分页数据
#define STATU_BAR_HEIGHT 20 //状态栏高度
#define NAV_BAR_ICON_WIDTH 32//导航栏图标宽度
#define NAV_BAR_ICON_HEIGHT 32//导航栏图标高度
#define TABBAR_HEIGHT 49//底部导航的高度
#define SCREEN_WIDTH 320//屏幕宽度
#define BTN_WIDTH SCREEN_WIDTH/5//按钮宽度
#define BTN_HEIGHT TABBAR_HEIGHT//按钮高度
#define SLIDER_HEIGHT 4 //滑块的高度
#define NAV_TITLE_WIDTH 100//导航标题宽度
#define NAV_TITLE_HEIGHT 44//导航标题高度
#define NAV_TITLE_INDEX SCREEN_WIDTH/2//导航标题位置

#define MAIN_FRAME [[UIScreen mainScreen] applicationFrame]//屏幕尺寸
#define MAIN_FRAME_X MAIN_FRAME.origin.x
#define MAIN_FRAME_Y MAIN_FRAME.origin.y
#define MAIN_FRAME_W MAIN_FRAME.size.width
#define MAIN_FRAME_H MAIN_FRAME.size.height

#define Font_Size(x) [UIFont systemFontOfSize:x]//字体函数
#define Main_Font_Size Font_Size(15)//主字体

#define CONTENT_BACKGROUND @"place@2x.png"//正文背景
#define TABR_BG_ICON @"titlebar-gray@2x.png"//底部导航图
#define NAVBAR_BG_ICON @"titlebar-gray@2x.png"//导航背景
#define NAVBAR_LEFT_ICON @"nav_back.png"//返回按钮图标
#define NAVBAR_RIGHT_ICON @"iconi.png"//个人中心图标
#define REFRESH_TITLE @"刷新数据"
#define REFRESH_LOADING @"玩命加载中..."
#define NOIMG_ICON @"imgloading@2X.png"//无图片
#define DELAY_TIME 2
#define FORWARD_TYPE @"TAB"//登录跳转方式 tab 为点击tabbar

#define REMOTE_URL @"http://192.168.1.210:8888"
#define REMOTE_ADMIN_URL @"http://192.168.1.210:888"
#define LOGIN_URL @"/AndroidApi/LoginService/Login"//登录地址
#define REGISTER_URL @"/AndroidApi/RegisterService/Register"//注册地址
#define CHECK_CODE_URL @"/AndroidApi/SmsService/SendSMS"//验证码请求地址
#define USER_CENTER_URL @"/AndroidApi/UsersService/GetUsers"//用户中心接口
#define EDIT_USER_URL @"/AndroidApi/UsersService/EditUsers"//编辑用户信息
#define UPLOAD_IMG_URL @"/tools/ApiUpload.ashx?action=UploadImage"//上传图片接口
#define GET_CITY_URL @"/AndroidApi/UsersService/GetCity"//获取城市
#define GET_PASSWORD_URL @"/AndroidApi/UsersService/FindPassWord"//找回密码
#define EDIT_PASSWORD_URL @"/AndroidApi/UsersService/EditPassWord"//修改密码
#define COMMENT_LIST_URL @"/Comment/GetCommentTotal"//获取评论信息
#define ADD_COMMENT_URL @"/Comment/AddComment"//提交评论信息

#define LOGIN_USER_ID @"login_user_id"
#define LOGIN_USER_NAME @"login_user_name"
#define LOGIN_USER_PSWD @"login_user_pswd"
#define USER_IS_LOGINED @"user_is_logined"
#define USER_ID @"userid"
#define USER_NAME @"username"
#define USER_PASS @"password"
#define USER_NICK_NAME @"nickname"
#define USER_ADDRESS @"address"
#define PROVINCE_ID @"provinceid"
#define CITY_ID @"cityid"
#define USER_SEX @"sex"
#define USER_LOGO @"logo"

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

//处理日期格式化
#define SIMPLE_DATE_FORMATER @"yyyy-MM-dd"
#define SIMPLE_DATETIME_FORMATER @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMATER_WITHOUT_SEC @"yyyy-MM-dd HH:mm"
#define DATE_FORMATER_WITHOUT_DATE @"HH:mm:ss"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSION_5_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) ? (YES):(NO))


#define IPHONE4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : 0)//判断是否为iphone4/4s

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)//判断是否为iphone5/5s

#endif

