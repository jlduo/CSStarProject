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
}

@end

@implementation GirlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    bannerData = [[NSMutableDictionary alloc]init];
    _girlsDataList = [[NSMutableArray alloc]init];
    
    [self initBannerData];
    currentPageIndex = 1;
    [self loadGirlData:@"1" withPageSize:PAGESIZE];
    //集成刷新控件
    [self setHeaderRereshing];
    [self setBannerView];

    _girlsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _girlsTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    
    
}

-(void)setBannerView{
    UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    //设置顶部图片
    UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
    //NSString *imageName = @"http://dc.jldoo.cn/upload/201405/29/small_201405291500453772.jpg";
    NSString *imgUrl =[bannerData valueForKey:@"_img_url"];
    AsynImageView *imageView = [[AsynImageView alloc]init];
    imageView.imageURL = [NSString stringWithFormat:@"%@", imgUrl];
    [bannerView setImage:imageView.image];
    
    //设置图片标题
    UILabel *picTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 25)];
    picTitle.text = [bannerData valueForKey:@"_title"];
    picTitle.backgroundColor = [UIColor blackColor];
    picTitle.alpha = 0.4f;
    picTitle.textColor = [UIColor whiteColor];
    picTitle.textAlignment = NSTextAlignmentCenter;
    picTitle.font = [UIFont fontWithName:@"Arial" size:14.0f];
    
    [bannerBaseView addSubview:bannerView];
    [bannerView addSubview:picTitle];
    _girlsTableView.tableHeaderView = bannerBaseView; 
    _girlsTableView.backgroundColor = [UIColor whiteColor];
    
}

//加载头部刷新
-(void)setHeaderRereshing{
    if(!isHeaderSeted){
        AllAroundPullView *topPullView = [[AllAroundPullView alloc] initWithScrollView:self.girlsTableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
            NSLog(@"up-");
            [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:DELAY_TIME];
            [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
        }];
        [self.girlsTableView addSubview:topPullView];
        isHeaderSeted = YES;
    }
}

//加底部部刷新
-(void)setFooterRereshing{
    if(!isFooterSeted){
        AllAroundPullView *bottomPullView = [[AllAroundPullView alloc] initWithScrollView:self.girlsTableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
            NSLog(@"down-");
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
    currentPageIndex++;
    [self loadGirlData:[NSString stringWithFormat:@"%d",currentPageIndex] withPageSize:PAGESIZE];
    //根据数据判断是否加载刷新组件
    if(_girlsDataList!=nil && _girlsDataList.count>2){
        //集成刷新控件
        [self setFooterRereshing];//有2条数据后加载底部刷新
    }
    
    [self.girlsTableView reloadData];
}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"美女私房" hasLeftItem:NO hasRightItem:YES leftIcon:nil rightIcon:nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController showDIYTaBar];
}

-(void)setTableData{
    
    NSBundle *manBund = [NSBundle mainBundle];
    NSString *path = [manBund pathForResource:@"homeDataList" ofType:@"plist"];
    NSDictionary *myData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *array1 = [myData valueForKey:@"美女私房"];
    _girlsDataList  = [NSMutableArray arrayWithArray:array1];

    //NSLog(@"_girlsDataList==%@",_girlsDataList);
}

/*********************************************处理数据方法 开始********************************************/

//初始化头部数据
-(void)initBannerData{
        ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
        NSString *url = [NSString stringWithFormat:@"http://192.168.1.210:8888/cms/GetArticles/albums/1/is_top=1"];
        NSMutableArray *bannerArr = (NSMutableArray *)[convertJson requestData:url];
        if(bannerArr!=nil&&bannerArr.count>0){
            bannerData = (NSMutableDictionary *)bannerArr[0];
        }
        NSLog(@"bannerData===%@",bannerData);
}

-(void)loadGirlData:(NSString *)pageIndex withPageSize:(NSString *)pageSize {
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.210:8888/cms/GetArticleList/girl/0/%@/%@",pageSize,pageIndex];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
    [_girlsDataList addObjectsFromArray:newDataArr];
    NSLog(@"_girlsDataList===%@",_girlsDataList);
}

