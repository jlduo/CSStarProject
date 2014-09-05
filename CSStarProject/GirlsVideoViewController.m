//
//  GirlsVideoViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-5.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "GirlsVideoViewController.h"

@interface GirlsVideoViewController (){
    UIImageView *videoPic;
    UIButton *playBtn;
    
    BOOL isHeaderSeted;
    BOOL isFooterSeted;
    
    
    UITableView *videoTableView;
}

@end

@implementation GirlsVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    videoTableView.delegate = self;
    videoTableView.dataSource = self;
    
    //加入播放器
    [self setVideoView:YES];
    
    //计算高度
    CGRect tframe = CGRectMake(0, 284, SCREEN_WIDTH,(MAIN_FRAME_H-315));
    
    videoTableView = [[UITableView alloc] initWithFrame:tframe];
    videoTableView.delegate = self;
    videoTableView.dataSource = self;
    
    [videoTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con_bg@2x.jpg"]]];
    //videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [videoTableView setTableFooterView:view];
    videoTableView.showsVerticalScrollIndicator = YES;
    
    //处理头部信息
    [self setTableHead];
    
    [self.view addSubview:videoTableView];
    
    //集成刷新控件
    [self setHeaderRereshing];
    [self setFooterRereshing];
    
}

-(void)setTableHead{
    //定义描述信息
    UIView *videoDesc = [[UIView alloc]initWithFrame:CGRectMake(0, 224, SCREEN_WIDTH, 60)];
    videoDesc.backgroundColor = [UIColor whiteColor];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [descLabel setText:@"  当电影播放器结束对内容的预加载后发出。"];
    [descLabel setTextColor:[UIColor blackColor]];
    [descLabel setNumberOfLines:3];
    [descLabel setAlpha:0.7];
    [descLabel setLineBreakMode:NSLineBreakByWordWrapping];
    descLabel.font = [UIFont fontWithName:@"Arial" size:13.0f];
    [videoDesc addSubview:descLabel];
    [self.view addSubview:videoDesc];
    //videoTableView.tableHeaderView = videoDesc;
}

-(void)setVideoView:(BOOL)isRemote{
    if(isRemote){
        NSString *remoteUrl = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
        moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:remoteUrl]];
    }else{
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
        if(moviePath){
          NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
          moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        }
        
        
    }
    //设置播放器高度参数
    [[moviePlayer view] setFrame:CGRectMake(0,STATU_BAR_HEIGHT+NAV_TITLE_HEIGHT, MAIN_FRAME_W, 160)];
    [self.view addSubview:moviePlayer.view];
    
    [self addNotice];
    [self addVideoPic];
    [self addPlayBtn];

}

-(void)addVideoPic{
    //加载图片视图
    videoPic = [[UIImageView alloc]initWithFrame:moviePlayer.view.frame];
    [videoPic setImage:[UIImage imageNamed:@"2.png"]];
    [self.view addSubview:videoPic];
}

-(void)addPlayBtn{
    
    playBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 130, 40,40)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"playsmall.png"] forState:UIControlStateNormal];
    
    [playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:playBtn];
}

-(void)addNotice{
    
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
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

//播放结束调用
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    [self removeNotice:notify];
    
    [self addNotice];
    [self.view addSubview:moviePlayer.view];
    
    [self.view addSubview:videoPic];
    [self.view addSubview:playBtn];
}

-(void)playVideo{
    [playBtn removeFromSuperview];
    [videoPic removeFromSuperview];
    [moviePlayer play];
}

-(void)stopPlay{
    
    [playBtn removeFromSuperview];
    [videoPic removeFromSuperview];
    [moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    
}

-(void)goPreviou{
    [super goPreviou];
    [self stopPlay];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"美女私房" hasLeftItem:YES hasRightItem:NO]];
    
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
//    int randomNumber = arc4random() % 10 ;//[0,100)包括0，不包括100
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    NSString* picName = [NSString stringWithFormat:@"%d.png",randomNumber];
//    [data setValue:picName forKey:@"pic"];
//    [data setValue:@"测试刷新数据" forKey:@"title"];
//    [data setValue:@"好像还不错哦！" forKey:@"desc"];
//    [data setValue:@"video" forKey:@"datatype"];
//    [data setValue:@"9527" forKey:@"clicknum"];
//    
//    [_girlsDataList insertObject:data atIndex:_girlsDataList.count];
    
    [videoTableView reloadData];
}


#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"私房推荐";
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    CGRect headFrame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
//    UIView *sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
//    sectionHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"con_bg@2x.jpg"]];
//    
//    return sectionHeadView;
//}


#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
    
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UINib *nibCell = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
    [tableView registerNib:nibCell forCellReuseIdentifier:@"VideoCell"];
    VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *videImg =[UIImage imageNamed:@"1.png"];
    [videoCell.videoPic setBackgroundImage:videImg forState:UIControlStateNormal];
    videoCell.videoTitle.text = @"真的很不错哦！！！";
    
    videoCell.videoDesc.text = @"dasdasdasdasdadsas";
    videoCell.clickNum.text = @"2222";
    return videoCell;
}




@end
