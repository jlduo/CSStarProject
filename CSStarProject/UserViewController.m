//
//  UserViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UserViewController.h"
#import "UserTableViewCell.h"
#import "HomeViewController.h"
#import "UserInfoViewController.h"

@interface UserViewController (){
    UIImage *cellImg;
    NSString *imgName;
    NSString *cellTitle;
    
    UITableView *stableView;
    UIImageView *imgBtn;
    UILabel *userLabel;
    
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self showLoading:@"数据初始化中..."];
    _userProjectNums = [[NSMutableDictionary alloc]init];
    
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49-44);
    stableView = [[UITableView alloc] initWithFrame:tframe];
    stableView.delegate = self;
    stableView.dataSource = self;
    //[StringUitl loadUserInfo:[StringUitl getSessionVal:LOGIN_USER_NAME]];
    
    //处理头部信息
    [self setHeaderView];
    [self setFooterView];
    [self.view addSubview:stableView];
    [stableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]]];
    stableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //处理数据回填
    //[self setImgBtnImage];
    //[self setUserTitle];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{                                                                                                                                                                                                                                                                                           self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarController.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-44);
    [stableView setFrame:temFrame];
    
    [self setImgBtnImage];
    [self setUserTitle];
    
    
}

-(void)viewWillLayoutSubviews{
    [self getMyProjectsNums];
}

-(void)dealloc{
    cellImg = nil;
    imgBtn = nil;
    userLabel = nil;
    cellTitle = nil;
    stableView = nil;
    _userProjectNums = nil;
    _userDataList = nil;
}

-(void)setImgBtnImage{
    
    NSString *userLogo = [StringUitl getSessionVal:USER_LOGO];
    NSMutableString *newString = [[NSMutableString alloc]initWithString:userLogo];
    NSRange srange = [userLogo rangeOfString:@"small_"];
    [newString replaceCharactersInRange:srange withString:@""];
    [imgBtn setImageURLStr:newString placeholder:NO_IMG];
    
}

-(void)getMyProjectsNums{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_USERCENTER_NUMS_URL,[StringUitl getSessionVal:LOGIN_USER_ID]];
    [self requestDataByUrl:url];
}


-(void)requestDataByUrl:(NSString *)url{
    //处理路劲
    NSURL *reqUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:reqUrl];
    //设置代理
    [request setDelegate:self];
    [request startAsynchronous];
    
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *respData = [request responseData];
    NSString *pro_nums = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];
    NSLog(@"pro_nums->%@",pro_nums);
    if([StringUitl isNotEmpty:pro_nums]){
        pro_nums = [pro_nums substringWithRange:NSMakeRange(1,[pro_nums length]-2)];
        NSArray *num = [pro_nums componentsSeparatedByString:@","];
        if(num!=nil&&num.count>0){
            for (int i=0; i<num.count; i++) {
                NSArray *nums = [num[i] componentsSeparatedByString:@":"];
                [_userProjectNums setObject:nums[1] forKey:nums[0]];
            }
        }
    }

    [stableView reloadData];
    [self hideHud];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"error->%@",error);
    [self hideHud];
    [self showCAlert:@"加载失败,请检查网络连接!" widthType:ERROR_LOGO];
    
}

-(void)passValue:(NSString *)val{
    
}

-(void)passDicValue:(NSDictionary *)vals{
    
}


-(void)setUserTitle{
    userLabel.font = main_font(16);
    [userLabel setText:[StringUitl getSessionVal:USER_NICK_NAME]];
}

-(void)setHeaderView{
    
     UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [headView setBackgroundColor:[UIColor grayColor]];
    
    imgBtn = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 10, 120, 120)];
    imgBtn.layer.masksToBounds = YES;
    imgBtn.layer.cornerRadius = 60.0f;

    [imgBtn setMultipleTouchEnabled:YES];
    [imgBtn setUserInteractionEnabled:YES];
    [imgBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgBtnClick)]];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myzonebg.png"]];
    
    [imgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [imgView setUserInteractionEnabled:YES];//处理图片点击生效
    
    userLabel =[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 100, 120, 100)];
    [userLabel setTextColor:[UIColor blackColor]];
    [userLabel setTextAlignment:NSTextAlignmentCenter];
    [userLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    [imgView addSubview:userLabel];
    [imgView addSubview:imgBtn];
    [headView addSubview:imgView];
    
    stableView.tableHeaderView = headView;
    
}

-(void)setFooterView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [footView setBackgroundColor:[StringUitl colorWithHexString:CONTENT_BACK_COLOR]];
    
    UIButton *loginOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 15, SCREEN_WIDTH-10, 45)];
    loginOutBtn.layer.cornerRadius = 5.0;
    loginOutBtn.titleLabel.font = main_font(20);
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [loginOutBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateHighlighted)];
    [loginOutBtn setBackgroundColor:[UIColor redColor]];
    [loginOutBtn addTarget:self action:@selector(userLoginOut) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:loginOutBtn];
    stableView.tableFooterView = footView;
    
}



-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, SCREEN_WIDTH, NAV_TITLE_HEIGHT)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"个人中心"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

//跳转到个人信息页面
-(void)imgBtnClick{
    UserInfoViewController *userInfoView = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:userInfoView animated:YES];
}


