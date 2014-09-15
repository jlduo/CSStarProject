//
//  CommentListViewController.m
//  CSStarProject

//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommentListViewController.h"

@interface CommentListViewController (){
    
    NSString *dataId;
    NSDictionary *cellDic;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
    
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    UITableView *commentTableView;
}

@end

@implementation CommentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H);
    
    commentTableView = [[UITableView alloc] initWithFrame:tframe];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    
    //[commentTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con_bg@2x.jpg"]]];
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [commentTableView setTableFooterView:view];
    commentTableView.showsVerticalScrollIndicator = YES;
    
    //处理数据
    [self initHeaderData];
    [self loadCommentData];
    
    [self initHeadView];
    [self.view addSubview:commentTableView];
    
    [self initToolBar];
    
    
}

-(void)initHeadView{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    [headView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"con_bg@2x.jpg"]]];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 30)];
    [titleLabel setText:[headerData valueForKey:@"_title"]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:Font_Size(17)];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 125, 25)];
    DateUtil *dateUtil = [[DateUtil alloc]init];
    NSString *locDate = [dateUtil getLocalDateFormateUTCDate1:[headerData valueForKey:@"_add_time"]];
    
    [timeLabel setText:locDate];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setTextColor:[UIColor darkGrayColor]];
    [timeLabel setFont:Font_Size(12)];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(156, 35, SCREEN_WIDTH, 25)];
    NSInteger clickNum = [self getCommentNum:dataId];
    [numLabel setText:[NSString stringWithFormat:@"%d评论",clickNum]];
    [numLabel setTextAlignment:NSTextAlignmentLeft];
    [numLabel setTextColor:[UIColor darkGrayColor]];
    [numLabel setFont:Font_Size(12)];
    
    UIImageView *comImage =[[UIImageView alloc]initWithFrame:CGRectMake(135, 40, 16, 16)];
    [comImage setImage:[UIImage imageNamed:@"discussicon.png"]];
    
    [headView addSubview:titleLabel];
    [headView addSubview:timeLabel];
    [headView addSubview:comImage];
    [headView addSubview:numLabel];
    
    commentTableView.tableHeaderView =headView;
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:commentTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            NSLog(@"up-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [commentTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:commentTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            NSLog(@"down-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [commentTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    
    [commentTableView reloadData];
}


//初始化头部数据
-(void)initHeaderData{
    if([self isNotEmpty:dataId]){
        ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
        NSString *url = [NSString stringWithFormat:@"http://192.168.1.210:8888/cms/GetArticle/%@",dataId];
        headerData = (NSMutableDictionary *)[convertJson requestData:url];
        NSLog(@"headerData===%@",headerData);
    }
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)loadCommentData{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%s/Comment/GetArticleComments/%@/10",REMOTE_URL,dataId];
    NSArray *commArr = (NSArray *)[convertJson requestData:url];
    if(commArr!=nil && commArr.count>0){
        commentArray = [NSMutableArray arrayWithArray:commArr];
    }
    NSLog(@"commentArray====%@",commentArray);
    
}

//获取评论条数
-(NSInteger)getCommentNum:(NSString *)articleId{
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"/Comment/GetCommentTotal/%@",articleId];
    NSMutableDictionary *commentDic = (NSMutableDictionary *)[convertJson requestData:url];
    NSInteger comments = (NSUInteger)[commentDic valueForKey:@"result"];
    NSLog(@"评论条数＝＝%d",comments);
    return comments;
}

-(void)goPreviou{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)goForward{
    
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"美女私房" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:@"btnshare.png"]];
}


//初始化底部工具栏
-(void)initToolBar{
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, MAIN_FRAME_H-20, SCREEN_WIDTH, 40)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    
    [self initTextView];
    [self initCommentIcon];
    [self initCommentText];
    [self initNumButton];
    
    [self.view addSubview:toolBar];
    
    
}

-(void)initTextView{
    //加入输入框
    textField = [[UITextView alloc]initWithFrame:CGRectMake(6, 5, toolBar.frame.size.width-65, 30)];
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth =0.5;
    textField.layer.cornerRadius =5.0;
    //textField.delegate = self;
    //[textField setBackgroundColor:[UIColor whiteColor]];
    [toolBar addSubview:textField];
    
    
}

-(void)initCommentIcon{
    //在文本域内加入图标
    cIconView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 24, 22)];
    [cIconView setImage:[UIImage imageNamed:@"discussicon.png"]];
    
    [textField addSubview:cIconView];
}

-(void)initCommentText{
    
    //加入评论文字
    plabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 40, 26)];
    [plabel setText:@"评论"];
    [plabel setFont:Font_Size(12)];
    [plabel setTextAlignment:NSTextAlignmentCenter];
    [plabel setTextColor:[UIColor grayColor]];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [textField addSubview:plabel];
    
}

