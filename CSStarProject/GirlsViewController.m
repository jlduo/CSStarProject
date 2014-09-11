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
    NSArray *photoArray;
    FFScrollView *scrollView;
    CommonViewController *comViewController;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
}

@end

@implementation GirlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setTableData];
    //集成刷新控件
    [self setHeaderRereshing];
    [self setBannerView];
    

    //_girlsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    
}

-(void)setBannerView{
    UIView *bannerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    //设置顶部图片
    UIImageView *bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 180)];
    NSString *imageName = @"http://dc.jldoo.cn/upload/201405/29/small_201405291500453772.jpg";
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    [bannerView setImage:image];
    
    //设置图片标题
    UILabel *picTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, SCREEN_WIDTH, 25)];
    picTitle.text = @"一个陌生人的来信";
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



-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:REFRESH_LOADING];
        self.refreshControl.backgroundColor = [UIColor lightTextColor];
        self.refreshControl.alpha = 0.5f;
        //添加新的模拟数据
        NSDate *date = [[NSDate alloc] init];
        //模拟请求完成之后，回调方法callBackMethod
        [self performSelector:@selector(callBackMethod:) withObject:date afterDelay:DELAY_TIME];
    }
}

//这是一个模拟方法，请求完成之后，回调方法
-(void)callBackMethod:(id) obj
{
    int randomNumber = arc4random() % 10 ;//[0,100)包括0，不包括100
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSString* picName = [NSString stringWithFormat:@"%d.png",randomNumber];
    [data setValue:picName forKey:@"pic"];
    [data setValue:@"测试刷新数据" forKey:@"title"];
    [data setValue:@"好像还不错哦！" forKey:@"desc"];
    [data setValue:@"video" forKey:@"datatype"];
    [data setValue:@"9527" forKey:@"clicknum"];
    
    [_girlsDataList insertObject:data atIndex:_girlsDataList.count];
    //根据数据判断是否加载刷新组件
    if(_girlsDataList!=nil && _girlsDataList.count>2){
        //集成刷新控件
        _girlsTableView.backgroundColor = [UIColor lightGrayColor];
        [self setFooterRereshing];//有2条数据后加载底部刷新
    }
    
    [self.girlsTableView reloadData];
}


-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"美女私房" hasLeftItem:NO hasRightItem:YES]];
}

-(void)setTableData{
    
    NSBundle *manBund = [NSBundle mainBundle];
    NSString *path = [manBund pathForResource:@"homeDataList" ofType:@"plist"];
    NSDictionary *myData = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *array1 = [myData valueForKey:@"美女私房"];
    _girlsDataList  = [NSMutableArray arrayWithArray:array1];

    //NSLog(@"_girlsDataList==%@",_girlsDataList);
}

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
    dataType = [cellDic valueForKey:@"datatype"];
    if([dataType isEqualToString:@"photo"]){
        return 110.0;
    }else{
        return 60.0;
    }
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellDic = [self.girlsDataList objectAtIndex:indexPath.row];
    dataType = [cellDic valueForKey:@"datatype"];
    if([dataType isEqualToString:@"pic"]){//判断是否为图片
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"PicTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"PicCell"];
            isNibregistered = YES;
        }
        
        PicTableViewCell *picCell = [self.girlsTableView dequeueReusableCellWithIdentifier:@"PicCell"];
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *picImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
        [picCell.picView setBackgroundImage:picImg forState:UIControlStateNormal];
        
        picCell.titleView.text = [cellDic valueForKey:@"title"];
        [picCell.descView alignTop];
        picCell.descView.text = [cellDic valueForKey:@"desc"];
        return picCell;
        
    }else if([dataType isEqualToString:@"video"]){
        static BOOL isNibregistered = NO;
        if(!isNibregistered){
            UINib *nibCell = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
            [tableView registerNib:nibCell forCellReuseIdentifier:@"VideoCell"];
            isNibregistered = YES;
        }
        
        VideoTableViewCell *videoCell = [self.girlsTableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        videoCell.selectionStyle =UITableViewCellSelectionStyleNone;
        UIImage *videImg =[UIImage imageNamed:[cellDic valueForKey:@"pic"]];
        [videoCell.videoPic setBackgroundImage:videImg forState:UIControlStateNormal];
        videoCell.videoTitle.text = [cellDic valueForKey:@"title"];
        
        [videoCell.videoDesc alignTop];
        videoCell.videoDesc.text = [cellDic valueForKey:@"desc"];
        videoCell.clickNum.text = [cellDic valueForKey:@"clicknum"];
        return videoCell;
   }else{
       CustomTableCell *photoCell = [[CustomTableCell alloc]init];
       //photoCell.selectionStyle =UITableViewCellSelectionStyleNone;
       //[photoCell setFrame: CGRectMake(0, 0, SCREEN_WIDTH, 80)];
       
       photoArray = [cellDic valueForKey:@"pics"];
       if(photoArray!=nil && photoArray.count>0){
           UIScrollView  *photoScroll = [[UIScrollView alloc]init];
           [photoScroll setFrame:CGRectMake(0, 25,SCREEN_WIDTH, 80)];
           [photoScroll setContentSize:CGSizeMake((photoArray.count)*115-15, 80)];
           
           [photoScroll setShowsHorizontalScrollIndicator:NO];
           //[photoScroll setShowsVerticalScrollIndicator:NO];
           
           //加载图片
           UIImageView *imageView;
           for(int i=0;i<photoArray.count;i++){
               imageView= [[UIImageView alloc]initWithFrame:CGRectMake((100+15)*i, 0, 100, 80)];
               NSLog(@"pic==%@",[photoArray objectAtIndex:i]);
               [imageView setImage:[UIImage imageNamed:[photoArray objectAtIndex:i]]];
               //添加图片的点击事件
               imageView.userInteractionEnabled = YES;
               UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goPhotoView)];
               [imageView addGestureRecognizer:singleTap];
               
               [photoScroll addSubview:imageView];
           }
           
           //设置图片标题
           UILabel *photoTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
           photoTitle.text = [cellDic valueForKey:@"title"];
           photoTitle.backgroundColor = [UIColor whiteColor];
           //photoTitle.alpha = 0.4f;
           photoTitle.textColor = [UIColor blackColor];
           photoTitle.textAlignment = NSTextAlignmentLeft;
           photoTitle.font = [UIFont fontWithName:@"Arial" size:12.0f];
           
           [photoCell addSubview:photoTitle];
           [photoCell addSubview:photoScroll];
       }
       
       return photoCell;
   }
    
}

-(void)goPhotoView{
    
    NSLog(@"dfsdsfsfsdf");
}


@end
