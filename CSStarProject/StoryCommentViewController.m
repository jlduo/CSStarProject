//
//  StoryCommentViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-16.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryCommentViewController.h"

@interface StoryCommentViewController (){
    NSString *detailId;
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    UITableView *commtable;
    NSInteger pageIndex;
    UILabel *lblClickComment;
    UILabel *lblTimeComment;
    NSMutableArray *tableArray;
    UILabel *lblDetail;
    
    NSDictionary *params;
    NSMutableArray *commonArr;
    DateUtil *utilDate;
    NSString *plDate;
    
    NSInteger selectedCount;
    XHFriendlyLoadingView *friendlyLoadingView;
}
@end

@implementation StoryCommentViewController

-(void)passValue:(NSString *)val{
    detailId = val;
}


-(void)dealloc{
    detailId = nil;
    toolBar = nil;
    numBtn = nil;
    plabel = nil;
    cIconView = nil;
    textField = nil;
    commtable = nil;
    params = nil;
    lblClickComment = nil;
    tableArray = nil;
    friendlyLoadingView = nil;
}

-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals==%@",vals);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initloadData];
    [self initLoading];
    
}

-(void)initloadData{
    
    self.view.backgroundColor = [UIColor whiteColor];
    commtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    utilDate = [[DateUtil alloc] init];
    //标题
    lblDetail=[[UILabel alloc] init];
    lblDetail.font = main_font(16);
    lblDetail.frame = CGRectMake(5, 69, SCREEN_WIDTH - 5, 35);
    [self.view addSubview:lblDetail];
    
    //时间
    lblTimeComment = [[UILabel alloc] init];
    lblTimeComment.font = main_font(12);
    lblTimeComment.textColor = [UIColor grayColor];
    lblTimeComment.frame = CGRectMake(5, 104, 130, 30);
    [self.view addSubview:lblTimeComment];
    
    //评论数图标
    UIImageView *imgComment=[[UIImageView alloc] init];
    imgComment.frame = CGRectMake(125, 110, 20, 20);
    imgComment.image = [UIImage imageNamed:@"myzone-discuss.png"];
    [self.view addSubview:imgComment];
    
    //总评论数
    lblClickComment = [[UILabel alloc] init];
    lblClickComment.font = main_font(12);
    lblClickComment.textColor = [UIColor grayColor];
    lblClickComment.frame = CGRectMake(145, 104, 100, 30);
    [self.view addSubview:lblClickComment];
    
    NSString *clickNum = [self getCommentNum];
    lblClickComment.text = [[NSString alloc] initWithFormat:@"%@评论",clickNum];
    lblClickComment.font = main_font(12);
    //评论
    [self initTable];
    [self initToolBar];
    //获取评论列表
    pageIndex = 1;
    [self loadBanerData];
    [self getCommentList];
    
    //[self setHeaderRereshing];
    //[self setFooterRereshing];
    
}

-(void)initLoading{
    if(friendlyLoadingView==nil){
        friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H)];
    }
    __weak typeof(self) weakSelf = self;
    friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        [weakSelf loadBanerData];
        [weakSelf getCommentList];
        [weakSelf initloadData];
    };
    
    [self.view addSubview:friendlyLoadingView];
    
    [friendlyLoadingView showFriendlyLoadingViewWithText:@"正在加载..." loadingAnimated:YES];
}

- (void)showLoading {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        selectedCount ++;
        if (selectedCount == 3) {
            [friendlyLoadingView showFriendlyLoadingViewWithText:@"重新加载失败，请检查网络。" loadingAnimated:NO];
        } else {
            [friendlyLoadingView showReloadViewWithText:@"加载失败，请点击刷新。"];
        }
    });
}



-(void)loadBanerData{
    
    NSString *requestUrl = [[NSString alloc] initWithFormat:@"%@/cms/GetArticle/%@",REMOTE_URL,detailId];
    [self requestDataByUrl:requestUrl withType:1 withIndex:nil];
    
}

-(void)getCommentList{
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@/%@/10/%d",REMOTE_URL,GET_COMMENT_URL,detailId,pageIndex];
    [self requestDataByUrl:url withType:2 withIndex:nil];
    
}

