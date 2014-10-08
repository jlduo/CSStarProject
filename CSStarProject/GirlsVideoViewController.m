//
//  GirlsVideoViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-5.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "GirlsVideoViewController.h"
#import "InitTabBarViewController.h"
#import "StoryCommentViewController.h"

@interface GirlsVideoViewController (){
    UIImageView *videoPic;
    UIButton *playBtn;
    UIView *headView;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
    UILabel *descLabel;
    NSString *dataId;
    NSDictionary *cellDic;
    
    UIToolbar *toolBar;
    UIButton *numBtn;
    UILabel *plabel;
    UIImageView *cIconView;
    UITextView *textField;
    UITableView *videoTableView;
    
}

@end

@implementation GirlsVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initLoadData];
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    
    videoTableView = [[UITableView alloc] initWithFrame:tframe];
    videoTableView.delegate = self;
    videoTableView.dataSource = self;
    
    videoTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [videoTableView setTableFooterView:view];
    videoTableView.showsVerticalScrollIndicator = YES;
    
    //处理头部信息
    [self initBannerData];
    [self loadGirlsData];
    //[self setTableHead];
    
    [self setVideoView:YES];
    [self initToolBar];
    
    
    //集成刷新控件
    [self setHeaderRereshing];
    if(topVideoArray!=nil&&topVideoArray.count>2){
        [self setFooterRereshing];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarController.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

-(void)showCustomAlert:(NSString *)msg widthType:(NSString *)tp{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    //[imgView setFrame:CGRectMake(0, 0, 42, 42)];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
    
    [self dismissKeyBoard];
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-40-44);
    [videoTableView setFrame:temFrame];
    
    [self initLoadData];
    [videoTableView reloadData];
    [self changeRation:NO];
    
}

//初始化头部数据
-(void)initBannerData{
    if([self isNotEmpty:dataId]){
        
        ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_ARTICLE_URL,dataId];
        bannerData = (NSMutableDictionary *)[convertJson requestData:url];
        //NSLog(@"bannerData===%@",bannerData);
        
    }
}

//初始化底部工具栏
-(void)initToolBar{
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, SCREEN_WIDTH, 40)];
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
    plabel.font = main_font(12);
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
    [numBtn setBackgroundImage:[UIImage imageNamed:CONTENT_BACKGROUND] forState:UIControlStateNormal];
    
    //给按钮默认显示评论数据
    [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //[bannerData valueForKey:@"_click"]
    NSString *clickNum = [self getCommentNum:dataId];
    [numBtn setTitle:clickNum forState:UIControlStateNormal];
    [numBtn setTitle:clickNum forState:UIControlStateHighlighted];
    numBtn.titleLabel.font = Font_Size(14);
    
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
    if([self isNotEmpty:textVal]){
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
        NSString *clickNum = [self getCommentNum:dataId];
       [numBtn setTitle:clickNum forState:UIControlStateNormal];
       [numBtn setTitle:clickNum forState:UIControlStateHighlighted];
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
            //[self alertMsg:@"对不起,请输入评论信息后提交!" withtitle:@"［错误提示］"];
            [self showCustomAlert:@"请输入评论信息后提交" widthType:WARNN_LOGO];
        }else{
            //提交数据
            [self postCommetnVal:dataId];
        }
        
    }else{//点击数字进入评论列表
        NSLog(@"进入评论列表....");
        NSLog(@"newDataId=%@",dataId);
        StoryCommentViewController *commentController = [[StoryCommentViewController alloc]init];
        passValelegate = commentController;
        [passValelegate passValue:dataId];
        
        [self presentViewController:commentController animated:YES completion:^{
            //code
        }];
    }
}

