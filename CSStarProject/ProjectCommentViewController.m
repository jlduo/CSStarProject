//
//  ProjectCommentViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ProjectCommentViewController.h"

@interface ProjectCommentViewController (){
    UITableView *commentListTableView;
    
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    NSDictionary *cellDic;
    NSString *dataId;
    NSDictionary *params;
    UILabel *lblClickComment;
    
    NSString *commentId;
}

@end

@implementation ProjectCommentViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initHeadView];
    [self initLoadData];
    [self initToolBar];
    [self loadTableList];
    
}

-(void)initHeadView{
    UIView *headView = [[UIView alloc]init];
    [headView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, 70)];
    [headView setBackgroundColor:[StringUitl colorWithHexString:@"#F5F5F5"]];
    //标题
    UILabel *lblDetail=[[UILabel alloc] init];
    lblDetail.font = main_font(16);
    lblDetail.frame = CGRectMake(5, 5, SCREEN_WIDTH - 5, 35);
    lblDetail.text = [params valueForKey:@"projectName"];
    [headView addSubview:lblDetail];
    
    //时间
    UILabel *lblTimeComment = [[UILabel alloc] init];
    lblTimeComment.font = main_font(12);
    lblTimeComment.textColor = [UIColor grayColor];
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *ntime =[params valueForKey:@"addTime"];
    if([ntime length]>19){
        ntime = [ntime substringToIndex:19];
    }
    NSString *stime = [dateUtil getLocalDateFormateUTCDate1:ntime];
    lblTimeComment.text = stime;
    lblTimeComment.frame = CGRectMake(5, 40, 130, 30);
    [headView addSubview:lblTimeComment];

    //评论数图标
    UIImageView *imgComment=[[UIImageView alloc] init];
    imgComment.frame = CGRectMake(125, 46, 20, 20);
    imgComment.image = [UIImage imageNamed:@"myzone-discuss.png"];
    [headView addSubview:imgComment];
    
    //总评论数
    lblClickComment = [[UILabel alloc] init];
    lblClickComment.font = main_font(12);
    lblClickComment.textColor = [UIColor grayColor];
    lblClickComment.frame = CGRectMake(145, 40, 100, 30);
    lblClickComment.text = [[NSString alloc] initWithFormat:@"%@ 评论",[params valueForKey:@"talksNum"]];
    [headView addSubview:lblClickComment];
    
    [self.view addSubview:headView];
    
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64+70, SCREEN_WIDTH,MAIN_FRAME_H-116-40);
    
    commentListTableView = [[UITableView alloc] initWithFrame:tframe];
    commentListTableView.delegate = self;
    commentListTableView.dataSource = self;
    commentListTableView.rowHeight = 72;
    
    commentListTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    //commentListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [commentListTableView setTableFooterView:view];
    commentListTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:commentListTableView];
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


-(void)changeText:(UIButton *)sender{
    [textField becomeFirstResponder];
    
    [plabel removeFromSuperview];
    [cIconView removeFromSuperview];
    
     NSDictionary *clickDic = [self.proCommentList objectAtIndex:sender.tag];
     NSString *changTxt = [NSString stringWithFormat:@"回复 %@ ：",[clickDic valueForKey:@"creatName"]];
    commentId = [clickDic valueForKey:@"id"];
    [textField setText:changTxt];
    
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

//输入文字调用
-(void)textViewDidChange:(UITextView *)textView{
    NSString * textVal = textView.text;
    if([self isNotEmpty:textVal]){
        [plabel removeFromSuperview];
        textView.text = textVal;
    }
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
    
    NSString *contentKey;
    NSString *contentId;
    NSString *textVal = textField.text;
    NSLog(@"content=%@",textVal);
    
    //点击发表提交数据
    if([self isEmpty:textVal]){
        [self showCAlert:@"请输入评论信息后提交" widthType:WARNN_LOGO];
    }else{
        
        NSString *hf = [textVal substringToIndex:2];
        if([hf isEqualToString:@"回复"]){
            NSArray *charArr = [textVal componentsSeparatedByString:@"："];
            if(charArr.count==1 ||[charArr[1] isEqualToString:@""]){
                [self showCAlert:@"请输入评论信息后提交" widthType:WARNN_LOGO];
                return;
            }
        }
        
        //提交评论
        NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
        if ([self isEmpty:userId]) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        NSString *url;
        if(commentId!=nil){
            contentKey = @"tid";
            contentId = commentId;
            url = [[NSString alloc] initWithFormat:@"%@%@",REMOTE_URL,ADD_REVIEW_URL];
        }else{
            contentKey = @"pid";
            contentId = dataId;
            url = [[NSString alloc] initWithFormat:@"%@%@",REMOTE_URL,ADD_TALK_URL];
        }
        NSURL *comm_url = [NSURL URLWithString:url];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:comm_url];
        [ASIHTTPRequest setSessionCookies:nil];
        
        [request setUseCookiePersistence:YES];
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        [request setStringEncoding:NSUTF8StringEncoding];
        
        [request setPostValue:contentId forKey:contentKey];
        [request setPostValue:textVal forKey:@"content"];
        [request setPostValue:userId forKey:@"userId"];
        
        [request buildPostBody];
        
        [request startAsynchronous];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDidFinishSelector:@selector(requestFinished:)];
    }
}

