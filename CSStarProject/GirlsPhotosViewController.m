//
//  GirlsPhotosViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "GirlsPhotosViewController.h"

@interface GirlsPhotosViewController ()

@end

@implementation GirlsPhotosViewController{
    
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
    NSString *articelId;
    UIScrollView *scrollPicView;
    
    UILabel *descLabel;
    UITextView *descView;
    
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    
}

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
    [self setNavgationBar];
    [self loadGirlPhotoData:articelId];
    [self initScrollView];
    [self initPhotoTitle];
    [self initToolBar];
    
    [self showCustomTips:@"点击全屏浏览"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-40-44);
    [scrollPicView setFrame:temFrame];
    
}

-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    
    
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [titleLabel setText:@"美女私房"];
    [titleLabel setTextColor:[StringUitl colorWithHexString:@"#0099FF"]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    titleLabel.font = BANNER_FONT;
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    //    //设置右侧按钮
    //    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [rbtn setFrame:CGRectMake(0, 0, 45, 45)];
    //    [rbtn setTitle:@"保 存" forState:UIControlStateNormal];
    //    [rbtn setTitle:@"保 存" forState:UIControlStateHighlighted];
    //    [rbtn setTintColor:[UIColor whiteColor]];
    //    [rbtn setFont:Font_Size(18)];
    //
    //    //[rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    //    [rbtn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    //navItem.rightBarButtonItem = rightBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}

//传值
-(void)passValue:(NSString *)val{
    
    NSLog(@"ssarticleId==%@",val);
    articelId = val;
}

-(void)showCustomTips:(NSString *)msg{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand@2x.png"]];
    //[imgView setFrame:CGRectMake(0, 0, 120, 120)];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
	
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
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
	
    [self dismissKeyBoard];
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

-(void)loadGirlPhotoData:(NSString *)articleId {
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
    
    imageArr = [[NSMutableArray alloc]init];
    titleArr = [[NSMutableArray alloc]init];
    for (int i=0; i<newDataArr.count; i++) {
        NSDictionary * dic = (NSDictionary *)newDataArr[i];
        [titleArr addObject:[dic valueForKey:@"_remark"]];
        [imageArr addObject:[dic valueForKey:@"_original_path"]];
    }
    NSLog(@"imageArr===%@",imageArr);
}

-(void)initScrollView{
    
    scrollPicView = [[UIScrollView alloc]init];
    [scrollPicView setFrame:CGRectMake(0, 69,SCREEN_WIDTH, MAIN_FRAME_H)];
    [scrollPicView setContentSize:CGSizeMake((imageArr.count)*320, 80)];
    scrollPicView.pagingEnabled = YES;
    scrollPicView.delegate = self;
    scrollPicView.backgroundColor = [UIColor blackColor];
    //加载数据
    UIImageView *imageView;
    for (int i=0; i<imageArr.count; i++) {
        
        NSString *imgUrl =[imageArr objectAtIndex:i];
        NSLog(@"imgurl==%@",imgUrl);
        NSRange range = [imgUrl rangeOfString:@"/upload/"];
        if(range.location!=NSNotFound){//判断加载远程图像
            if(IPHONE5){
               imageView = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 5, SCREEN_WIDTH, 380)];
            }else{
               imageView = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 5, SCREEN_WIDTH, 290)];
            }
            [imageView setImageWithURL:[NSURL URLWithString:imgUrl]
                      placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [UIColor blackColor];
            
            [imageView setMultipleTouchEnabled:YES];
            [imageView setUserInteractionEnabled:YES];
            
            imageView.tag = i;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)] ];
            [scrollPicView addSubview:imageView];
        }
    }
    [self.view addSubview:scrollPicView];
}


- (void)tapImage:(UITapGestureRecognizer *)tap
{
    [self dismissKeyBoard];
    //显示相册
    NSInteger count = imageArr.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:imageArr[i]]; // 图片路径
        photo.srcImageView = scrollPicView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片
    browser.photos = photos; // 设置所有的图片
    
    [browser show];
}

-(void)initPhotoTitle2{
    
    //1.实例化UILabel，其frame设置为CGRectZero，后面会重新设置该值。
    descLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    //2.将UILabel设置为自动换行
    [descLabel setNumberOfLines:0];
    [descLabel setAlpha:0.9f];
    //3.具体要自适应处理的字符串实例
    NSString *s = [titleArr objectAtIndex:0];
    descLabel.text = [NSString stringWithFormat:@"%d/%d  %@",1,imageArr.count,s];
    //4.获取所要使用的字体实例
    UIFont *font = main_font(14);
    descLabel.font = font;
    descLabel.textColor = [UIColor whiteColor];
    //5.UILabel字符显示的最大大小
    CGSize size = CGSizeMake(SCREEN_WIDTH,150);
    //6.计算UILabel字符显示的实际大小
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size];
    //7.重设UILabel实例的frame
    if(IPHONE5){
        [descLabel setFrame:CGRectMake(0,380+68, SCREEN_WIDTH, labelsize.height+20)];
    }else{
        [descLabel setFrame:CGRectMake(0,290+68, SCREEN_WIDTH, labelsize.height+20)];
    }
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //8.将UILabel实例作为子视图添加到父视图中，这里的父视图是self.view
    [self.view addSubview:descLabel];
    
}