//提价评论信息
-(void)postCommetnVal:(NSString *)articelId{
    
    NSURL *comment_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,ADD_COMMENT_URL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:comment_url];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:articelId forKey:@"articleId"];
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
        //[StringUitl alertMsg:@"提交评论信息成功!" withtitle:@"提示信息"];
        [self showCustomAlert:@"提交评论信息成功!" widthType:SUCCESS_LOGO];
        [textField setText:nil];
        [self dismissKeyBoard];
    }
    if(![[jsonDic valueForKey:@"result"] isEqualToString:@"ok"]){//成功
        [StringUitl alertMsg:[jsonDic valueForKey:@"result"] withtitle:@"提示信息"];
        [self showCustomAlert:[jsonDic valueForKey:@"result"] widthType:SUCCESS_LOGO];
        
    }
    
}

- (void)addCommentFailed:(ASIHTTPRequest *)req
{
    
    //[StringUitl alertMsg:@"提交数据失败！" withtitle:@"错误提示"];
    [self showCustomAlert:@"提交数据失败" widthType:ERROR_LOGO];
}



-(void)loadGirlsData{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/3/is_red=1",REMOTE_URL,GIRL_VIDEO_URL];
    NSArray *girlsArr = (NSArray *)[convertJson requestData:url];
    if(girlsArr!=nil && girlsArr.count>0){
        topVideoArray = [NSMutableArray arrayWithArray:girlsArr];
    }
    //NSLog(@"topVideoArray====%@",topVideoArray);
    
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)setVideoView:(BOOL)isRemote{
    
    if(isRemote){
         //NSString *remoteUrl = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
         NSString *remoteUrl = [bannerData valueForKey:@"_link_url"];
         moviePlayer = [[DirectionMPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:remoteUrl]];
    }else{
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"testVideo" ofType:@"MOV"];
        if(moviePath){
          NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
          moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        }
    }
    //设置播放器高度参数
    [[moviePlayer view] setFrame:CGRectMake(0,0, SCREEN_WIDTH, 180)];
    //[self.view addSubview:moviePlayer.view];
    
    //定义描述信息
    UIView *videoDesc = [[UIView alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 0)];
    videoDesc.backgroundColor = [UIColor whiteColor];
    
    //1.实例化UILabel，其frame设置为CGRectZero，后面会重新设置该值。
    descLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    //2.将UILabel设置为自动换行
    [descLabel setNumberOfLines:0];
    [descLabel setAlpha:0.7f];
    //3.具体要自适应处理的字符串实例
    NSString *s = [bannerData valueForKey:@"_zhaiyao"];
    descLabel.text = [NSString stringWithFormat:@"    %@",s];
    //4.获取所要使用的字体实例
    UIFont *font = main_font(16);
    descLabel.font = font;
    //5.UILabel字符显示的最大大小
    CGSize size = CGSizeMake(SCREEN_WIDTH,150);
    //6.计算UILabel字符显示的实际大小
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size];
    //7.重设UILabel实例的frame
    [descLabel setFrame:CGRectMake(0,0, SCREEN_WIDTH, labelsize.height)];
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [videoDesc setFrame:CGRectMake(5,185, SCREEN_WIDTH, labelsize.height+10)];
    
    //修改videoTable的frame
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,(MAIN_FRAME_H-49-30));
    [videoTableView setFrame:temFrame];
    //8.将UILabel实例作为子视图添加到父视图中，这里的父视图是self.view
    [videoDesc addSubview:descLabel];
    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180+videoDesc.frame.size.height)];
    headView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:moviePlayer.view];
    [headView addSubview:videoDesc];
    
    videoTableView.tableHeaderView = headView;
    [self.view addSubview:videoTableView];
    
    //视频监听事件
    [self addNotice];
    [self addLoadTip];
    [self addVideoPic];
    [self addPlayBtn];
  
    

}

//增加加载提示动画
-(void)addLoadTip{
    
    loadingAni = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-32)/2, (180-50)/2, 32, 32)];
    loadingAni.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [headView addSubview:loadingAni];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40)/2, 90, 80, 40)];
    loadingLabel.text = @"加载中...";
    UIFont *font = main_font(12);
    loadingLabel.font = font;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    
    [loadingAni startAnimating];
    [headView addSubview:loadingLabel];

}

