//
//  GirlsViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "GirlsViewController.h"

@interface GirlsViewController (){
    NSString * dataType;
    NSDictionary *cellDic;
    NSArray *sourceArray;
    NSMutableArray *photoArray;
    FFScrollView *scrollView;
    CommonViewController *comViewController;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
    int currentPageIndex;
    
    NSString *max_id;
}

@end

@implementation GirlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initLoadData];
    
}

-(void)initLoadData{
    
    bannerData = [[NSMutableDictionary alloc]init];
    _girlsDataList = [[NSMutableArray alloc]init];
    
    [self initBannerData];
    currentPageIndex = 1;
    [self loadGirlData:@"1" withPageSize:PAGESIZE];
    //集成刷新控件
    [self setHeaderRereshing];
    [self setFooterRereshing];
    [self setBannerView];
    
    _girlsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _girlsTableView.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
    
}

-(void)setBannerView{
    UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    //设置顶部图片
    UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    NSString *imgUrl =[bannerData valueForKey:@"_img_url"];
    [bannerView setImageWithURL:[NSURL URLWithString:imgUrl]
                   placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
    
    bannerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    [bannerView addGestureRecognizer:singleTap];
    
    //设置图片标题
    UILabel *picTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 25)];
    picTitle.text = [bannerData valueForKey:@"_title"];
    picTitle.backgroundColor = [UIColor blackColor];
    picTitle.alpha = 0.7f;
    picTitle.textColor = [UIColor whiteColor];
    picTitle.textAlignment = NSTextAlignmentLeft;
    picTitle.font = TITLE_FONT;
    
    [bannerBaseView addSubview:bannerView];
    [bannerView addSubview:picTitle];
    _girlsTableView.tableHeaderView = bannerBaseView;
    
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

    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}


-(void)UesrClicked:(UIImageView *)imgView{
    
    NSString *artcleId = [bannerData valueForKey:@"_id"];
    NSString * data_type = [bannerData valueForKey:@"_category_call_index"];
    if([data_type isEqualToString:@"video"]){
        [self goVideoView:artcleId];
    }else if([data_type isEqualToString:@"albums"]){
       [self goPhotoView:artcleId];
    }else{
       [self goArticelView:artcleId];
    }
    
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.girlsTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:@"new" afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:@"old" afterDelay:1.0f];
        }];
        [self.girlsTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.girlsTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.girlsTableView addSubview:bottomPullView];
        isFooterSeted = YES;
    }
}


//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    //再次请求数据
    if([obj isEqualToString:@"new"]){
        [self loadNewGirlData:max_id];
    }else{
        currentPageIndex++;
        [self loadGirlData:[NSString stringWithFormat:@"%d",currentPageIndex] withPageSize:PAGESIZE];
    }
    
    //根据数据判断是否加载刷新组件
    //if(_girlsDataList!=nil && _girlsDataList.count>1){
    //    //集成刷新控件
    //    [self setFooterRereshing];//有2条数据后加载底部刷新
    //}
    
    [self.girlsTableView reloadData];
}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"美女私房" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
    
    [self initLoadData];
    [_girlsTableView reloadData];
}


/*********************************************处理数据方法 开始********************************************/

//初始化头部数据
-(void)initBannerData{
        ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
        NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,PHOTO_BANNER_URL];
        NSMutableArray *bannerArr = (NSMutableArray *)[convertJson requestData:url];
        if(bannerArr!=nil && bannerArr.count>0){
            bannerData = (NSMutableDictionary *)bannerArr[0];
        }else{
            bannerData = [[NSMutableDictionary alloc]init];
        }
        //NSLog(@"bannerData===%@",bannerData);
}