-(void)goPreviou{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadView{
    [super loadView];
    //self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:[self setNavBarWithTitle:@"个人中心" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}


#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
       return 5;
    }else{
        return 1;
    }
}

#pragma mark 计算行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 51;
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *nibIdentifier = @"UserViewCell";
    UINib *nibCell = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [stableView registerNib:nibCell forCellReuseIdentifier:nibIdentifier];
    
    if(indexPath.section==0){
        
        UserTableViewCell *userCell = [stableView dequeueReusableCellWithIdentifier:@"UserViewCell"];
        userCell.backgroundColor = [UIColor clearColor];
        NSString *valKey;
        switch (indexPath.row) {
            case 0:
                valKey = @"talk";
                cellTitle = @"我的评论";
                imgName =@"myzone-discuss.png";
                break;
            case 1:
                valKey = @"message";
                cellTitle = @"我的消息";
                imgName =@"myzone-message.png";
                break;
            case 2:
                valKey = @"project";
                cellTitle = @"我的众筹";
                imgName =@"myzone-zhongchou.png";
                break;
            case 3:
                valKey = @"order";
                cellTitle = @"我的订单";
                imgName =@"myzone-order.png";
                break;
            case 4:
                valKey = @"delivery";
                cellTitle = @"收货地址";
                imgName =@"myzone-location.png";
                break;
                
            default:
                break;
        }
    
        cellImg = [UIImage imageNamed:imgName];
        [userCell.cellPic setBackgroundImage:cellImg forState:UIControlStateNormal];
        [userCell.dataTitle setText:cellTitle];
        userCell.dataTitle.font = main_font(18);
        userCell.dataTitle.alpha = 0.8f;
        userCell.dataNum.font = main_font(9);
        [userCell.dataNum setText:[_userProjectNums valueForKey:valKey]];
        userCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return userCell;

        
    }else{
        
        UserTableViewCell *newUserCell = [stableView dequeueReusableCellWithIdentifier:@"UserViewCell"];
        newUserCell.backgroundColor = [UIColor clearColor];
        newUserCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [newUserCell.cellPic setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [newUserCell.tagBgView setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [newUserCell.arrowPic setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [newUserCell.dataTitle setTextColor:[UIColor darkGrayColor]];
        [newUserCell.dataTitle setText:@"清空缓存数据"];
        [newUserCell.dataTitle setTextAlignment:NSTextAlignmentCenter];
        
        NSString *clearStr = [self getCacheFileSize];
        if([StringUitl isNotEmpty:clearStr]){
          [newUserCell.dataTitle setText:[NSString stringWithFormat:@"清空缓存数据(%@)",clearStr]];
        }
        
        return newUserCell;
    }
}

-(void)userLoginOut{
    //清空用户信息
    NSLog(@"清空用户信息成功.....");
    [StringUitl clearUserInfo];
    //跳转到首页
    //[self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {

        switch (indexPath.row) {
            case 0:
                [self goComment];
                break;
            case 1:
                
                break;
            case 2:
                [self goProject];
                break;
            case 3:
                [self goOrder];
                break;
            case 4:
                [self goRecAddress];
                break;
            default:
                break;
        }
        
    }else{
        [self clearCacheFile];
    }
    
}

-(NSString *)getCacheFileSize{
    NSString *clearCacheName;
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    if(tmpSize!=0.0f){
        clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        NSLog(@"clearCacheName=%@",clearCacheName);
    }
    return clearCacheName;
}

-(void)clearCacheFile{
    NSString *clearCacheName;
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    NSUInteger tmpCount = [[SDImageCache sharedImageCache] getDiskCount];
    if(tmpSize==0.0f){
        [self showHint:@"暂无缓存数据!"];
    }else{
        clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清除%d文件共[%.2fM]",tmpCount,tmpSize] : [NSString stringWithFormat:@"清除%d文件共[%.2fK]",tmpCount,tmpSize * 1024];
        NSLog(@" clearCacheName=%@",clearCacheName);
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [stableView reloadData];
        [self showHint:clearCacheName];
    }
    
}

-(void)goMessage{
    
}

-(void)goOrder{
    PeopleProListViewController *projectController = [[PeopleProListViewController alloc] init];
    passValelegate =projectController;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"2" forKey:@"titleName"];
    [params setObject:@"order" forKey:@"titleValue"];
    [passValelegate passDicValue:params];
    [passValelegate passValue:[StringUitl getSessionVal:LOGIN_USER_ID]];
    [self.navigationController pushViewController:projectController animated:YES];
}

-(void)goProject{
    MyProjectListViewController *projectController = [[MyProjectListViewController alloc] init];
    [self.navigationController pushViewController:projectController animated:YES];
}

-(void)goComment{
    myCommentViewController *comController = [[myCommentViewController alloc] init];
    [self.navigationController pushViewController:comController animated:YES];
}

-(void)goRecAddress{
    ReciverAddressViewController *addressController = [[ReciverAddressViewController alloc] init];
    passValelegate = addressController;
    [passValelegate passValue:@"userAdd"];
    [self.navigationController pushViewController:addressController animated:YES];
}


@end
