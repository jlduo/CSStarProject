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
    NSMutableArray *tableArray;
    UITableView *table;
    NSInteger pageIndex;
    UILabel *lblClickComment;
}
@end

@implementation StoryCommentViewController

-(void)passValue:(NSString *)val{
    detailId = val;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //标题
    UILabel *lblDetail=[[UILabel alloc] init];
    lblDetail.font = [UIFont fontWithName:@"Helvetica" size:24];
    lblDetail.frame = CGRectMake(5, 69, SCREEN_WIDTH - 5, 35);
    [self.view addSubview:lblDetail];
    
    //时间
    UILabel *lblTimeComment = [[UILabel alloc] init];
    lblTimeComment.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblTimeComment.textColor = [UIColor grayColor];
    lblTimeComment.frame = CGRectMake(5, 104, 115, 30);
    [self.view addSubview:lblTimeComment];
    
    //评论数图标
    UIImageView *imgComment=[[UIImageView alloc] init];
    imgComment.frame = CGRectMake(120, 110, 20, 20);
    imgComment.image = [UIImage imageNamed:@"myzone-discuss.png"];
    [self.view addSubview:imgComment];
    
    //总评论数
    lblClickComment = [[UILabel alloc] init];
    lblClickComment.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblClickComment.textColor = [UIColor grayColor];
    lblClickComment.frame = CGRectMake(140, 104, 100, 30);
    [self.view addSubview:lblClickComment];
    
    //现实参数
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSString *requestUrl = [[NSString alloc] initWithFormat:@"%@/cms/GetArticle/%@",REMOTE_URL,detailId];
    NSDictionary *dicContent = (NSDictionary *)[jsonData requestData:requestUrl];
    lblDetail.text = [dicContent valueForKey:@"_title"];
    
    NSString *addTime = [dicContent valueForKey:@"_add_time"];
    DateUtil *utilDate = [[DateUtil alloc] init];
    addTime = [utilDate getLocalDateFormateUTCDate1:addTime];
    lblTimeComment.text = addTime;
    
    NSString *clickNum = [self getCommentNum];
    lblClickComment.text = [[NSString alloc] initWithFormat:@"%@评论",clickNum];
    
    //评论
    [self initTable];
    [self initToolBar];
    //获取评论列表
    pageIndex = 1;
    tableArray = [self getCommentList];
    
    [self setHeaderRereshing];
    [self setFooterRereshing];
}

-(NSMutableArray *)getCommentList{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/Comment/GetArticleComments/%@/10/%d",REMOTE_URL,detailId,pageIndex];
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    return (NSMutableArray *)[jsonData requestData:url];
}

-(void)initTable{
    table = [[UITableView alloc] initWithFrame:self.view.frame];
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 140, SCREEN_WIDTH, MAIN_FRAME_H - STATU_BAR_HEIGHT - NAV_TITLE_HEIGHT - 105); 
    [self.view addSubview:table];
    
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"StoryCommentTableCell" bundle:nil];
    [table registerNib:nibCell forCellReuseIdentifier:@"storyCommentCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    StoryCommentTableCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"storyCommentCell"];
    NSDictionary *dicComment = [tableArray objectAtIndex:indexPath.row];
    DateUtil *utilDate = [[DateUtil alloc] init];
    NSString *addTime = [utilDate getLocalDateFormateUTCDate1:[dicComment valueForKey:@"_add_time"]];
    commentCell.commentDateTime.text = addTime;
    NSString *imgUrl = [dicComment valueForKey:@"_avatar"];
    UIImage *picImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    [commentCell.commentImage setImage:picImg];
    NSString *commnetContent = [dicComment valueForKey:@"_content"];
    commentCell.commentTextView.text = commnetContent;
    commentCell.commentUsername.text = [dicComment valueForKey:@"_nick_name"];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return commentCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryCommentTableCell *commentCell = [table dequeueReusableCellWithIdentifier:@"storyCommentCell"];
    NSDictionary *dicComment = [tableArray objectAtIndex:indexPath.row];
    NSString *commnetContent = [dicComment valueForKey:@"_content"];
    
    //评论内容自适应
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake( commentCell.commentTextView.frame.size.width,2000);
    CGSize labelsize = [commnetContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height > commentCell.commentTextView.frame.size.height) { 
        return  commentCell.frame.size.height + labelsize.height - commentCell.commentTextView.frame.size.height;
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
        [self alertMsg:@"对不起,请输入评论信息后提交!" withtitle:@"［错误提示］"];
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
        
        [StringUitl alertMsg:@"提交成功" withtitle:nil];
        pageIndex = 1;
        tableArray = [self getCommentList];
        [table reloadData];
        
        NSString *clickNum = [self getCommentNum];
        lblClickComment.text = [[NSString alloc] initWithFormat:@"%@评论",clickNum];
    }else{
        [StringUitl alertMsg:[jsonDic valueForKey:@"result"] withtitle:@"错误提示"];
    }
}

- (void)requestLoginFailed:(ASIHTTPRequest *)req{
    [StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
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
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:table position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        pageIndex = 1;
        [self performSelector:@selector(callBackMethod:) withObject:@"top"];
        [view performSelector:@selector(finishedLoading)];
    }];
    [table addSubview:topPullView];
}

//加底部部刷新
-(void)setFooterRereshing{
    AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:table position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        pageIndex++;
        [self performSelector:@selector(callBackMethod:) withObject:@"foot"];
        [view performSelector:@selector(finishedLoading)];
    }];
    [table addSubview:bottomPullView];
}

//请求完成之后，回调方法
-(void)callBackMethod:(id)isTop
{
    NSMutableArray *nextArray = [self getCommentList];
    if ([isTop isEqualToString:@"top"]) {
        tableArray = nextArray;
    } else {
        [tableArray addObjectsFromArray:nextArray];
    }
    if(nextArray!=nil && nextArray.count>0){
        table.backgroundColor = [UIColor lightGrayColor];
        [table reloadData];
    }else{
        [StringUitl alertMsg:@"没有数据了！" withtitle:@"提示"]; 
    }
}

@end
