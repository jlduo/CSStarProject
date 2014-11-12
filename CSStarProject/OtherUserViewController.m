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
    NSMutableDictionary *params;
    
    UITableView *stableView;
    UIButton *imgBtn;
    UILabel *userLabel;
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
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self initLoadData];
    [self initLoadUserData];
    [self getMyProjectsNums];
    [self setHeaderView];
    
}


-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    
    stableView = [[UITableView alloc] initWithFrame:tframe];
    stableView.delegate = self;
    stableView.dataSource = self;
    
    stableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    stableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [stableView setTableFooterView:view];
    stableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:stableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-44);
    [stableView setFrame:temFrame];
    
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

    NSString *url = [NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,dataId];
    _userData = (NSDictionary *)[ConvertJSONData requestData:url];
    NSLog(@"_userData===%@",_userData);
}

-(void)getMyProjectsNums{
    _userProjectNums = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_MYPROJECT_NUMS_URL,[params valueForKey:@"userId"]];
    NSString *pro_nums = (NSString *)[ConvertJSONData requestSData:url];
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
    NSLog(@"pro_nums===%@",_userProjectNums);
} 


-(void)setImgBtnImage{
    
    NSString *userLogo = [_userData valueForKey:@"logo"];
    NSRange range = [userLogo rangeOfString:@"upload"];
    if(range.location==NSNotFound){
        [imgBtn setBackgroundImage:[UIImage imageNamed:@"avatarbig.png"] forState:UIControlStateNormal];
    }else{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userLogo]];
        [imgBtn setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
        [imgBtn setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateSelected];
        if(imgData==nil){
            [imgBtn setBackgroundImage:[UIImage imageNamed:NOIMG_ICON_TX] forState:UIControlStateNormal];
            [imgBtn setBackgroundImage:[UIImage imageNamed:NOIMG_ICON_TX] forState:UIControlStateSelected];
        }
    }
}


-(void)setUserTitle{
    userLabel.font = main_font(16);
    [userLabel setText:[_userData valueForKey:@"nickname"]];
}


-(void)setHeaderView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [headView setBackgroundColor:[UIColor grayColor]];
    
    imgBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 10, 120, 120)];
    imgBtn.layer.masksToBounds = YES;
    imgBtn.layer.cornerRadius = 60.0f;
    
    [self setImgBtnImage];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"myzonebg.png"]];
    
    [imgView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [imgView setUserInteractionEnabled:YES];//处理图片点击生效
    
    userLabel =[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2, 100, 240, 100)];
    [self setUserTitle];
    [userLabel setTextColor:[UIColor blackColor]];
    [userLabel setTextAlignment:NSTextAlignmentCenter];
    [userLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    [imgView addSubview:userLabel];
    [imgView addSubview:imgBtn];
    [headView addSubview:imgView];
    
    stableView.tableHeaderView = headView;
    
}


-(void)goPreviou{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    PeopleProListViewController *peopleListController = [[PeopleProListViewController alloc]init];
    passValelegate = peopleListController;
    
    [params setObject:titleName forKey:@"titleName"];
    [passValelegate passDicValue:params];
    [self.navigationController pushViewController:peopleListController animated:YES];
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *nibIdentifier = @"UserViewCell";
    UINib *nibCell = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [stableView registerNib:nibCell forCellReuseIdentifier:nibIdentifier];
    
    UserTableViewCell *userCell = [stableView dequeueReusableCellWithIdentifier:@"UserViewCell"];
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
        [userCell.tagBgView setBackgroundImage:[UIImage imageWithData:nil] forState:UIControlStateNormal];
    }
   
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return userCell;

}


@end