-(void)requestDataByUrl:(NSString *)url withType:(int)type withIndex:(NSString *)pageIndex{
    //处理路劲
    NSURL *reqUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:reqUrl];
    //设置代理
    [request setDelegate:self];
    [request startAsynchronous];
    [request setTag:type];
    
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *respData = [request responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"tag->%d",request.tag);
    commonArr = (NSMutableArray *)jsonDic;
    if(commonArr!=nil && commonArr.count>0){
        
        switch (request.tag) {
            case 1:
                lblDetail.text = [jsonDic valueForKey:@"_title"];
                plDate =[utilDate getLocalDateFormateUTCDate1:[jsonDic valueForKey:@"_add_time"]];
                lblTimeComment.text = plDate;
                break;
            case 2:
                tableArray = commonArr;
                break;
            default:
                break;
        }
        
        [commtable reloadData];
        [self setHeaderRereshing];
        [self setFooterRereshing];
        [friendlyLoadingView removeFromSuperview];
        
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    [self initLoading];
    [self setHeaderRereshing];
    [self showLoading];
}

-(void)initTable{
    commtable = [[UITableView alloc] initWithFrame:self.view.frame];
    commtable.delegate = self;
    commtable.dataSource = self;
    commtable.frame = CGRectMake(0, 140, SCREEN_WIDTH, MAIN_FRAME_H - STATU_BAR_HEIGHT - NAV_TITLE_HEIGHT - 105);
    [self.view addSubview:commtable];
    
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"StoryCommentTableCell" bundle:nil];
    [commtable registerNib:nibCell forCellReuseIdentifier:@"storyCommentCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    StoryCommentTableCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"storyCommentCell"]; 
    
    NSDictionary *dicComment = [tableArray  objectAtIndex:indexPath.row];
    NSString *addTime = [utilDate getLocalDateFormateUTCDate1:[dicComment valueForKey:@"_add_time"]];
    commentCell.commentDateTime.text = addTime;
    NSString *imgUrl = [dicComment valueForKey:@"_avatar"];
    UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    [commentCell.commentImage setImage:picImg];
    NSString *commnetContent = [dicComment valueForKey:@"_content"];
    commentCell.commentTextView.text = commnetContent;
    commentCell.commentUsername.text = [dicComment valueForKey:@"_nick_name"];
    commentCell.commentUsername.font = main_font(14);
    commentCell.commentTextView.font = main_font(12);
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return commentCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray .count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryCommentTableCell *commentCell = [commtable dequeueReusableCellWithIdentifier:@"storyCommentCell"];
    NSDictionary *dicComment = [tableArray  objectAtIndex:indexPath.row];
    NSString *commnetContent = [dicComment valueForKey:@"_content"];
    
    //评论内容自适应
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(commentCell.commentTextView.frame.size.width,2000);
    CGSize labelsize = [commnetContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height > 20) {
        return  60 + labelsize.height;
    }
    else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissKeyBoard];
}

//初始化底部工具栏
-(void)initToolBar{
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, MAIN_FRAME_H-20, SCREEN_WIDTH, 40)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    
    [self initTextView];
    [self initCommentIcon];
    [self initCommentText];
    [self initButton];
    
    [self.view addSubview:toolBar];
}

-(void)initTextView{
    //加入输入框
    textField = [[UITextView alloc]initWithFrame:CGRectMake(6, 5, toolBar.frame.size.width-65, 30)];
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth =0.5;
    textField.layer.cornerRadius =5.0;
    textField.delegate = self;
    [toolBar addSubview:textField];
}

-(void)initCommentIcon{
    //在文本域内加入图标
    cIconView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 24, 22)];
    cIconView.image = [UIImage imageNamed:@"discussicon.png"];
    [textField addSubview:cIconView];
}

-(void)initCommentText{
    //加入评论文字
    plabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 2, 40, 26)];
    [plabel setText:@"评论"];
    [plabel setFont:Font_Size(12)];
    [plabel setTextAlignment:NSTextAlignmentCenter];
    [plabel setTextColor:[UIColor grayColor]];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [textField addSubview:plabel];
    
}