-(void)loadGirlData:(NSString *)pageIndex withPageSize:(NSString *)pageSize {
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/0/%@/%@",REMOTE_URL,GIRLS_LIST,pageSize,pageIndex];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
     if (newDataArr!=nil&&newDataArr.count>0) {
        [_girlsDataList addObjectsFromArray:newDataArr];
        //获取最大文章ID
        if([pageIndex isEqualToString:@"1"]){
            max_id = [[newDataArr objectAtIndex:0] valueForKey:@"_id"];
        }
     }else{
         [self showCustomAlert:@"没有更多数据了" widthType:WARNN_LOGO];
         return;
     }
    
    //NSLog(@"_girlsDataList===%@",_girlsDataList);
}

-(void)loadNewGirlData:(NSString *)maxid{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@",REMOTE_URL,LOAD_NEW_DATA,@"girl",max_id];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
    if (newDataArr!=nil&&newDataArr.count>0) {
        [newDataArr addObjectsFromArray:_girlsDataList];
        _girlsDataList = [[NSMutableArray alloc]init];
        [_girlsDataList addObjectsFromArray:newDataArr];
        //NSLog(@"_girlsDataList===%@",_girlsDataList);
    }else{
        [self showCustomAlert:@"没有新数据了" widthType:WARNN_LOGO];
        return;
    }
    

    
}

-(void)loadGirlPhotoData:(NSString *)articleId {
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
    photoArray = [[NSMutableArray alloc]init];
    [photoArray addObjectsFromArray:newDataArr];
    //NSLog(@"photoArray===%@",photoArray);
}


/*********************************************处理数据方法 结束********************************************/


