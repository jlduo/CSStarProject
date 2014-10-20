//
//  PeopleDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleDetailViewController.h"

@interface PeopleDetailViewController (){
    UITableView *detailTableView;
    
    UIView *toolBar;
    NSString *dataId;
    UIButton *supportBtn;
    UIButton *rebackBtn;
    NSDictionary *cellDic;
    
    MBProgressHUD *HUD;
}

@end

@implementation PeopleDetailViewController

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
    [self initProjectData];
    [self initLoadData];
    
    self.view.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
}
-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"活动众筹" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-40-44);
    [detailTableView setFrame:temFrame];

    [self initProjectData];
    [detailTableView reloadData];
    
}


//初始化底部工具栏
-(void)initToolBar{
    
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(10, MAIN_FRAME_H-25, SCREEN_WIDTH-20, 46)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    
    [self initSupButton];
    [self.view addSubview:toolBar];
    
    
}

-(void) initSupButton{
    //加入按钮
    supportBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115, 5, 90, 35)];
    [supportBtn.layer setMasksToBounds:YES];
    [supportBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [supportBtn setBackgroundColor:[UIColor redColor]];
    
    rebackBtn = [[UIButton alloc]initWithFrame:CGRectMake(2, 5, 180, 35)];
    [rebackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rebackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    NSString *returnsNum = [NSString stringWithFormat:@"查看该项目有%@项回报",[_peopleData valueForKey:@"returnsNum"]];
    [rebackBtn setTitle:returnsNum forState:UIControlStateNormal];
    [rebackBtn setTitle:returnsNum forState:UIControlStateHighlighted];
    rebackBtn.titleLabel.font = DESC_FONT;
    [rebackBtn addTarget:self action:@selector(clickSupBtn) forControlEvents:UIControlEventTouchDown];
    
    //给按钮默认显示评论数据
    [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [supportBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [supportBtn setTitle:@"立即支持" forState:UIControlStateNormal];
    [supportBtn setTitle:@"立即支持" forState:UIControlStateHighlighted];
    supportBtn.titleLabel.font = main_font(14);
    //给按钮绑定事件
    [supportBtn addTarget:self action:@selector(clickSupBtn) forControlEvents:UIControlEventTouchDown];
    
    [toolBar addSubview:rebackBtn];
    [toolBar addSubview:supportBtn];
}


-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    
    detailTableView = [[UITableView alloc] initWithFrame:tframe];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    
    detailTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [detailTableView setTableFooterView:view];
    detailTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:detailTableView];
    
    [self initToolBar];
}

//初始化数据
-(void)initProjectData{
    if(dataId!=nil){
        
        ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PROJECT_URL,dataId];
         _peopleData= (NSDictionary *)[convertJson requestData:url];
        NSLog(@"_peopleData===%@",_peopleData);
        
    }
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)showCustomAlert:(NSString *)msg widthType:(NSString *)tp{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    //[imgView setFrame:CGRectMake(0, 0, 48, 48)];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
	
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
    
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 1:
            [self goTaHomePage];
            break;
        case 2:
            [self goCommentList];
            break;
        default:
            break;
    }
    
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 395;
    }else if(indexPath.row==1){
        return 55;
    }else{
        return 49;
    }
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = _peopleData;
    if(indexPath.row==0){
        UINib *nibCell = [UINib nibWithNibName:@"PeopleTableDetailCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"DetailCell"];
        
        PeopleTableDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        detailCell.selectionStyle =UITableViewCellSelectionStyleNone;
        detailCell.backgroundColor = [UIColor clearColor];
        
        
        NSString *imgUrl =[cellDic valueForKey:@"imgUrl"];
        NSLog(@"imgurl==%@",imgUrl);
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            //改写异步加载图片
            [detailCell.cellImageView setImageWithURL:[NSURL URLWithString:imgUrl]
                                  placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        }
        
        NSString *stateName;
        NSString *tagPicName;
        int stateNum = [[cellDic valueForKey:@"projectStatus"] intValue];
        switch (stateNum) {
            case 2:
                stateName = @"未开始";
                tagPicName =@"label_nostart";
                break;
            case 3:
                stateName = @"筹款中";
                tagPicName =@"label_fundraising.png";
                break;
            default:
                stateName = @"已结束";
                tagPicName =@"lable_success.png";
                break;
        }
        [detailCell.tagTitle setText:stateName];
        [detailCell.tagImgView setImage:[UIImage imageNamed:tagPicName]];

        
        
        detailCell.cellTitle.font = TITLE_FONT;
        detailCell.cellTitle.text = [cellDic valueForKey:@"projectName"];
        NSString *days =[cellDic valueForKey:@"days"];
        NSString *money = [cellDic valueForKey:@"amount"];
        NSString *smoney = [cellDic valueForKey:@"totalamount"];
        NSString *endTime = [cellDic valueForKey:@"endTime"];
        endTime = [endTime substringToIndex:19];
        
        detailCell.moneyView.layer.masksToBounds = YES;
        detailCell.moneyView.layer.cornerRadius = 5;
        detailCell.dateView.text = [NSString stringWithFormat:@"目标%@天 剩余%@天",days,[self changeDate:endTime]];
        detailCell.moneyView.text = [NSString stringWithFormat:@"￥%@ / ￥%@",smoney,money];
        //计算百分比
        float amoney = [money floatValue];
        float bmoney;
        if(smoney==nil){
            bmoney = 0;
        }else{
            bmoney = [smoney floatValue];
        }
        
        float percent = bmoney / amoney;
        float imgWith = percent*616;
        
        NSString *perceStr = [NSString stringWithFormat:@"已完成%0.1f%@",percent*100,@"%"];
        detailCell.pecentView.text = perceStr;
        
        UIImage *sourceImage = [UIImage imageNamed:@"progressbar-success.png"];
        UIImage *sourceImage2 = [UIImage imageNamed:@"progressbar-nosuccess.png"];
        if(imgWith!=0){
            UIImage *newImage = [self imageFromImage:sourceImage inRect:CGRectMake(0, 0, imgWith, 10)];
            detailCell.redProgressView.image = newImage;
        }
        
        UIImage *newImage2 = [self imageFromImage:sourceImage2 inRect:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        detailCell.blackProgressView.image = newImage2;
        
        detailCell.redProgressView.contentMode = UIViewContentModeLeft;
        detailCell.blackProgressView.contentMode = UIViewContentModeScaleToFill;
        
        detailCell.descView.text = [cellDic valueForKey:@"introduction"];
        detailCell.descView.editable = NO;
        
        NSString *likeBtnText = [NSString stringWithFormat:@"喜欢 %@",[[cellDic valueForKey:@"loveNum"] stringValue]];
        [detailCell.likeBtn setTitle:likeBtnText forState:UIControlStateNormal];
        [detailCell.likeBtn setTitle:likeBtnText forState:UIControlStateHighlighted];
        [detailCell.likeBtn setTitle:likeBtnText forState:UIControlStateSelected];
        
        NSString *supportBtnText = [NSString stringWithFormat:@"支持 %@",[[cellDic valueForKey:@"totalpersons"] stringValue]];
        [detailCell.supportBtn setTitle:supportBtnText forState:UIControlStateNormal];
        [detailCell.supportBtn setTitle:supportBtnText forState:UIControlStateHighlighted];
        [detailCell.supportBtn setTitle:supportBtnText forState:UIControlStateSelected];
        
        //添加详情点击事件
        [detailCell.seeDetailBtn addTarget:self action:@selector(goDetail) forControlEvents:UIControlEventTouchDown];
        //添加喜欢动作
        [detailCell.likeBtn addTarget:self action:@selector(clickLikeBtn) forControlEvents:UIControlEventTouchDown];
        //添加支持动作
        [detailCell.supportBtn addTarget:self action:@selector(clickSupBtn) forControlEvents:UIControlEventTouchDown];
        
        return detailCell;
        
        
    }else if(indexPath.row==1){

        UINib *nibCell = [UINib nibWithNibName:@"PeopleCenterCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"CenterCell"];
    
        PeopleCenterCell *centerCell = [tableView dequeueReusableCellWithIdentifier:@"CenterCell"];
        centerCell.selectionStyle =UITableViewCellSelectionStyleNone;
        centerCell.backgroundColor = [UIColor clearColor];
        
        NSString *imgUrl =[cellDic valueForKey:@"touxiang"];
        //NSLog(@"touxiang==%@",imgUrl);
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            [centerCell.userIcon setImageWithURL:[NSURL URLWithString:imgUrl]
                                     placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        }
        
        centerCell.userIcon.layer.cornerRadius = 18;
        centerCell.userIcon.layer.masksToBounds = YES;
        
        centerCell.userName.text = [NSString stringWithFormat:@"%@(发起人)",[cellDic valueForKey:@"nickName"]];
        centerCell.userName.font = DESC_FONT;
        
        return centerCell;
        
    }else{
        
        UINib *nibCell = [UINib nibWithNibName:@"PeopleCommentCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"CommentCell"];

        PeopleCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        commentCell.selectionStyle =UITableViewCellSelectionStyleNone;
        commentCell.backgroundColor = [UIColor clearColor];
        
        commentCell.commentView.text = [NSString stringWithFormat:@"评论(%@)",[cellDic valueForKey:@"talksNum"]];
        
        return commentCell;
        
    }
   
}

-(void)goDetail{
    NSLog(@"ssss");
    ContentDetailViewController *deatilController = [[ContentDetailViewController alloc]init];
    passValelegate = deatilController;
    [passValelegate passValue:dataId];
    [self presentViewController:deatilController animated:YES completion:nil];
}


-(void)goCommentList{
    NSLog(@"comment");
    ProjectCommentViewController *commentController = [[ProjectCommentViewController alloc]init];
    passValelegate = commentController;
    [passValelegate passValue:dataId];
    [passValelegate passDicValue:_peopleData];
    [self.navigationController pushViewController:commentController animated:YES];
}

-(void)goTaHomePage{
    NSLog(@"home");
    OtherUserViewController *otherUserController = [[OtherUserViewController alloc]init];
    passValelegate = otherUserController;
    
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc]init];
    [dicParam setObject:[_peopleData valueForKey:@"userId"] forKey:@"userId"];
    [dicParam setObject:[_peopleData valueForKey:@"userName"] forKey:@"userName"];
    [dicParam setObject:[_peopleData valueForKey:@"nickName"] forKey:@"nickName"];
    
    [passValelegate passDicValue:dicParam];
    [self.navigationController pushViewController:otherUserController animated:YES];
}


-(void)clickLikeBtn{
    
    NSURL *like_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,ADD_ENJOY_PROJECT_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:like_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:[StringUitl getSessionVal:@"login_user_id"] forKey:@"uid"];
    [request setPostValue:dataId forKey:@"pid"];
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    
}

