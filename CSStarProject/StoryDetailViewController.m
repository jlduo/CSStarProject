//
//  StoryDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "StoryDetailViewController.h"

@interface StoryDetailViewController (){
    NSString *detailId;
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    UILabel *lblNumberDetail;
    UIImageView *imgCategoryDetail;
    UITapGestureRecognizer *singleTap;
    BOOL isOpen;
    NSDictionary *dicContent;
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
    [self loadData];
    
    //添加手势
    UITapGestureRecognizer *singleTapWeb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_detailContentView addGestureRecognizer:singleTapWeb];
    singleTapWeb.delegate= self;
    singleTapWeb.cancelsTouchesInView = NO;
    //加载网页数据
    NSString *url = [[NSString alloc] initWithFormat:@"%@/newsConte.aspx?newsid=%@",REMOTE_ADMIN_URL,detailId];
    NSURL *nsUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsUrl];
    _detailContentView.opaque = NO;
    _detailContentView.scalesPageToFit = YES;
    [_detailContentView setBackgroundColor:[StringUitl colorWithHexString:CONTENT_BACKGROUND]];
    [_detailContentView loadRequest:request];
    
    _likeImgView.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setClick)];
    [_likeImgView addGestureRecognizer:singleTap];
    
    [StringUitl setViewBorder:_contentBackView withColor:@"cccccc" Width:0.5f];
    
    //评论
    [self initToolBar];
}

-(void)loadData{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/cms/GetArticle/%@",REMOTE_URL,detailId];
    NSURL *requestUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestDataFinished:)];
    
}
//请求完成
- (void)requestDataFinished:(ASIHTTPRequest *)req{

    NSData *respData = [req responseData];
    dicContent = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    //处理返回
    _contentTitle.text = [dicContent valueForKey:@"_title"];
    _contentDate.text = [[dicContent valueForKey:@"_add_time"] substringToIndex:10];
    NSString *call_index = [[NSString alloc] initWithFormat:@"%@",[dicContent valueForKey:@"_call_index"]];
    if (call_index.length > 0) {
        _columnTitle.text = call_index;
    }
    NSString *click = [[NSString alloc] initWithFormat:@"%@",[dicContent valueForKey:@"_click"]];
    _clickNum.text = click;

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoading:@"数据加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showHint:@"加载数据失败..."];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//点击事件
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self dismissKeyBoard];
    CGPoint point = [sender locationInView:_detailContentView];
    NSString  *_imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
    NSString *imgUrl = [_detailContentView stringByEvaluatingJavaScriptFromString:_imgURL];
    if (imgUrl.length > 0) {
        //展示所有图片
        NSString *imgArray = [_detailContentView stringByEvaluatingJavaScriptFromString:@"getImgs()"];
        if (imgArray.length > 0) {
            imgArray = [imgArray substringFromIndex:1];
            NSArray *photos = [imgArray componentsSeparatedByString:@"|"];
            NSMutableArray *imgPhotes=[[NSMutableArray alloc] init];
            NSInteger _currentPhoteoIndex = 0;
            MWPhoto *photo;
            for (int i = 0; i<photos.count; i++) {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:photos[i]]];
                //photo.caption = @"pic";
                [imgPhotes addObject:photo];
                
                imgArray = photos[i];
                if ([imgUrl isEqualToString:imgArray]) {
                    _currentPhoteoIndex = i;
                }
                
            }
            
            self.photos = imgPhotes;
            self.thumbs = imgPhotes;
            
            BOOL displayActionButton = YES;
            BOOL displaySelectionButtons = NO;
            BOOL displayNavArrows = YES;
            BOOL enableGrid = YES;
            BOOL startOnGrid = NO;
            
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
            browser.zoomPhotosToFill = YES;
            #if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            browser.wantsFullScreenLayout = YES;
            #endif
            browser.enableGrid = enableGrid;
            browser.startOnGrid = startOnGrid;
            browser.enableSwipeToDismiss = YES;
            [browser setCurrentPhotoIndex:_currentPhoteoIndex];
            

            //[self.navigationController pushViewController:browser animated:YES];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            
        }
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%d / %d", index+1,_photos.count];
}


//点赞按钮事件
-(void)setClick{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/cms/UpdateClick/%@/1",REMOTE_URL,detailId];
    NSURL *requestUrl = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    [request buildPostBody];
    
    [request startAsynchronous];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestLoginFinishedClick:)];
}