#pragma mark 控制滚动头部一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)sclView{
    CGFloat sectionHeaderHeight = 30;
    //固定section 随着cell滚动而滚动
    if (sclView.contentOffset.y<=sectionHeaderHeight && sclView.contentOffset.y>=0) {
        sclView.contentInset = UIEdgeInsetsMake(-sclView.contentOffset.y, 0, 0, 0);
    } else if (sclView.contentOffset.y>=sectionHeaderHeight) {
        //sclView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_girlsDataList count];
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"albums"]){
        
        [self goPhotoView:[[cellDic valueForKey:@"_id"] stringValue]];
        
    }else if([dataType isEqualToString:@"video"]){
        
        [self goVideoView:[[cellDic valueForKey:@"_id"] stringValue]];
        
    }else{
        
        [self goArticelView:[[cellDic valueForKey:@"_id"] stringValue]];
        
    }

    
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"albums"]){
        return 120.0;
    }else{
        return 95.0;
    }
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"article"]){//判断是否为图片
        UINib *nibCell = [UINib nibWithNibName:@"PicTableViewCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"PicCell"];
        
        PicTableViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"PicCell"];
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        picCell.backgroundColor = [UIColor clearColor];
        
        //[StringUitl setCornerRadius:picCell.cellBgView withRadius:5.0f];
        //[StringUitl setCornerRadius:picCell.picView withRadius:5.0f];
        //[StringUitl setViewBorder:picCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
        
        [picCell.picView setImageWithURL:[NSURL URLWithString:[cellDic valueForKey:@"_img_url"]]
                       placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        picCell.cellBgView.layer.cornerRadius = 5.0f;
        picCell.cellBgView.layer.masksToBounds = YES;
        picCell.titleView.text = [cellDic valueForKey:@"_title"];
        picCell.descView.text = [cellDic valueForKey:@"_zhaiyao"];
        picCell.titleView.font = TITLE_FONT;
        picCell.descView.font = DESC_FONT;
        return picCell;
        
    }else if([dataType isEqualToString:@"video"]){
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"VideoCell"];
            isNibregistered = YES;
        }
        
        VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        videoCell.selectionStyle =UITableViewCellSelectionStyleNone;
        videoCell.backgroundColor = [UIColor clearColor];
        
        //[StringUitl setViewBorder:videoCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
        //[StringUitl setCornerRadius:videoCell.cellBgView withRadius:5.0f];
        //[StringUitl setCornerRadius:videoCell.videoPic withRadius:5.0f];
        
        [videoCell.videoPic setImageWithURL:[NSURL URLWithString:[cellDic valueForKey:@"_img_url"]]
                        placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
        
        videoCell.videoTitle.text = [cellDic valueForKey:@"_title"];
        videoCell.videoDesc.text = [cellDic valueForKey:@"_zhaiyao"];
        videoCell.clickNum.text = [cellDic valueForKey:@"clicknum"];
        videoCell.videoTitle.font = TITLE_FONT;
        videoCell.videoDesc.font = DESC_FONT;
        return videoCell;
   }else{
       
       static BOOL isNibregistered = NO;
       if(!isNibregistered){
           UINib *nibCell = [UINib nibWithNibName:@"PhotoScrollViewCell" bundle:nil];
           [tableView registerNib:nibCell forCellReuseIdentifier:@"photoScroll"];
           isNibregistered = YES;
       }
       
       PhotoScrollViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoScroll"];
       [photoCell setBackgroundColor:[UIColor clearColor]];
       photoCell.selectionStyle =UITableViewCellSelectionStyleNone;
       //通过文章获取相册
       NSString *artcleId =[cellDic valueForKey:@"_id"];
       [self loadGirlPhotoData:artcleId];
       if(photoArray!=nil && photoArray.count>0){
           [photoCell.photoScroll setContentSize:CGSizeMake((photoArray.count)*130-10, 80)];
           [photoCell.photoScroll setShowsHorizontalScrollIndicator:NO];
           [photoCell.photoScroll setBackgroundColor:[UIColor whiteColor]];
           //[photoScroll setShowsVerticalScrollIndicator:NO];
           
           //加载图片
           for(int i=0;i<photoArray.count;i++){

               NSMutableDictionary *picDic = (NSMutableDictionary *)[photoArray objectAtIndex:i];
               UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((100+30)*i, 0, 120, 80)];
               imageView.userInteractionEnabled = YES;
               [imageView setImageWithURL:[NSURL URLWithString:[picDic valueForKey:@"_thumb_path"]]
                         placeholderImage:[UIImage imageNamed:NOIMG_ICON] options:SDWebImageRefreshCached];
               //[StringUitl setCornerRadius:imageView withRadius:5.0f];
               
               UIButton *imgbtn = [[UIButton alloc]initWithFrame:CGRectMake((100+30)*i, 0, 120, 80)];
               [imgbtn setBackgroundColor:[UIColor clearColor]];
               imgbtn.tag = [artcleId integerValue];
               [imgbtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               
               [photoCell.photoScroll addSubview:imageView];
               [photoCell.photoScroll addSubview:imgbtn];
           }
           
           //[StringUitl setCornerRadius:photoCell.cellBgView withRadius:5.0f];
           //[StringUitl setViewBorder:photoCell.cellBgView withColor:@"#F5F5F5" Width:0.5f];
           
           [photoCell.titleView setText:[cellDic valueForKey:@"_title"]];
           photoCell.titleView.font = TITLE_FONT;
           
       }
       
       return photoCell;
   }
    
}


-(void)imgBtnClick:(UIButton *)sender{
    
    NSLog(@"@artcleId=%d",sender.tag);
    [self goPhotoView:[NSString stringWithFormat:@"%d",sender.tag]];
}

-(void)goPhotoView:(NSString *)articleId{
    GirlsPhotosViewController *girlPhotoView = [[GirlsPhotosViewController alloc]init];
    passValelegate = girlPhotoView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:girlPhotoView animated:YES];
    NSLog(@"articleId=%@",articleId);
}

-(void)goVideoView:(NSString *)articleId{
    GirlsVideoViewController *girlVideoView = [[GirlsVideoViewController alloc]init];
    passValelegate = girlVideoView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:girlVideoView animated:YES];
    NSLog(@"articleId=%@",articleId);
    
}

-(void)goArticelView:(NSString *)articleId{
    StoryDetailViewController *articelView = [[StoryDetailViewController alloc]init];
    passValelegate = articelView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:articelView animated:YES];
    NSLog(@"articleId=%@",articleId);
    
}

@end