-(void) initNumButton{
    //加入按钮
    numBtn = [[UIButton alloc]initWithFrame:CGRectMake(textField.frame.size.width+12, 5, 45, 30)];
    [numBtn.layer setMasksToBounds:YES];
    [numBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [numBtn.layer setBorderWidth:0.5];   //边框宽度
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
    [numBtn.layer setBorderColor:colorref];
    [numBtn setBackgroundImage:[UIImage imageNamed:@"con_bg@2x.jpg"] forState:UIControlStateNormal];
    
    //给按钮默认显示评论数据
    [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //[bannerData valueForKey:@"_click"]
    NSInteger clickNum = [self getCommentNum:dataId];
    [numBtn setTitle:[NSString stringWithFormat:@"%d",clickNum] forState:UIControlStateNormal];
    [numBtn setTitle:[NSString stringWithFormat:@"%d",clickNum] forState:UIControlStateHighlighted];
    numBtn.titleLabel.font = Font_Size(14);
    
    //给按钮绑定事件
    [numBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [toolBar addSubview:numBtn];
}


//取消回车事件 改为关闭键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self dismissKeyBoard];
        return NO;
    }
    return YES;
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
        [numBtn setTitle:@"发 表" forState:UIControlStateNormal];
        [numBtn setTitle:@"发 表" forState:UIControlStateHighlighted];
        //[numBtn setFont:Font_Size(14)];//过时方法
        numBtn.titleLabel.font = Font_Size(14);
        
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
        NSInteger clickNum = [self getCommentNum:dataId];
        [numBtn setTitle:[NSString stringWithFormat:@"%d",clickNum] forState:UIControlStateNormal];
        [numBtn setTitle:[NSString stringWithFormat:@"%d",clickNum] forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = Font_Size(14);
        
        if([self isEmpty:textField.text]){
            [textField addSubview:cIconView];
            [plabel setFrame:CGRectMake(25, 0, 40, 26)];
            [textField addSubview:plabel];
        }
        
    }];
}


-(void)commentBtnClick{
    
    NSString *btnText = numBtn.titleLabel.text;
    NSString *textVal = textField.text;
    NSLog(@"textVal=%@",textVal);
    NSLog(@"btnText=%@",btnText);
    
    if([btnText isEqual:@"发 表"]){//点击发表提交数据
        NSLog(@"提交数据....");
        if([self isEmpty:textVal]){
            [self alertMsg:@"对不起,请输入评论信息后提交!" withtitle:@"［错误提示］"];
            
            
            
            
            
        }
        
    }else{//点击数字进入评论列表
        NSLog(@"进入评论列表....");
        NSLog(@"newDataId=%@",dataId);
        CommentListViewController *commentController = [[CommentListViewController alloc]init];
        passValelegate = commentController;
        [passValelegate passValue:dataId];
        
        [self presentViewController:commentController animated:YES completion:^{
            //
        }];
        
    }
    
    
}





#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}


#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UINib *nibCell = [UINib nibWithNibName:@"CommentTableListCell" bundle:nil];
    [tableView registerNib:nibCell forCellReuseIdentifier:@"CommentCell"];
    CommentTableListCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    cellDic = [commentArray objectAtIndex:indexPath.row];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //昵称
    commentCell.nickName.text = [cellDic valueForKey:@"_nick_name"];
    commentCell.nickName.textAlignment = NSTextAlignmentLeft;
    
    //地址时间
    commentCell.addressTime.text = [cellDic valueForKey:@"_address"];
    commentCell.addressTime.textAlignment = NSTextAlignmentLeft;
    
    //评论内容
    commentCell.commenInfo.text = [cellDic valueForKey:@"_content"];
    
    
    
    //用户头像
    NSString *imgUrl =[cellDic valueForKey:@"_avatar"];
    NSRange range = [imgUrl rangeOfString:@"/upload/"];
    if(range.location!=NSNotFound){//判断加载远程图像
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        if(imgData!=nil){
          UIImage *userImg =[UIImage imageWithData:imgData];
          [commentCell.userImageView setImage:userImg];
        }else{
            [commentCell.userImageView setImage:[UIImage imageNamed:@"avatarbig.png"]];
        }
    }else{
        [commentCell.userImageView setImage:[UIImage imageNamed:@"avatarbig.png"]];
    }
    //commentCell.userImageView.frame = CGRectMake(10,5,40,40);
    commentCell.userImageView.layer.masksToBounds =YES;
    commentCell.userImageView.layer.cornerRadius =25;
    
    return commentCell;
}







@end