//请求完成
- (void)requestLoginFinishedClick:(ASIHTTPRequest *)req{
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    //处理返回
    if([[jsonDic valueForKey:@"result"] isEqualToString:@"ok"]){
        _clickNum.text = [jsonDic valueForKeyPath:@"value"];
        [_likeImgView removeGestureRecognizer:singleTap];
        //imgCategoryDetail.image = [UIImage imageNamed:@"heartred.png"];
        _likeImgView.image = [UIImage imageNamed:@"profile_btn_like@2x.png"];
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.5),@(1.0),@(1.5),@(2.0),@(2.5),@(3.0),@(3.5),@(4.0),@(4.5),@(5.0),@(5.5),@(6.0)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0),@(1.5),@(2.0),@(2.5),@(3.0),@(3.5),@(4.0),@(4.5),@(5.5)];
        k.calculationMode = kCAAnimationLinear;
        [_likeImgView.layer addAnimation:k forKey:@"SHOW"];
    }else{
        [self showCAlert:[jsonDic valueForKey:@"result"] widthType:WARNN_LOGO];
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
    plabel.font = main_font(12);
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
    numBtn.titleLabel.font = main_font(14);
    
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
        [numBtn setTitle:@"发 表" forState:UIControlStateNormal];
        numBtn.titleLabel.font = main_font(14);
        
        [cIconView removeFromSuperview];
        [plabel setFrame:CGRectMake(0, plabel.frame.origin.y, plabel.frame.size.width, plabel.frame.size.height)];
    }];
    
    isOpen = YES;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [UIView animateWithDuration:0.3 animations:^{
        if([self isEmpty:textField.text]){
            [textField setFrame:CGRectMake(6, 5, toolBar.frame.size.width-65, 30)];
            [toolBar setFrame:CGRectMake(0, MAIN_FRAME_H-20, SCREEN_WIDTH, 40)];
            [numBtn setFrame:CGRectMake(textField.frame.size.width+12, 5, 45, 30)];
            NSString *clickNum = [self getCommentNum];
            [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateNormal];
            [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateHighlighted];
            numBtn.titleLabel.font = main_font(14);
            
            [textField addSubview:cIconView];
            [plabel setFrame:CGRectMake(25, 2, 40, 26)];
            [textField addSubview:plabel];
            isOpen = NO;
        }else{
            [textField setFrame:CGRectMake(6, 5, toolBar.frame.size.width-65, 30)];
            [toolBar setFrame:CGRectMake(0, MAIN_FRAME_H-20, SCREEN_WIDTH, 40)];
            [numBtn setFrame:CGRectMake(textField.frame.size.width+12, 5, 45, 30)];
            isOpen = YES;
        }
    }];
}


-(void)commentBtnClick{
    NSString *textVal = textField.text;
    //点击发表提交数据
    if(isOpen){
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
            NSString *url = [[NSString alloc] initWithFormat:@"%@%@",REMOTE_URL,ADD_COMMENT_URL];
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
            [request setPostValue:@"0" forKey:@"id"];
            [request buildPostBody];
            
            [request startAsynchronous];
            [request setDidFailSelector:@selector(requestLoginFailed:)];
            [request setDidFinishSelector:@selector(requestLoginFinished:)];
        } 
    }else{
        StoryCommentViewController *storyComment  = (StoryCommentViewController *)[self getVCFromSB:@"storyComment"];
        _delegate = storyComment;
        [_delegate passValue:detailId];
        [self.navigationController pushViewController:storyComment animated:YES];
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
        
        NSString *clickNum = [self getCommentNum];
        [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateNormal];
        [numBtn setTitle:[NSString stringWithFormat:@"%@",clickNum] forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = Font_Size(14);
        
        [textField addSubview:cIconView];
        [plabel setFrame:CGRectMake(25, 2, 40, 26)];
        [textField addSubview:plabel];
        isOpen = NO;
        
        [self showCAlert:@"提交成功" widthType:SUCCESS_LOGO];
    }else{
        [self showCAlert:[jsonDic valueForKey:@"result"] widthType:ERROR_LOGO];
    }
}

- (void)requestLoginFailed:(ASIHTTPRequest *)req{
    [self showCAlert:@"请求数据失败" widthType:ERROR_LOGO];
}

-(void)passValue:(NSString *)val{
    detailId = val; 
}
-(void)passDicValue:(NSDictionary *)vals{
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"星城故事" hasLeftItem:YES hasRightItem:YES leftIcon:nil rightIcon:SHARE_ICON]];
}

-(void)goPreviou{
    [super goPreviou];
}

-(void)goForward{
    
    NSString *con_url = [NSString stringWithFormat:@"%@ http://192.168.1.210:888/text.aspx?id=%@",[dicContent valueForKey:@"_title"],detailId];
    NSMutableDictionary * showMsg = [[NSMutableDictionary alloc]init];
    [showMsg setObject:@"星城故事分享" forKey:@"showTitle"];
    [showMsg setObject:con_url forKey:@"contentString"];
    [showMsg setObject:@"" forKey:@"urlString"];
    [showMsg setObject:@"很无敌啊！" forKey:@"description"];
    [showMsg setObject:@"这个是默内容！" forKey:@"defaultContent"];
    
    [self showShareAlert:showMsg];
    
}

@end
