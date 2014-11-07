//
//  ContentDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ContentDetailViewController.h"

@interface ContentDetailViewController (){
    UIWebView *webDetail;
    NSString *dataId;
    MarqueeLabel *lblDetail;
}

@end


@implementation ContentDetailViewController

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
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
    
    //初始化开始
    [self initTitle];
    [self initWebView];
    
    
    [self initLoadData];
    
    
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    //NSLog(@"NewdataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    
}


-(void)initLoadData{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PROJECT_URL,dataId];
    _contentData = (NSDictionary *)[convertJson requestData:url];
    //填充标题
    lblDetail.text = [_contentData valueForKey:@"projectName"];
    
    //填充webview
    NSURL *contentUrl = [[NSURL alloc]initWithString:[_contentData valueForKey:@"details"]];
    [webDetail loadRequest:[NSURLRequest requestWithURL:contentUrl]];
    //NSLog(@"_contentData===%@",_contentData);
    
    //添加手势
    UITapGestureRecognizer *singleTapWeb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [webDetail addGestureRecognizer:singleTapWeb];
    singleTapWeb.delegate= self;
    singleTapWeb.cancelsTouchesInView = NO;
    
}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"更多详情" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
}

-(void)goPreviou{
    //NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//点击事件
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:webDetail];
    NSString  *_imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
    NSString *imgUrl = [webDetail stringByEvaluatingJavaScriptFromString:_imgURL];
    if (imgUrl.length > 0) {
        //展示所有图片
        NSString *imgArray = [webDetail stringByEvaluatingJavaScriptFromString:@"getImgs()"];
        if (imgArray.length > 0) {
            imgArray = [imgArray substringFromIndex:1];
            NSArray *photos = [imgArray componentsSeparatedByString:@"|"];
            NSMutableArray *imgPhotes=[[NSMutableArray alloc] init];
            NSInteger _currentPhoteoIndex = 0;
            for (int i = 0; i<photos.count; i++) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:photos[i]];
                [photo.srcImageView md_setImageWithURL:photos[i] placeholderImage:NO_IMG options:SDWebImageRefreshCached];
                [imgPhotes addObject:photo];
                
                imgArray = photos[i];
                if ([imgUrl isEqualToString:imgArray]) {
                    _currentPhoteoIndex = i;
                }
            }
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = _currentPhoteoIndex; // 弹出相册时显示的第一张图片
            browser.photos = imgPhotes; // 设置所有的图片
            [browser show];
        }
    }
}



#pragma mark 初始化标题
-(void)initTitle{
    
    lblDetail = [[MarqueeLabel alloc] initWithFrame:CGRectMake(5, 64, SCREEN_WIDTH - 5, 45) duration:15.0 andFadeLength:10.0f];
    lblDetail.font = TITLE_FONT;
    lblDetail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblDetail];
    
}


#pragma mark 初始化内容
-(void)initWebView{
    
    webDetail = [[UIWebView alloc] init];
    webDetail.delegate = self;
    webDetail.frame = CGRectMake(10, STATU_BAR_HEIGHT + NAV_TITLE_HEIGHT + 45, SCREEN_WIDTH-20, MAIN_FRAME_H - 49-44);
    [self.view addSubview:webDetail];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
}

@end
