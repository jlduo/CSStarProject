//
//  PeopleDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-10.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "PeopleDetailViewController.h"

@interface PeopleDetailViewController (){
    UIView *toolBar;
    NSString *dataId;
    UIButton *supportBtn;
    UIButton *rebackBtn;
    NSDictionary *cellDic;
    MarqueeLabel *titleLabel;
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
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    [self initProjectData];
    [self initLoadData];
    [self initToolBar];
    
    self.view.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
    _peopleDetailTable.showsVerticalScrollIndicator = NO;
}
-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"活动众筹" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];

    [titleLabel removeFromSuperview];
    [self initProjectData];
    [_peopleDetailTable reloadData];
    
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

    _peopleDetailTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _peopleDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    
}

//初始化数据
-(void)initProjectData{
    if(dataId!=nil){
    
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PROJECT_URL,dataId];
        _peopleData = (NSDictionary *)[ConvertJSONData requestData:url];
        [self hideHud];
        [_peopleDetailTable reloadData];
    }
}

-(void)requestDataByUrl:(NSString *)url{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        _peopleData = (NSDictionary *)responseObject;
        [self hideHud];
        [_peopleDetailTable reloadData];
        
    }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self requestFailed:error];
        
    }];
    
}

- (void)requestFailed:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:ERROR_INNER];
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    //NSLog(@"dataId====%@",dataId);
}
-(void)passDicValue:(NSDictionary *)vals{
    
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
        [detailCell.cellImageView md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        NSString *stateName;
        NSString *tagPicName;
        int stateNum = [[cellDic valueForKey:@"projectStatus"] intValue];
        //项目状态 1 草稿 2 待审核 3 已审核 4 已成功 5 已失败
        switch (stateNum) {
            case 1:
                stateName = @"未开始";
                tagPicName =@"label_nostart";
                break;
            case 2:
                stateName = @"未开始";
                tagPicName =@"label_nostart";
                break;
            case 3:
                stateName = @"筹款中";
                tagPicName =@"label_fundraising.png";
                break;
            case 4:
                stateName = @"已结束";
                tagPicName =@"lable_success_s.png";
                break;
            default:
                stateName = @"已失败";
                tagPicName =@"lable_success_s.png";
                break;
        }
        [detailCell.tagTitle setText:stateName];
        [detailCell.tagImgView setImage:[UIImage imageNamed:tagPicName]];
        detailCell.cellTitle.text = @"";
        titleLabel = [[MarqueeLabel alloc] initWithFrame:detailCell.cellTitle.frame duration:15.0 andFadeLength:10.0f];
        titleLabel.text = [cellDic valueForKey:@"projectName"];

        [detailCell addSubview:titleLabel];
        
        
        
        
        NSString *days =[cellDic valueForKey:@"days"];
        NSString *money = [[cellDic valueForKey:@"amount"] stringValue];
        NSString *smoney = [[cellDic valueForKey:@"totalamount"] stringValue];
        NSString *endTime = [cellDic valueForKey:@"endTime"];
        endTime = [endTime substringToIndex:19];
        
        detailCell.moneyView.layer.masksToBounds = YES;
        detailCell.moneyView.layer.cornerRadius = 5;
        detailCell.dateView.text = [NSString stringWithFormat:@"目标%@天 剩余%d天",days,[self changeDate:endTime]];
        detailCell.moneyView.text = [NSString stringWithFormat:@"￥%@ / ￥%@",smoney,money];
        NSLog(@"money=%@",money);
        NSLog(@"smoney=%@",smoney);
        //计算百分比
        float amoney = [money floatValue];
        float bmoney;
        if(smoney==nil){
            bmoney = 0;
        }else{
            bmoney = [smoney floatValue];
        }
        
        float percent = bmoney / amoney;
        float imgWith = percent*320;
        
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
        
        
        [StringUitl setCornerRadius:detailCell.cellContentView withRadius:5.0];
        [StringUitl setViewBorder:detailCell.cellContentView withColor:@"#cccccc" Width:0.5f];
        
        return detailCell;
        
        
    }else if(indexPath.row==1){

        UINib *nibCell = [UINib nibWithNibName:@"PeopleCenterCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"CenterCell"];
    
        PeopleCenterCell *centerCell = [tableView dequeueReusableCellWithIdentifier:@"CenterCell"];
        centerCell.selectionStyle =UITableViewCellSelectionStyleNone;
        centerCell.backgroundColor = [UIColor clearColor];
        
        NSString *imgUrl =[cellDic valueForKey:@"touxiang"];
        [centerCell.userIcon md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        
        centerCell.userIcon.layer.cornerRadius = 18;
        centerCell.userIcon.layer.masksToBounds = YES;
        
        NSString *nickName =[cellDic valueForKey:@"nickName"];
        if([StringUitl isEmpty:nickName])nickName = BLANK_NICK_NAME;
        
        centerCell.userName.text = [NSString stringWithFormat:@"%@(发起人)",nickName];
        centerCell.userName.font = DESC_FONT;
        
        [StringUitl setCornerRadius:centerCell.backgroundView withRadius:5.0];
        [StringUitl setViewBorder:centerCell.backgroundView withColor:@"#cccccc" Width:0.5f];
        
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
    //NSLog(@"ssss");
    ContentDetailViewController *deatilController =  (ContentDetailViewController *)[self getVCFromSB:@"contentDetail"];
    passValelegate = deatilController;
    [passValelegate passValue:dataId];
    [self presentViewController:deatilController animated:YES completion:nil];
}


-(void)goCommentList{
    //NSLog(@"comment");
    ProjectCommentViewController *commentController =  (ProjectCommentViewController *)[self getVCFromSB:@"projectComment"];
    passValelegate = commentController;
    [passValelegate passValue:dataId];
    [passValelegate passDicValue:_peopleData];
    [self.navigationController pushViewController:commentController animated:YES];
}

-(void)goTaHomePage{
    //NSLog(@"home");
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *otherUserController =  [storyBoard instantiateViewControllerWithIdentifier:@"otherUserCenter"];
    passValelegate = otherUserController;
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc]init];
    [dicParam setObject:[_peopleData valueForKey:@"userId"] forKey:@"userId"];
    [dicParam setObject:[_peopleData valueForKey:@"userName"] forKey:@"userName"];
    [dicParam setObject:[_peopleData valueForKey:@"nickName"] forKey:@"nickName"];
    [passValelegate passDicValue:dicParam];
    [self.navigationController pushViewController:otherUserController animated:YES];
    
}


-(void)clickLikeBtn{
    
    NSString *like_url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,ADD_ENJOY_PROJECT_URL];
    NSDictionary *parameters = @{@"pid":dataId,@"uid":[StringUitl getSessionVal:@"login_user_id"]};
    [HttpClient POST:like_url
         parameters:parameters
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *jsonDic =(NSDictionary *)responseObject;
         if([[jsonDic valueForKey:@"status"] isEqualToString:@"false"]){
             [self showNo:[jsonDic valueForKey:@"info"]];
         }else{
             [titleLabel removeFromSuperview];
             [self initProjectData];
             [_peopleDetailTable reloadData];
             [self showOk:[jsonDic valueForKey:@"info"]];
         }
         
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailed:error];
         
     }];
    
}


-(void)clickSupBtn{
    int stateNum = [[cellDic valueForKey:@"projectStatus"] intValue];
    if(stateNum==1||stateNum==2){
        [self showNo:@"对不起，项目未开始!"];
    }else if(stateNum==4){
        [self showNo:@"对不起，项目已结束!"];
    }else if(stateNum==5){
        [self showNo:@"对不起，项目已失败!"];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReturnsViewController *returnsController =  [storyBoard instantiateViewControllerWithIdentifier:@"returnList"];
        passValelegate = returnsController;
        [passValelegate passValue:dataId];
        [self.navigationController pushViewController:returnsController animated:YES];
    }
    
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

-(int)changeDate:(NSString *)endTime{
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *comDate = [dateUtil getLocalDateFormateUTCDate1:endTime];
    double times = [self mxGetStringTimeDiff:[dateUtil getCurDateTimeStr] timeE:comDate];
    times = times/(3600*24);
    NSNumber *numStage =  [NSNumber numberWithDouble:times];
    if([numStage integerValue]<0){
        numStage = 0;
    }
    return [numStage intValue];
    
}


- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage =[UIImage imageWithCGImage:newImageRef];
    //释放资源
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end