//移除提示信息
-(void)removeLoadTip{
    
    [loadingAni removeFromSuperview];
    [loadingLabel removeFromSuperview];
    
}

-(void)addVideoPic{
    //加载图片视图
    videoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    NSString *videoPicUrl = [bannerData valueForKey:@"_img_url"];
    NSData *imgData =[NSData dataWithContentsOfURL:[NSURL URLWithString:videoPicUrl]];
    if(imgData==nil || 0==imgData.length){
        [self removeLoadTip];
    }
    [videoPic setImage:[UIImage imageWithData:imgData]];
    
    [headView addSubview:videoPic];
}

-(void)addPlayBtn{
    
    playBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-32, 70, 64,64)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"video_play_black@2x.png"] forState:UIControlStateNormal];
    
    [playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchDown];
    [headView addSubview:playBtn];
}

-(void)addNotice{
    
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    //添加一个加载状态都通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieLoadingCallback:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:moviePlayer];
    //添加一个播放状态都通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMoviePlayStateCallback:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:moviePlayer];
    
    
    
}


-(void)removeNotice:(NSNotification*)notify{
    //视频播放对象
    MPMoviePlayerController* myMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:myMovie];
    [myMovie.view removeFromSuperview];

}

//加载状态通知调用
-(void)myMovieLoadingCallback:(NSNotification*)notify{
    
    MPMoviePlayerController *player = notify.object;
    MPMovieLoadState loadState = player.loadState;
    if(loadState != MPMovieLoadStateUnknown){
        [self removeLoadTip];
    }
    
}

//播放状态通知调用
-(void)myMoviePlayStateCallback:(NSNotification*)notify{
    
    MPMoviePlayerController *player = notify.object;
    MPMoviePlaybackState playState = player.playbackState;
    
    NSLog(@"playState==%d",playState);
    if(playState==MPMoviePlaybackStatePaused){
        [self changeRation:NO];
        [self addLoadTip];
    }
    
    if(playState==MPMoviePlaybackStatePlaying){
        [self changeRation:YES];
        [self removeLoadTip];
    }
    
    if(playState==MPMoviePlaybackStateStopped){
        //[self setVideoView:TRUE];
        [self changeRation:NO];
    }
    
    if(playState==MPMoviePlaybackStateSeekingForward){
        NSLog(@"self.moviePlayer Forward");
        
    }
    
    if(playState==MPMoviePlaybackStateSeekingBackward){
        NSLog(@"self.moviePlayer Backward");
    }
    
    
    
}

//播放结束调用
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    [self removeNotice:notify];
    [self addNotice];
    [self.view addSubview:moviePlayer.view];
    
    [self.view addSubview:videoPic];
    [self.view addSubview:playBtn];
    [self changeRation:NO];
}

-(void)playVideo{
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isFull = YES;
    
    //NSString *remoteUrl = [bannerData valueForKey:@"_link_url"];
    NSString *remoteUrl =  moviePlayer.contentURL.absoluteString;
    NSRange range = [remoteUrl rangeOfString:@"http://"];
    if(range.location!=NSNotFound){
        NSString *string2 = [remoteUrl substringFromIndex:7];
         NSRange range2 = [string2 rangeOfString:@"http://"];
        if(range2.location!=NSNotFound){
            [self changeRation:NO];
            //[StringUitl alertMsg:@"视频地址有误,加载失败!" withtitle:@"错误提示"];
            [self showCustomAlert:@"视频地址有误,加载失败" widthType:ERROR_LOGO];
            return;
        }
    }
    
    
    if([StringUitl isEmpty:remoteUrl]){
        [self changeRation:NO];
        //[StringUitl alertMsg:@"视频地址为空,加载失败!" withtitle:@"错误提示"];
        [self showCustomAlert:@"视频地址为空,加载失败" widthType:ERROR_LOGO];
        return;
    }
    
    NSString *fileExt = [StringUitl getFileExtName:remoteUrl];
    if(![fileExt isEqualToString:@"mp4"]){
        [self changeRation:NO];
        //[StringUitl alertMsg:[NSString stringWithFormat:@"对不起，不支持[%@]视频格式!",fileExt] withtitle:@"错误提示"];
        [self showCustomAlert:[NSString stringWithFormat:@"对不起，不支持[%@]视频格式!",fileExt] widthType:ERROR_LOGO];
        return;
    }
    
    [playBtn removeFromSuperview];
    [videoPic removeFromSuperview];
    [moviePlayer play];
    
    //if(moviePlayer.playbackState!=MPMoviePlaybackStateStopped){
        
        [moviePlayer setFullscreen:YES animated:YES];
        [moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
        [self changeRation:YES];
    
    //}
}


-(void)stopPlay{
    
    [playBtn removeFromSuperview];
    [videoPic removeFromSuperview];
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    
    [self changeRation:NO];
    
}

-(void)changeRation:(BOOL)isRation{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isFull = isRation;
}

-(void)goPreviou{
    [super goPreviou];
    [self dismissViewControllerAnimated:YES completion:^{
        //关闭时候到操作
    }];
    [self stopPlay];
}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"美女私房" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}


