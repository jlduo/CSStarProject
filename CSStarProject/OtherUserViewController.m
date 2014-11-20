//
//  OtherUserViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "OtherUserViewController.h"

@interface OtherUserViewController (){
    
    UIImage *cellImg;
    NSString *imgName;
    NSString *dataNum;
    NSString *cellTitle;
    NSString *dataId;
    
    UIImageView *imgBtn;
    UILabel *userLabel;
    NSMutableDictionary *params;
}

@end

@implementation OtherUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoading:@"加载中..."];
    _userProjectNums = [[NSMutableDictionary alloc]init];
    
    [self initLoadData];
    [self initLoadUserData];
    [self getMyProjectsNums];
    [self setHeaderView];
    
}


-(void)initLoadData{
    
    _otherUserCenterTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _otherUserCenterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

//传递过来的参数
-(void)passDicValue:(NSDictionary *)vals{
    params = [NSMutableDictionary dictionaryWithDictionary:vals];
    dataId = [params valueForKey:@"userName"];
    NSLog(@"vals====%@",vals);
}

-(void)passValue:(NSString *)val{
    
}

-(void)initLoadUserData{
    
    [HttpClient loadUserInfo:dataId
                      isjson:FALSE
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
                    {
                        _userData = [StringUitl getDicFromData:responseObject];
                        [self setImgBtnImage];
                        [self setUserTitle];
                        [_otherUserCenterTable reloadData];
                        
                    }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                    {
                        
                        [self requestFailed:error];
                        
                    }
     ];
    
}


-(void)getMyProjectsNums{
    
    NSString *userid = [StringUitl getSessionVal:LOGIN_USER_ID];
    NSLog(@"userid=%@",userid);
    [HttpClient getOTUserCenterData:userid
                           isjson:FALSE
                          success:^(AFHTTPRequestOperation *operation, id responseObject)
                         {
                             
                             NSString *pro_nums = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                             if([StringUitl isNotEmpty:pro_nums]){
                                 pro_nums = [pro_nums substringWithRange:NSMakeRange(1,[pro_nums length]-2)];
                                 NSArray *num = [pro_nums componentsSeparatedByString:@","];
                                 if(num!=nil && num.count>0){
                                     NSArray *nums;
                                     for (int i=0; i<num.count; i++) {
                                         nums = [num[i] componentsSeparatedByString:@":"];
                                         [_userProjectNums setObject:nums[1] forKey:nums[0]];
                                     }
                                 }
                             }
                             
                             [self hideHud];
                             [_otherUserCenterTable reloadData];
                             
                         }
     
                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
                         {
                             
                             [self requestFailed:error];
                             
                         }
     ];
}

- (void)requestFailed:(NSError *)error
{
    NSLog(@"error=%@",error);
    [self hideHud];
    [self showNo:@"请求失败,网络错误!"];
}

-(void)setImgBtnImage{
    
    NSString *userLogo = [_userData valueForKey:@"logo"];
    [imgBtn md_setImageWithURL:userLogo placeholderImage:NO_IMG options:SDWebImageRefreshCached];
    
}


-(void)setUserTitle{
    userLabel.font = main_font(16);
    NSString *nickName = [_userData valueForKey:@"nickname"];
    if([StringUitl isEmpty:nickName])nickName = BLANK_NICK_NAME;
    [userLabel setText:nickName];
}


-(void)setHeaderView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [headView setBackgroundColor:[UIColor grayColor]];
    
    imgBtn = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 10, 120, 120)];
    imgBtn.layer.masksToBounds = YES;
    imgBtn.layer.cornerRadius = 60.0f;
    [StringUitl setViewBorder:imgBtn withColor:@"#FFFFFF" Width:4.0f];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myzonebg.png"]];
    [imgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [imgView setUserInteractionEnabled:YES];//处理图片点击生效
    
    userLabel =[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2, 100, 240, 100)];
    [userLabel setTextColor:[UIColor blackColor]];
    [userLabel setTextAlignment:NSTextAlignmentCenter];
    [userLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    [imgView addSubview:userLabel];
    [imgView addSubview:imgBtn];
    [headView addSubview:imgView];
    
    _otherUserCenterTable.tableHeaderView = headView;
    
}


-(void)goPreviou{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"Ta的主页" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    return 3;
}

#pragma mark 计算行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==5){
        return 90;
    }else{
        return 51;
    }
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self goUserProList:@"1"];
            break;
        case 1:
            [self goUserProList:@"2"];
            break;
        case 2:
            [self goUserProList:@"3"];
            break;
        default:
            break;
    }
    
}


-(void)goUserProList:(NSString *)titleName{
    
    NSLog(@"name=%@",titleName);
    PeopleProListViewController *peopleListController =  (PeopleProListViewController *)[self getVCFromSB:@"peopleProList"];
    _passValelegate = peopleListController;
    [params setObject:titleName forKey:@"titleName"];
    [_passValelegate passDicValue:params];
    [self.navigationController pushViewController:peopleListController animated:YES];
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *nibIdentifier = @"UserViewCell";
    UINib *nibCell = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [_otherUserCenterTable registerNib:nibCell forCellReuseIdentifier:nibIdentifier];
    
    UserTableViewCell *userCell = [_otherUserCenterTable dequeueReusableCellWithIdentifier:@"UserViewCell"];
    userCell.backgroundColor = [UIColor clearColor];
    switch (indexPath.row) {
        case 0:
            cellTitle = @"Ta喜欢的众筹";
            imgName =@"herzone_like.png";
            dataNum = [_userProjectNums valueForKey:@"love"];
            break;
        case 1:
            cellTitle = @"Ta支持的众筹";
            imgName =@"herzone_suport.png";
            dataNum = [_userProjectNums valueForKey:@"order"];
            break;
        case 2:
            cellTitle = @"Ta发起的众筹";
            imgName =@"herzone_sponsor.png";
            dataNum = [_userProjectNums valueForKey:@"project"];
            break;
            
        default:
            break;
    }
    

    cellImg = [UIImage imageNamed:imgName];
    [userCell.cellPic setBackgroundImage:cellImg forState:UIControlStateNormal];
    [userCell.dataTitle setText:cellTitle];
    userCell.dataTitle.font = main_font(18);
    userCell.dataTitle.alpha = 0.8f;
    if([StringUitl isNotEmpty:dataNum]){
       [userCell.dataNum setText:dataNum];
    }else{
       [userCell.dataNum setText:@"0"];
    }
   
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return userCell;

}


@end