-(void)initPhotoTitle{
    descView = [[UITextView alloc]init];
    descView.backgroundColor = [UIColor clearColor];
    NSString *s = [titleArr objectAtIndex:0];
    descView.text = [NSString stringWithFormat:@"%d/%d  %@",1,imageArr.count,s];
    UIFont *font = main_font(14);
    descView.font = font;
    descView.textColor = [UIColor whiteColor];
    descView.editable = NO;

    if(IPHONE5){
        [descView setFrame:CGRectMake(0,380+68, SCREEN_WIDTH, 80)];
    }else{
        [descView setFrame:CGRectMake(0,290+68, SCREEN_WIDTH, 80)];
    }
    [self.view addSubview:descView];
    
}

-(void)scrollViewDidScroll2:(UIScrollView *)scrollView{

    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSString *s = [titleArr objectAtIndex:page];
    descLabel.text = [NSString stringWithFormat:@"%d/%d  %@",page+1,imageArr.count,s];
    CGSize size = CGSizeMake(SCREEN_WIDTH,150);
    
    UIFont *font = main_font(14);
    descLabel.font = font;
    descLabel.textColor = [UIColor whiteColor];
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size];
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if(IPHONE5){
        [descView setFrame:CGRectMake(0,380+68, SCREEN_WIDTH, labelsize.height+20)];
    }else{
        [descView setFrame:CGRectMake(0,290+68, SCREEN_WIDTH, labelsize.height+20)];
    }
    //NSLog(@"%d", page);
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSString *s = [titleArr objectAtIndex:page];
    descView.text = [NSString stringWithFormat:@"%d/%d  %@",page+1,imageArr.count,s];
    descView.editable = NO;
    UIFont *font = main_font(14);
    descView.font = font;
    descView.textColor = [UIColor whiteColor];
    descView.backgroundColor = [UIColor clearColor];
    
    if(IPHONE5){
        [descView setFrame:CGRectMake(0,380+68, SCREEN_WIDTH, 80)];
    }else{
        [descView setFrame:CGRectMake(0,290+68, SCREEN_WIDTH, 80)];
    }
    
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
    plabel.font = main_font(14);
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
    NSString *clickNum = [self getCommentNum:articelId];
    [numBtn setTitle:clickNum forState:UIControlStateNormal];
    [numBtn setTitle:clickNum forState:UIControlStateHighlighted];
    numBtn.titleLabel.font = main_font(14);
    
    //给按钮绑定事件
    [numBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [toolBar addSubview:numBtn];
}

//获取评论条数
-(NSString *)getCommentNum:(NSString *)articleId{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,COMMENT_COUNT_URL,articleId];
    NSMutableDictionary *commentDic = (NSMutableDictionary *)[convertJson requestData:url];
    NSString *comments = [commentDic valueForKey:@"result"];
    NSLog(@"评论条数＝＝%@",comments);
    
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
    if([StringUitl isNotEmpty:textVal]){
        [plabel removeFromSuperview];
        textView.text = textVal;
    }
    
}

//关闭键盘
-(void) dismissKeyBoard{
    [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyBoard];
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
        numBtn.titleLabel.font = main_font(14);
        
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
        NSString *clickNum = [self getCommentNum:articelId];
        [numBtn setTitle:clickNum forState:UIControlStateNormal];
        [numBtn setTitle:clickNum forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = main_font(14);
        
        if([StringUitl isEmpty:textField.text]){
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
        if([StringUitl isEmpty:textVal]){
            //[StringUitl alertMsg:@"对不起,请输入评论信息后提交!" withtitle:@"［错误提示］"];
            [self showCustomAlert:@"请输入评论信息后提交" widthType:WARNN_LOGO];
        }else{
            //提交数据
            [self postCommetnVal:articelId];
        }
        
    }else{//点击数字进入评论列表
        NSLog(@"进入评论列表....");
        NSLog(@"newDataId=%@",articelId);
        StoryCommentViewController *commentController = [[StoryCommentViewController alloc]init];
        passValelegate = commentController;
        [passValelegate passValue:articelId];
        
        [self presentViewController:commentController animated:YES completion:^{
            //code
        }];
    }
}

//提价评论信息
-(void)postCommetnVal:(NSString *)artlId{
    
    NSURL *comment_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,ADD_COMMENT_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:comment_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:artlId forKey:@"articleId"];
    [request setPostValue:textField.text forKey:@"txtContent"];
    [request setPostValue:[StringUitl getSessionVal:LOGIN_USER_ID] forKey:USER_ID];
    [request setPostValue:[StringUitl getSessionVal:LOGIN_USER_NAME] forKey:USER_NAME];
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(addCommentFailed:)];
    [request setDidFinishSelector:@selector(addCommentFinished:)];
    
}

- (void)addCommentFinished:(ASIHTTPRequest *)req
{
    NSLog(@"comment info->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"result"] isEqualToString:@"ok"]){//失败
        [self showCustomAlert:@"提交评论信息成功！" widthType:SUCCESS_LOGO];
        [textField setText:nil];
        [self dismissKeyBoard];
    }
    if(![[jsonDic valueForKey:@"result"] isEqualToString:@"ok"]){//成功
        [self showCustomAlert:[jsonDic valueForKey:@"result"] widthType:ERROR_LOGO];
        
    }
    
}

- (void)addCommentFailed:(ASIHTTPRequest *)req
{
    //[StringUitl alertMsg:@"提交数据失败！" withtitle:@"错误提示"];
    [self showCustomAlert:@"提交数据失败！" widthType:ERROR_LOGO];
}


-(void)goPreviou{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