//请求完成
- (void)requestFinished:(ASIHTTPRequest *)req{
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    //处理返回
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){
        textField.text = nil;
        [self dismissKeyBoard];
        
        [textField addSubview:cIconView];
        [plabel setFrame:CGRectMake(25, 2, 40, 26)];
        [textField addSubview:plabel];
        
        [self showCAlert:[jsonDic valueForKey:@"info"] widthType:SUCCESS_LOGO];
        [self loadTableList];
        [commentListTableView reloadData];
        
        lblClickComment.text = [[NSString alloc] initWithFormat:@"%d评论",_proCommentList.count];
    }else{
        [self showCAlert:[jsonDic valueForKey:@"info"] widthType:SUCCESS_LOGO];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)req{
    [self showCAlert:@"请求数据失败" widthType:WARNN_LOGO];
}





//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    params = vals;
    NSLog(@"vals====%@",vals);
}


-(void)loadTableList{
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PROJECT_TALKS_URL,dataId];
    NSArray *returnArr = (NSArray *)[convertJson requestData:url];
    if(returnArr!=nil && returnArr.count>0){
        _proCommentList = [NSMutableArray arrayWithArray:returnArr];
    }
    //NSLog(@"_proCommentList====%@",_proCommentList);
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _proCommentList.count;
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissKeyBoard];
    [plabel removeFromSuperview];
    cellDic = [self.proCommentList objectAtIndex:indexPath.row];
    NSString *cUserId = [[cellDic valueForKey:@"userId"] stringValue];
    NSString *nUserId = [StringUitl getSessionVal:LOGIN_USER_ID];
    NSString *huifuName = [cellDic valueForKey:@"huifuName"];
    if([huifuName isEqual:[NSNull null]] && ![cUserId isEqual:nUserId]){
        [textField becomeFirstResponder];
        NSString *changTxt = [NSString stringWithFormat:@"回复 %@ ：",[cellDic valueForKey:@"creatName"]];
        [textField setText:changTxt];
        commentId = [cellDic valueForKey:@"id"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectCommentTableCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCommCell"];
    if (commentCell == nil) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ProjectCommentTableCell" owner:self options:nil] ;
        commentCell = [nib objectAtIndex:0];
    }
    NSDictionary *dicComment = [_proCommentList  objectAtIndex:indexPath.row];
    NSString *commnetContent = [dicComment valueForKey:@"content"];
    
    //评论内容自适应
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(commentCell.contentTextView.frame.size.width,2000);
    CGSize labelsize = [commnetContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    if (labelsize.height > 20) {
        return  60 + labelsize.height;
    }else{
        return 80;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProjectCommentTableCell *projectCommCell;
    cellDic = [self.proCommentList objectAtIndex:indexPath.row];
    if(cellDic!=nil){
        
        static NSString *CustomCellIdentifier = @"ProjectCommCell";
        projectCommCell=  (ProjectCommentTableCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (projectCommCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"ProjectCommentTableCell" owner:self options:nil] ;
            projectCommCell = [nib objectAtIndex:0];
        }
        
        projectCommCell.selectionStyle =UITableViewCellSelectionStyleNone;
        projectCommCell.backgroundColor = [UIColor whiteColor];

        NSString *cUserId = [[cellDic valueForKey:@"userId"] stringValue];
        NSString *creatName = [cellDic valueForKey:@"creatName"];
        NSString *huifuName = [cellDic valueForKey:@"huifuName"];
        NSString *content = [cellDic valueForKey:@"content"];

        if(![huifuName isEqual:[NSNull null]]){
            [projectCommCell.replyBtn setTitle:@"" forState:UIControlStateNormal];
            [projectCommCell.replyBtn setTitle:@"" forState:UIControlStateSelected];
        }
        [projectCommCell.contentTextView setText:content];
        
        
        DateUtil *dateUtil = [[DateUtil alloc]init];
        NSString *ntime =[cellDic valueForKey:@"addTime"];
        if([ntime length]>19){
            ntime = [ntime substringToIndex:19];
        }
        NSString *stime = [dateUtil getLocalDateFormateUTCDate1:ntime];
        projectCommCell.commentDate.text = stime;
        projectCommCell.userName.font = main_font(12);
        projectCommCell.userName.text = creatName;
        projectCommCell.userAddress.text = [cellDic valueForKey:@"userCity"];
        
        [StringUitl setCornerRadius:projectCommCell.userIconView withRadius:24.0];
        //处理回复按钮
        if([cUserId isEqual:[StringUitl getSessionVal:LOGIN_USER_ID]]){
            [projectCommCell.replyBtn setTitle:@"" forState:UIControlStateNormal];
            [projectCommCell.replyBtn setTitle:@"" forState:UIControlStateSelected];
        }

        NSString *imgUrl =[cellDic valueForKey:@"avatar"];
        if(![imgUrl isEqual:[NSNull null]]){
            NSRange range = [imgUrl rangeOfString:@"/upload/"];
            if(range.location!=NSNotFound){//判断加载远程图像
                //改写异步加载图片
                [projectCommCell.userIconView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                                        placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
            }
        }
        //给回复按钮添加事件
         projectCommCell.replyBtn.tag = indexPath.row;
        [projectCommCell.replyBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchDown];
        
    }
    return projectCommCell;
}



@end