-(void) initButton{
    //加入按钮
    numBtn = [[UIButton alloc]initWithFrame:CGRectMake(textField.frame.size.width+12, 5, 45, 30)];
    [numBtn.layer setMasksToBounds:YES];
    [numBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [numBtn.layer setBorderWidth:0.5];   //边框宽度
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
    [numBtn.layer setBorderColor:colorref];
    
    [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [numBtn setTitle:@"发 表" forState:UIControlStateNormal];
    [numBtn setTitle:@"发 表" forState:UIControlStateHighlighted];
    numBtn.titleLabel.font = Font_Size(14);
    
    //给按钮绑定事件
    [numBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchDown];
    [toolBar addSubview:numBtn];
}

//获取评论条数
-(NSString *)getCommentNum{
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@/Comment/GetCommentTotal/%@",REMOTE_URL,detailId];
    NSDictionary *commentDic = (NSDictionary *)[convertJson requestData:url];
    NSString *comments = [commentDic valueForKey:@"result"];
    return comments;
}

//输入文字调用
-(void)textViewDidChange:(UITextView *)textView{
    NSString * textVal = textView.text;
    if([self isNotEmpty:textVal]){
        [plabel removeFromSuperview];
        textView.text = textVal;
    }
}
//取消回车事件 改为关闭键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

//关闭键盘
-(void) dismissKeyBoard{
    [textField resignFirstResponder];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [textField setFrame:CGRectMake(5, textField.frame.origin.y,textField.frame.size.width,textField.frame.size.height+30)];
        [textField setTextAlignment:NSTextAlignmentNatural];
        [toolBar setFrame:CGRectMake(0, MAIN_FRAME_H-50-height, SCREEN_WIDTH,toolBar.frame.size.height+30)];
        [numBtn setFrame:CGRectMake(textField.frame.size.width+12, 34, 45, 30)];
        
        [cIconView removeFromSuperview];
        [plabel setFrame:CGRectMake(0, plabel.frame.origin.y, plabel.frame.size.width, plabel.frame.size.height)];
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.3 animations:^{
        [textField setFrame:CGRectMake(6, 5, toolBar.frame.size.width-65, 30)];
        [toolBar setFrame:CGRectMake(0, MAIN_FRAME_H-20, SCREEN_WIDTH, 40)];
        [numBtn setFrame:CGRectMake(textField.frame.size.width+12, 5, 45, 30)];
        
        if([self isEmpty:textField.text]){
            [textField addSubview:plabel];
        }
    }];
}


-(void)commentBtnClick{
    NSString *textVal = textField.text;
    //点击发表提交数据
    if([self isEmpty:textVal]){ 
        [self showCAlert:@"请输入评论信息后提交" widthType:WARNN_LOGO];
    }else{
        //提交评论
        NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
        if ([self isEmpty:userId]) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        NSString *userName = [StringUitl getSessionVal:LOGIN_USER_NAME];
        NSString *url = [[NSString alloc] initWithFormat:@"%@/Comment/AddComment/",REMOTE_URL];
        NSURL *login_url = [NSURL URLWithString:url];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:login_url];
        [ASIHTTPRequest setSessionCookies:nil];
        
        [request setUseCookiePersistence:YES];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setStringEncoding:NSUTF8StringEncoding];
        
        [request setPostValue:detailId forKey:@"articleId"];
        [request setPostValue:textVal forKey:@"txtContent"];
        [request setPostValue:userId forKey:@"userid"];
        [request setPostValue:userName forKey:@"username"];
        
        [request buildPostBody];
        
        [request startAsynchronous];
        [request setDidFailSelector:@selector(requestLoginFailed:)];
        [request setDidFinishSelector:@selector(requestLoginFinished:)];
    }
}

//请求完成
- (void)requestLoginFinished:(ASIHTTPRequest *)req{
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    //处理返回
    if([[jsonDic valueForKey:@"result"] isEqualToString:@"ok"]){
        textField.text = nil;
        [self dismissKeyBoard];
        
        [textField addSubview:cIconView];
        [plabel setFrame:CGRectMake(25, 2, 40, 26)];
        [textField addSubview:plabel]; 
        
        [self showCAlert:@"评论提交成功" widthType:WARNN_LOGO];
        pageIndex = 1;
        [self getCommentList];
        [commtable reloadData];
        
        NSString *clickNum = [self getCommentNum];
        lblClickComment.text = [[NSString alloc] initWithFormat:@"%@评论",clickNum];
    }else{
        [self showCAlert:[jsonDic valueForKey:@"result"] widthType:WARNN_LOGO];
    }
}

- (void)requestLoginFailed:(ASIHTTPRequest *)req{
     [self showCAlert:@"请求数据失败" widthType:WARNN_LOGO];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
}
-(void)goPreviou{
    [super goPreviou];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}

//加载头部刷新
-(void)setHeaderRereshing{
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:commtable position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        pageIndex = 1;
        [self performSelector:@selector(callBackMethod:) withObject:@"top" afterDelay:DELAY_TIME];
        [view performSelector:@selector(finishedLoading) withObject:@"top" afterDelay:1.0f];
    }];
    [commtable addSubview:topPullView];
}

//加底部部刷新
-(void)setFooterRereshing{
    AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:commtable position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        pageIndex++;
        [self performSelector:@selector(callBackMethod:) withObject:@"foot" afterDelay:DELAY_TIME];
        [view performSelector:@selector(finishedLoading) withObject:@"foot" afterDelay:1.0f];
    }];
    [commtable addSubview:bottomPullView];
}

//请求完成之后，回调方法
-(void)callBackMethod:(id)isTop
{
    
    [self getCommentList];
}


@end
