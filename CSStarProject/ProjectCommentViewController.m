//
//  ProjectCommentViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-14.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ProjectCommentViewController.h"

@interface ProjectCommentViewController (){
    
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    NSDictionary *cellDic;
    NSString *dataId;
    NSDictionary *params;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
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
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    [self initHeadView];
    [self initLoadData];
    [self initToolBar];
    [self loadTableList];
    
    //集成刷新控件
    [self setHeaderRereshing];
    [StringUitl setViewBorder:self.commentBackView withColor:@"#cccccc" Width:0.5f];
    
    UIView *footerView = [[UIView alloc]init];
    _projectCommentTable.tableFooterView = footerView;
}

-(void)initHeadView{
    
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *ntime =[params valueForKey:@"addTime"];
    if([ntime length]>19){
        ntime = [ntime substringToIndex:19];
    }
    NSString *stime = [dateUtil getLocalDateFormateUTCDate1:ntime];
    self.commentDate.text = stime;
    self.comentTitle.text = [params valueForKey:@"projectName"];
    self.commentNum.text = [[NSString alloc] initWithFormat:@"%@",[params valueForKey:@"talksNum"]];
    
}

-(void)initLoadData{
    _projectCommentTable.rowHeight = 72;
    _projectCommentTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    //commentListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _projectCommentTable.showsVerticalScrollIndicator = NO;
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:_projectCommentTable position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:@"new" afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:@"old" afterDelay:1.0f];
        }];
        [_projectCommentTable addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:_projectCommentTable position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [_projectCommentTable addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    [self loadTableList];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissKeyBoard];
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
    
    [StringUitl setCornerRadius:numBtn withRadius:5.0];
    [StringUitl setViewBorder:numBtn withColor:@"#cccccc" Width:0.5];
    
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
        
        NSDictionary *parameters = @{contentKey:contentId,@"content":textVal,@"userId":userId};
        [HttpClient POST:url
              parameters:parameters
                  isjson:FALSE
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary *jsonDic = [StringUitl getDicFromData:responseObject];
             //处理返回
             if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){
                 textField.text = nil;
                 [textField addSubview:cIconView];
                 [plabel setFrame:CGRectMake(25, 2, 40, 26)];
                 [textField addSubview:plabel];
                 [self hideHud];
                 [self showOk:[jsonDic valueForKey:@"info"]];
                 [self loadTableList];
                 [_projectCommentTable reloadData];
                 
                 self.commentNum.text = [[NSString alloc] initWithFormat:@"%d",_proCommentList.count];
             }else{
                 [self hideHud];
                 [self showNo:[jsonDic valueForKey:@"info"]];
             }
             
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
             [self requestFailed:error];
             
         }];
    }
}

- (void)requestFailed:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    //[self showNo:ERROR_INNER];
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

    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PROJECT_TALKS_URL,dataId];
    [self requestDataByUrl:url];
    
}

-(void)requestDataByUrl:(NSString *)url{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         NSMutableArray *jsonArr = (NSMutableArray *)responseObject;
         if(jsonArr!=nil&&jsonArr.count>0){
             _proCommentList = jsonArr;
             [self hideHud];
             [_projectCommentTable reloadData];
         }else{
             [self hideHud];
             [self showHint:@"没有最新数据..."];
         }
         [self setFooterRereshing];
         
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self requestFailed:error];
         
     }];
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:nil]];
    
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
    [plabel removeFromSuperview];
    cellDic = [self.proCommentList objectAtIndex:indexPath.row];
    NSString *huifuName = [cellDic valueForKey:@"huifuName"];
    if([huifuName isEqual:[NSNull null]]){
        [textField becomeFirstResponder];
        NSString *changTxt = [NSString stringWithFormat:@"回复 %@ ：",[cellDic valueForKey:@"creatName"]];
        [textField setText:changTxt];
        commentId = [cellDic valueForKey:@"id"];
    }else{
        commentId = nil;
        [textField setText:@""];
        [textField becomeFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        projectCommCell.selectionStyle =UITableViewCellSelectionStyleBlue;
        projectCommCell.backgroundColor = [UIColor whiteColor];

        NSString *creatName = [cellDic valueForKey:@"creatName"];
        NSString *huifuName = [cellDic valueForKey:@"huifuName"];
        NSString *content = [cellDic valueForKey:@"content"];

        if(![huifuName isEqual:[NSNull null]]){
            [projectCommCell.replyBtn setTitle:@"" forState:UIControlStateNormal];
            [projectCommCell.replyBtn setTitle:@"" forState:UIControlStateSelected];
        }else{
            [projectCommCell.replyBtn setTitle:@"回复" forState:UIControlStateNormal];
            [projectCommCell.replyBtn setTitle:@"回复" forState:UIControlStateSelected];
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
        
        [StringUitl setCornerRadius:projectCommCell.userIconView withRadius:20.0];
        NSString *imgUrl =[cellDic valueForKey:@"avatar"];
        if(![imgUrl isEqual:[NSNull null]]){
            //改写异步加载图片
            [projectCommCell.userIconView md_setImageWithURL:imgUrl placeholderImage:NO_IMG options:SDWebImageRefreshCached];
        }
        //给回复按钮添加事件
         projectCommCell.replyBtn.tag = indexPath.row;
        [projectCommCell.replyBtn addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventTouchDown];
        
    }
    return projectCommCell;
}



@end