//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:videoTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            NSLog(@"up-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [videoTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:videoTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            NSLog(@"down-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [videoTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    [self loadGirlsData];
    [videoTableView reloadData];
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

#pragma mark 设置组视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect headFrame = CGRectMake(0, 6, 320, 22);
    UIView *sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
    sectionHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:CONTENT_BACK_COLOR]];
    //设置每组的头部图片
    NSString *imgName = [NSString stringWithFormat:@"header_%d@2x.png",section];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    [imageView setFrame:CGRectMake(5, 10, 3, 20)];
    //设置每组的标题
    UILabel *headtitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 100, 22)];
    headtitle.text = @"私房推荐";
    headtitle.font = TITLE_FONT;
    
    [sectionHeadView addSubview:imageView];
    [sectionHeadView addSubview:headtitle];
    
    
    return sectionHeadView;
}


#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return topVideoArray.count;
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
    
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *bid = [[bannerData valueForKey:@"_id"] stringValue];
    cellDic = [topVideoArray objectAtIndex:indexPath.row];
    NSString *newId = [[cellDic valueForKey:@"_id"] stringValue];
    NSLog(@"newDataId=%@",newId);
    if([bid isEqual:newId]){
        [self setVideoView:YES];
    }else{
        GirlsVideoViewController *girlVideoController = [[GirlsVideoViewController alloc]init];
        passValelegate = girlVideoController;
        [passValelegate passValue:newId];
        
        [self presentViewController:girlVideoController animated:YES completion:^{
            [moviePlayer stop];
        }];
    
    }
    
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UINib *nibCell = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
    [tableView registerNib:nibCell forCellReuseIdentifier:@"VideoCell"];
    VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    
    cellDic = [topVideoArray objectAtIndex:indexPath.row];
    videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    videoCell.backgroundColor = [UIColor clearColor];
    
    
    NSString *imgUrl =[cellDic valueForKey:@"_img_url"];
    NSRange range = [imgUrl rangeOfString:@"/upload/"];
    if(range.location!=NSNotFound){//判断加载远程图像
//        UIImage *videImg =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
//        [videoCell.videoPic setBackgroundImage:videImg forState:UIControlStateNormal];
        
        //videoCell.videoPic.imageURL = imgUrl;
        //改写异步加载图片
        [videoCell.videoPic setImageWithURL:[NSURL URLWithString:imgUrl]
                  placeholderImage:[UIImage imageNamed:@"remind_noimage"] options:SDWebImageRefreshCached];
        
    }
    
    videoCell.videoTitle.text = [cellDic valueForKey:@"_title"];
    videoCell.videoDesc.text = [cellDic valueForKey:@"_zhaiyao"];
    
    videoCell.videoTitle.font = TITLE_FONT;
    videoCell.videoDesc.font = DESC_FONT;
    NSNumber * clickNum =[cellDic valueForKey:@"_click"];
    videoCell.clickNum.text = [clickNum stringValue];
    return videoCell;
}




@end