-(void)loadGirlPhotoData:(NSString *)articleId {
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.210:8888/cms//GetAlbums/%@",articleId];
    NSMutableArray * newDataArr = (NSMutableArray *)[convertJson requestData:url];
    photoArray = [[NSMutableArray alloc]init];
    [photoArray addObjectsFromArray:newDataArr];
    NSLog(@"photoArray===%@",photoArray);
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

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_girlsDataList count];
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"albums"]){
        return 110.0;
    }else{
        return 70.0;
    }
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"_category_call_index"];
    if([dataType isEqualToString:@"article"]){//判断是否为图片
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"PicTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"PicCell"];
            isNibregistered = YES;
        }
        
        PicTableViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"PicCell"];
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //UIImage *picImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
        //[picCell.picView setBackgroundImage:picImg forState:UIControlStateNormal];
        //picCell.picView.imageURL = [cellDic valueForKey:@"pic"];
        AsynImageView *imageView = [[AsynImageView alloc]init];
        imageView.imageURL = [NSString stringWithFormat:@"%@", [cellDic valueForKey:@"_img_url"]];
        picCell.picView.image = imageView.image;
        
        picCell.titleView.text = [cellDic valueForKey:@"_title"];
        picCell.descView.text = [cellDic valueForKey:@"_zhaiyao"];
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
//        UIImage *videImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
//        [videoCell.videoPic setBackgroundImage:videImg forState:UIControlStateNormal];
        //videoCell.videoPic.imageURL =[cellDic valueForKey:@"pic"];
        
        AsynImageView *imageView = [[AsynImageView alloc]init];
        imageView.imageURL = [NSString stringWithFormat:@"%@", [cellDic valueForKey:@"_img_url"]];
        videoCell.videoPic.image = imageView.image;
        
        videoCell.videoTitle.text = [cellDic valueForKey:@"_title"];
        videoCell.videoDesc.text = [cellDic valueForKey:@"_zhaiyao"];
        videoCell.clickNum.text = [cellDic valueForKey:@"clicknum"];
        return videoCell;
   }else{
       CustomTableCell *photoCell = [[CustomTableCell alloc]init];
       //photoCell.selectionStyle =UITableViewCellSelectionStyleNone;
       //[photoCell setFrame: CGRectMake(0, 0, SCREEN_WIDTH, 80)];
       
       //通过文章获取相册
       [self loadGirlPhotoData:[cellDic valueForKey:@"_id"]];
       if(photoArray!=nil && photoArray.count>0){
           UIScrollView  *photoScroll = [[UIScrollView alloc]init];
           [photoScroll setFrame:CGRectMake(0, 25,SCREEN_WIDTH, 80)];
           [photoScroll setContentSize:CGSizeMake((photoArray.count)*115-10, 80)];
           [photoScroll setShowsHorizontalScrollIndicator:NO];
           //[photoScroll setShowsVerticalScrollIndicator:NO];
           
           //加载图片
           //UIImageView *imageView;
           for(int i=0;i<photoArray.count;i++){
               
               //imageView = [[AsynImageView alloc]initWithFrame:CGRectMake((100+15)*i, 0, 100, 80)];
               //imageView.imageURL = [NSString stringWithFormat:@"%@", [photoArray objectAtIndex:i]];
               
               NSMutableDictionary *picDic = (NSMutableDictionary *)[photoArray objectAtIndex:i];
               AsynImageView *imageView = [[AsynImageView alloc]initWithFrame:CGRectMake((100+10)*i, 0, 100, 80)];
               imageView.imageURL = [NSString stringWithFormat:@"%@", [picDic valueForKey:@"_thumb_path"]];
               
               
//               imageView= [[UIImageView alloc]initWithFrame:CGRectMake((100+15)*i, 0, 100, 80)];
//               NSLog(@"pic==%@",[photoArray objectAtIndex:i]);
//               [imageView setImage:[UIImage imageNamed:[photoArray objectAtIndex:i]]];
               //添加图片的点击事件
               imageView.userInteractionEnabled = YES;
               UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goPhotoView)];
               [imageView addGestureRecognizer:singleTap];
               
               [photoScroll addSubview:imageView];
           }
           
           //设置图片标题
           UILabel *photoTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
           photoTitle.text = [cellDic valueForKey:@"_title"];
           photoTitle.backgroundColor = [UIColor lightGrayColor];
           //photoTitle.alpha = 0.4f;
           photoTitle.textColor = [UIColor blackColor];
           photoTitle.textAlignment = NSTextAlignmentLeft;
           photoTitle.font = [UIFont fontWithName:@"Arial" size:14.0f];
           
           [photoCell addSubview:photoTitle];
           [photoCell addSubview:photoScroll];
           //[_girlsTableView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, MAIN_FRAME_H-49-40)];
       }
       
       return photoCell;
   }
    
}

-(void)goPhotoView{
    GirlsPhotoViewController *girlPhotoView = [[GirlsPhotoViewController alloc]init];
    [self.navigationController pushViewController:girlPhotoView animated:YES];
    NSLog(@"dfsdsfsfsdf");
}


@end
