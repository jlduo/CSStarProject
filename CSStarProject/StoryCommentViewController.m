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
    NSInteger pageIndex;
    NSMutableArray *tableArray;
    NSDictionary *dicContent;
    NSString *commentId;
    NSDictionary * params;
    
    int flag;
}
@end

@implementation StoryCommentViewController

-(void)passValue:(NSString *)val{
    detailId = val;
}

-(void)passDicValue:(NSDictionary *)vals{
    params = vals;
    NSLog(@"params=%@",params);
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
    [self showLoading:@"数据加载中..."];
    [super viewDidLoad];
    
    [StringUitl setViewBorder:self.contentBackView withColor:@"#cccccc" Width:0.5f];
    UIView *footerView = [[UIView alloc]init];
    _commentTable.tableFooterView = footerView;
    //评论
    [self initTable];
    [self initToolBar];
    //获取评论列表
    pageIndex = 1;
    flag = 1;
    //tableArray = [self getCommentList];
    [self loadHeadData];
    [self getCommentList];
    
    [self setHeaderRereshing];
    [self setFooterRereshing];
}

-(void)loadHeadData{
    NSString *requestUrl = [[NSString alloc] initWithFormat:@"%@/cms/GetArticle/%@",REMOTE_URL,detailId];
    [self requestDataByUrl:requestUrl withType:1];
}

-(void)getCommentList{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@/%@/10/%d",REMOTE_URL,GET_COMMENT_URL,detailId,pageIndex];
    //return (NSMutableArray *)[ConvertJSONData requestData:url];
    [self requestDataByUrl:url withType:0];
}

-(void)requestDataByUrl:(NSString *)url withType:(int)type{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(type==0){
             NSArray *nextArray = (NSArray *)responseObject;
             if(nextArray!=nil && nextArray.count>0){
                 if (flag==1) {
                     tableArray  =[NSMutableArray arrayWithArray:nextArray];
                 } else {
                     [tableArray  addObjectsFromArray:nextArray];
                 }
                 
                 [self hideHud];
                 [_commentTable reloadData];
             }else{
                 
                 [self hideHud];
                 [self showNo:@"没有数据了"];
             }
             
         }else{
             
             dicContent = (NSDictionary *)responseObject;
             _commentTitle.text = [dicContent valueForKey:@"_title"];
             
             NSString *addTime = [dicContent valueForKey:@"_add_time"];
             DateUtil *utilDate = [[DateUtil alloc] init];
             addTime = [utilDate getLocalDateFormateUTCDate1:addTime];
             _commentDate.text = addTime;
             
             NSString *clickNum = [self getCommentNum];
             _commentNum.text = [[NSString alloc] initWithFormat:@"%@",clickNum];
             _commentNum.font = main_font(12);
             
             [self hideHud];
             [_commentTable reloadData];
             
         }
         
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissKeyBoard];
}

