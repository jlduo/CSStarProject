//
//  StoryDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "InitTabBarViewController.h"

@interface StoryDetailViewController (){
    NSString *detailId;
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    BOOL isOpen;
}
@end

@implementation StoryDetailViewController

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
    
    //添加WebView
    UIWebView *webDetail = [[UIWebView alloc] init];
    webDetail.frame = CGRectMake(0, STATU_BAR_HEIGHT + NAV_TITLE_HEIGHT + 70, SCREEN_WIDTH, MAIN_FRAME_H - 150);
    [self.view addSubview:webDetail];

    //标题
    UILabel *lblDetail=[[UILabel alloc] init];
    lblDetail.font = [UIFont fontWithName:@"Helvetica" size:24];
    lblDetail.frame = CGRectMake(5, 69, SCREEN_WIDTH - 5, 35);
    [self.view addSubview:lblDetail];
    
    //时间
    UILabel *lblTimeDetail = [[UILabel alloc] init];
    lblTimeDetail.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblTimeDetail.textColor = [UIColor grayColor];
    lblTimeDetail.frame = CGRectMake(5, 104, 65, 30);
    [self.view addSubview:lblTimeDetail];
    
    //分割线
    UIImageView *imgHomeDetailOne=[[UIImageView alloc] init];
    imgHomeDetailOne.frame = CGRectMake(75, 111, 1, 14);
    imgHomeDetailOne.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    [self.view addSubview:imgHomeDetailOne];
    
    //栏目名称
    UILabel *lblCategoryDetail = [[UILabel alloc] init];
    lblCategoryDetail.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblCategoryDetail.textColor = [UIColor grayColor];
    lblCategoryDetail.frame = CGRectMake(85, 104, 50, 30);
    lblCategoryDetail.text =@"星城故事";
    [self.view addSubview:lblCategoryDetail];
    
    //分割线
    UIImageView *imgHomeDetailTwo=[[UIImageView alloc] init];
    imgHomeDetailTwo.frame = CGRectMake(145, 111, 1, 14);
    imgHomeDetailTwo.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    [self.view addSubview:imgHomeDetailTwo];
    
    //点击图标
    UIImageView *imgCategoryDetail=[[UIImageView alloc] init];
    imgCategoryDetail.frame = CGRectMake(155, 112, 16, 14);
    imgCategoryDetail.image = [UIImage imageNamed:@"heartgray.png"];
    [self.view addSubview:imgCategoryDetail];
    
    //点击量
    UILabel *lblNumberDetail = [[UILabel alloc] init];
    lblNumberDetail.font = [UIFont fontWithName:@"Helvetica" size:12];
    lblNumberDetail.textColor = [UIColor grayColor];
    lblNumberDetail.frame = CGRectMake(175, 104, 100, 30);
    [self.view addSubview:lblNumberDetail];
    
    
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    NSString *requestUrl = [[NSString alloc] initWithFormat:@"%@/cms/GetArticle/%@",REMOTE_URL,detailId];
    NSDictionary *dicContent = (NSDictionary *)[jsonData requestData:requestUrl];
    lblDetail.text = [dicContent valueForKey:@"_title"];
    lblTimeDetail.text = [[dicContent valueForKey:@"_add_time"] substringToIndex:10];
    NSString *call_index = [[NSString alloc] initWithFormat:@"%@",[dicContent valueForKey:@"_call_index"]];
    if (call_index.length > 0) {
            lblCategoryDetail.text = call_index;
    }
    NSString *click = [[NSString alloc] initWithFormat:@"%@",[dicContent valueForKey:@"_click"]];
    lblNumberDetail.text = click;
    
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/newsConte.aspx?newsid=%@",REMOTE_ADMIN_URL,detailId];
    NSURL *nsUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsUrl];
    [webDetail loadRequest:request];
    
    //评论
    [self initToolBar];
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
    textField.delegate = self;
    [toolBar addSubview:textField];
}

-(void)initCommentIcon{
    //在文本域内加入图标
    cIconView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 24, 22)]; 
    cIconView.image = [UIImage imageNamed:@"iconchecked.png"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    
    NSString *clickNum = [self getCommentNum];
    [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateNormal];
    [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateHighlighted];
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
        numBtn.titleLabel.font = Font_Size(14);
        
        [cIconView removeFromSuperview];
        [plabel setFrame:CGRectMake(0, plabel.frame.origin.y, plabel.frame.size.width, plabel.frame.size.height)];
    }];
    
    isOpen = YES;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.3 animations:^{
        [textField setFrame:CGRectMake(6, 5, toolBar.frame.size.width-65, 30)];
        [toolBar setFrame:CGRectMake(0, MAIN_FRAME_H-20, SCREEN_WIDTH, 40)];
        [numBtn setFrame:CGRectMake(textField.frame.size.width+12, 5, 45, 30)];
        NSString *clickNum = [self getCommentNum];
        [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateNormal];
        [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = Font_Size(14);
        
        if([self isEmpty:textField.text]){
            [textField addSubview:cIconView];
            [plabel setFrame:CGRectMake(25, 0, 40, 26)];
            [textField addSubview:plabel];
        }
    }];
    
    isOpen = NO;
}


-(void)commentBtnClick{
    NSString *textVal = textField.text;
    
    //点击发表提交数据
    if(isOpen){
        if([self isEmpty:textVal]){
            [self alertMsg:@"对不起,请输入评论信息后提交!" withtitle:@"［错误提示］"];
        }else{
            //Comment/AddComment/{articleId}/{txtContent}/{userid}/{username}
            //提交评论
        } 
    }else{
        //打开评论视图
    }
}

-(void)passValue:(NSString *)val{
    detailId = val; 
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:nil]];
}
-(void)goPreviou{
    [super goPreviou];
}
@end
