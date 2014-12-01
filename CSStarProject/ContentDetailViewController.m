//
//  ContentDetailViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ContentDetailViewController.h"

@interface ContentDetailViewController (){
    NSString *dataId;
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
    self.view.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
    [StringUitl setViewBorder:self.contentBackView withColor:@"#cccccc" Width:0.5f];
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
    [self loadData];
    //添加手势
    UITapGestureRecognizer *singleTapWeb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_contentView addGestureRecognizer:singleTapWeb];
    _contentView.scrollView.showsVerticalScrollIndicator = NO;
    singleTapWeb.delegate= self;
    singleTapWeb.cancelsTouchesInView = NO;
    
}

-(void)loadData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PROJECT_URL,dataId];
    [HttpClient GET:url
         parameters:nil
             isjson:FALSE
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 
                 _contentData = [StringUitl getDicFromData:responseObject];
                 _contentTitle.text = [_contentData valueForKey:@"projectName"];
                 NSURL *contentUrl = [[NSURL alloc]initWithString:[_contentData valueForKey:@"details"]];
                 [_contentView loadRequest:[NSURLRequest requestWithURL:contentUrl]];
                 
             }
     
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [self requestFailed:error];
                 
             }
     ];
    
    
}
- (void)requestFailed:(NSError *)error
{
    NSLog(@"error=%@",error);
    //[self showNo:ERROR_INNER];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"更多详情" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//点击事件
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:_contentView];
    NSString  *_imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
    NSString *imgUrl = [_contentView stringByEvaluatingJavaScriptFromString:_imgURL];
    if (imgUrl.length > 0) {
        //展示所有图片
        NSString *imgArray = [_contentView stringByEvaluatingJavaScriptFromString:@"getImgs()"];
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
            
            BOOL displayActionButton = NO;
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


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    
    
    
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%d / %d", index+1,_photos.count];
}



-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoading:@"数据加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHud];
    [self showNo:@"加载数据失败..."];
}

@end