- (void)requestFinished:(ASIHTTPRequest *)req
{
    //NSLog(@"request info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"false"]){
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:ERROR_LOGO];
    }else{
        [self showCustomAlert:[jsonDic valueForKey:@"info"] widthType:SUCCESS_LOGO];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)req
{
    [self showCustomAlert:@"请求数据失败！" widthType:ERROR_LOGO];
}


-(void)clickSupBtn{
    
    NSLog(@"dddd");
    ReturnsViewController *returnsController = [[ReturnsViewController alloc]init];
    passValelegate = returnsController;
    [passValelegate passValue:dataId];
    [self.navigationController pushViewController:returnsController animated:YES];
    
}

- (double)mxGetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE
{
    double timeDiff = 0.0;
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateS = [formatters dateFromString:timeS];
    
    NSDateFormatter *formatterE = [[NSDateFormatter alloc]init];
    [formatterE setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateE = [formatterE dateFromString:timeE];
    timeDiff = [dateE timeIntervalSinceDate:dateS];
    
    //单位秒
    return timeDiff;
}

-(NSString *)changeDate:(NSString *)endTime{
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *comDate = [dateUtil getLocalDateFormateUTCDate1:endTime];
    double times = [self mxGetStringTimeDiff:[dateUtil getCurDateTimeStr] timeE:comDate];
    times = times/(3600*24);
    NSNumber *numStage =  [NSNumber numberWithDouble:times];
    NSString *numStr = [NSString stringWithFormat:@"%0.0lf",[numStage doubleValue]];
    return numStr;
    
}


- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}




@end