-(void)initTable{
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"StoryCommentTableCell" bundle:nil];
    [_commentTable registerNib:nibCell forCellReuseIdentifier:@"storyCommentCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryCommentTableCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"storyCommentCell"];
    NSDictionary *dicComment = [tableArray  objectAtIndex:indexPath.row];
    DateUtil *utilDate = [[DateUtil alloc] init];
    NSString *addTime = [utilDate getLocalDateFormateUTCDate1:[dicComment valueForKey:@"_add_time"]];
    commentCell.commentDateTime.text = addTime;
    NSString *imgUrl = [dicComment valueForKey:@"_avatar"];
    [commentCell.commentImage md_setImageWithURL:imgUrl placeholderImage:CG_IMG(NOIMG_ICON_PL) options:SDWebImageRefreshCached];
    
    NSString *commnetContent = [dicComment valueForKey:@"_content"];
    
    commentCell.commentTextView.text = commnetContent;
    if([StringUitl isEmpty:[dicComment valueForKey:@"_nick_name"]]){
       commentCell.commentUsername.text =BLANK_NICK_NAME;
    }else{
        commentCell.commentUsername.text = [dicComment valueForKey:@"_nick_name"];
    }
    
    commentCell.commentUsername.font = main_font(13);
    commentCell.commentTextView.font = main_font(12);
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //处理回复按钮
    NSString *isReply = [[dicComment valueForKey:@"_is_reply"] stringValue];
    NSLog(@"_is_reply=%@",isReply);
    
    if(![isReply isEqualToString:@"0"]){
        [commentCell.replyBtn setTitle:@"" forState:UIControlStateNormal];
        [commentCell.replyBtn setTitle:@"" forState:UIControlStateSelected];
    }else{
        [commentCell.replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [commentCell.replyBtn setTitle:@"回复" forState:UIControlStateSelected];
    }
    
    //给回复按钮添加事件
    commentCell.replyBtn.tag = indexPath.row;
    [commentCell.replyBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchDown];
    
    return commentCell;
}

-(void)changeText:(UIButton *)sender{
    [textField becomeFirstResponder];
    
    [plabel removeFromSuperview];
    [cIconView removeFromSuperview];
    
    NSDictionary *clickDic = [tableArray objectAtIndex:sender.tag];
    NSString *changTxt = [NSString stringWithFormat:@"回复 %@ ：",[clickDic valueForKey:@"_nick_name"]];
    commentId = [clickDic valueForKey:@"_id"];
    [textField setText:changTxt];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray .count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryCommentTableCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"storyCommentCell"];
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
    [plabel removeFromSuperview];
    NSDictionary *dicComment = [tableArray objectAtIndex:indexPath.row];
    NSString *_is_reply = [[dicComment valueForKey:@"_is_reply"] stringValue];
    if(![_is_reply isEqual:@"1"]){
        [textField becomeFirstResponder];
        NSString *changTxt = [NSString stringWithFormat:@"回复 %@ ：",[dicComment valueForKey:@"_nick_name"]];
        [textField setText:changTxt];
        commentId = [[dicComment valueForKey:@"_id"] stringValue];
    }else{
        commentId = nil;
        [textField setText:@""];
        [textField becomeFirstResponder];
    }
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

    NSString *url = [NSString stringWithFormat:@"%@/Comment/GetCommentTotal/%@",REMOTE_URL,detailId];
    NSDictionary *commentDic = (NSDictionary *)[ConvertJSONData requestData:url];
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

    NSString *contentId;
    NSString *textVal = textField.text;
    //处理换行符号
    textVal = [textVal stringByTrimmingBlank];
    NSLog(@"处理换行=%@",textVal);
    if([self isEmpty:textVal]){
        textField.text = nil;
        [self dismissKeyBoard];
        [self showNo:@"请输入评论信息后提交"];
    }else{
        
        NSString *hf = [textVal substringToIndex:2];
        if([hf isEqualToString:@"回复"]){
            NSArray *charArr = [textVal componentsSeparatedByString:@"："];
            if(charArr.count==1 ||[charArr[1] isEqualToString:@""]){
                textField.text = nil;
                [self dismissKeyBoard];
                [self showNo:@"请输入评论信息后提交"];
                return;
            }
        }else{
            commentId = nil;
        }
        
        [self dismissKeyBoard];
        [self showLoading:@"数据保存中..."];
        
        //提交评论
        NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
        if ([self isEmpty:userId]) {
            LoginViewController *login = (LoginViewController *)[self getVCFromSB:@"userLogin"];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        NSString *userName = [StringUitl getSessionVal:LOGIN_USER_NAME];
        if(commentId!=nil){
            contentId = commentId;
        }else{
            contentId = @"0";
        }
        
        NSString *curl = [[NSString alloc] initWithFormat:@"%@%@",REMOTE_URL,ADD_COMMENT_URL];
        NSDictionary *parameters = @{@"id":contentId,@"username":userName,
                                     @"articleId":detailId,@"txtContent":textVal,@"userid":userId};
        [HttpClient POST:curl
              parameters:parameters
                  isjson:TRUE
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *jsonDic = (NSDictionary *)responseObject;
             //处理返回
             if([[jsonDic valueForKey:@"result"] isEqualToString:@"ok"]){
                 textField.text = nil;
                 [self dismissKeyBoard];
                 [self hideHud];
                 [textField addSubview:cIconView];
                 [plabel setFrame:CGRectMake(25, 2, 40, 26)];
                 [textField addSubview:plabel];
                 
                 [self showOk:@"评论提交成功"];
                 pageIndex = 1;
                 flag = 1;
                 [self getCommentList];
                 
                 NSString *clickNum = [self getCommentNum];
                 _commentNum.text = [[NSString alloc] initWithFormat:@"%@",clickNum];
             }else{
                 [self hideHud];
                 [self showNo:[jsonDic valueForKey:@"result"]];
             }
             
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self requestFailed:error];
             
         }];
        
        
        
    }
}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:SHARE_ICON]];
}

-(void)goForward{
    NSString *shareContent;
    NSString *type = [params valueForKey:@"stype"];
    if([type isEqualToString:@"wz"]){
       shareContent = [NSString stringWithFormat:@"%@ %@%@",[dicContent valueForKey:@"_title"],SHARE_AT,detailId];
    }else if([type isEqualToString:@"xc"]){
        shareContent = [NSString stringWithFormat:@"%@ %@%@",[dicContent valueForKey:@"_title"],SHARE_XC,detailId];
    }else{
        shareContent = [NSString stringWithFormat:@"%@ %@%@",[dicContent valueForKey:@"_title"],SHARE_SP,detailId];
    }
    NSMutableDictionary * showMsg = [[NSMutableDictionary alloc]init];
    [showMsg setObject:@"分享内容" forKey:@"showTitle"];
    [showMsg setObject:shareContent forKey:@"contentString"];
    [showMsg setObject:@"很无敌啊！" forKey:@"description"];
    [showMsg setObject:@"这个是默内容！" forKey:@"defaultContent"];
    
    [self showShareAlert:showMsg];
    
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
    AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:_commentTable position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        pageIndex = 1;
        flag = 1;
        [self performSelector:@selector(callBackMethod:) withObject:@"top" afterDelay:DELAY_TIME];
        [view performSelector:@selector(finishedLoading) withObject:@"top" afterDelay:1.0f];
    }];
    [_commentTable addSubview:topPullView];
}

//加底部部刷新
-(void)setFooterRereshing{
    AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:_commentTable position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
        pageIndex++;
        flag = 2;
        [self performSelector:@selector(callBackMethod:) withObject:@"foot" afterDelay:DELAY_TIME];
        [view performSelector:@selector(finishedLoading) withObject:@"foot" afterDelay:1.0f];
    }];
    [_commentTable addSubview:bottomPullView];
}

//请求完成之后，回调方法
-(void)callBackMethod:(id)isTop
{
    [self getCommentList];
//    NSMutableArray *nextArray = [self getCommentList];
//    if(nextArray!=nil && nextArray.count>0){
//        if ([isTop isEqualToString:@"top"]) {
//            tableArray  = nextArray;
//        } else {
//            [tableArray  addObjectsFromArray:nextArray];
//        }
//        [_commentTable reloadData];
//    }else{
//        [self showNo:@"没有数据了"];
//    }
}

@end
