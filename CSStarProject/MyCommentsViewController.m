//
//  MyCommentsViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-11-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "MyCommentsViewController.h"

@interface MyCommentsViewController (){
    NSInteger typeComment;
    NSMutableArray *tableArray;
    NSInteger currentIndex;
    
    //处理相册变量
    NSString * artId;
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
    NSMutableArray *thumb_ImageArr;
    NSMutableDictionary *totalData;
    MWPhoto *photo;
    
}

@end

@implementation MyCommentsViewController

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
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    [self getCommentList];
    
    self.commentsTableView.rowHeight = 80;
    self.commentsTableView.showsVerticalScrollIndicator = NO;
    self.commentsTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    [StringUitl setViewBorder:self.myCommentBackView withColor:@"#cccccc" Width:0.5f];
    
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"userMessageCommentNewTableViewCell" bundle:nil];
    [self.commentsTableView registerNib:nibCell forCellReuseIdentifier:@"userMessageCommentNewCell"];
    
    //默认类型 0、长沙星 1、众筹
    typeComment = 0;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController hiddenDIYTaBar];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//获取评论
-(void)getCommentList{
    NSString *url;
    NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
    if (typeComment == 0) {
        url = [[NSString alloc] initWithFormat:@"%@/Comment/GetCommentsByUserId/%@",REMOTE_URL,userId];
    } else{
        url = [[NSString alloc] initWithFormat:@"%@/CF/getTalksByUserId/%@",REMOTE_URL,userId];
    }
    [self requestDataByUrl:url withType:1];
}

-(void)requestDataByUrl:(NSString *)url withType:(int)type{
    
    [HttpClient GET:url
         parameters:nil
             isjson:TRUE
            success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSArray *returnArr = (NSArray *)responseObject;
         if(returnArr!=nil && returnArr.count>0){
             [self hideHud];
             tableArray = [NSMutableArray arrayWithArray:returnArr];
         }else{
             tableArray = [[NSMutableArray alloc]init];
             [self hideHud];
             
             UIView *blankView = [[UIView alloc]init];
             self.commentsTableView.tableFooterView = blankView;
             [self showNo:@"暂无数据!"];
         }
         [self.commentsTableView reloadData];
         
         
     }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self requestFailed:error];
         
     }];
    
}

//处理相册信息
-(void)loadGirlPics:(NSString *)articleId{
    
    totalData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *perData = [[NSMutableDictionary alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_PHOTO_LIST,articleId];
    NSMutableArray *jsonArr = (NSMutableArray *)[ConvertJSONData requestData:url];
    if(jsonArr!=nil){
        
        imageArr = [[NSMutableArray alloc]init];
        thumb_ImageArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in jsonArr) {
            
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dic valueForKey:@"_original_path"]]];
            photo.caption = [dic valueForKey:@"_remark"];
            [imageArr addObject:photo];
            
            photo = nil;
            
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[dic valueForKey:@"_thumb_path"]]];
            [thumb_ImageArr addObject:photo];
            
            
        }
        
        //以每条文章信息的ID保存信息
        [perData setObject:imageArr forKey:@"imageArr"];//大图
        [perData setObject:thumb_ImageArr forKey:@"thumb_ImageArr"];//小图
        
        [totalData setObject:perData forKey:articleId];
        
        NSLog(@"totalData=%@",totalData);
        
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dicComment = [tableArray  objectAtIndex:indexPath.row];
    static BOOL isNibregistered = NO;
    if(!isNibregistered){
        UINib *nibCell = [UINib nibWithNibName:@"userMessageCommentNewTableViewCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:@"userMessageCommentNewCell"];
        isNibregistered = YES;
    }
    userMessageCommentNewTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"userMessageCommentNewCell"];
    
    NSString *dateStr;
    NSString *dateStr1;
    if(typeComment == 0){
        dateStr = [dicComment valueForKey:@"_add_time"];
        if(dateStr.length>10){
            dateStr1 = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            dateStr1 = [dateStr1 substringToIndex:16];
        }
        commentCell.lblTime.text = dateStr1;
        commentCell.lblTitle.text = [dicComment valueForKey:@"_article_title"];
        commentCell.lblContent.text = [dicComment valueForKey:@"_content"];
        commentCell.btnDelete.tag = indexPath.row;
    } else {
        
        dateStr = [dicComment valueForKey:@"addTime"];
        if(dateStr.length>10){
            dateStr1 = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            dateStr1 = [dateStr1 substringToIndex:16];
        }
        commentCell.lblTime.text = dateStr1;
        commentCell.lblTitle.text = [dicComment valueForKey:@"projectName"];
        commentCell.lblContent.text = [dicComment valueForKey:@"content"];
        commentCell.btnDelete.tag = indexPath.row;
    }
    //评论内容自适应
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake( commentCell.lblContent.frame.size.width,2000);
    CGSize labelsize = [commentCell.lblContent.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
    if (labelsize.height > 20) {
        commentCell.lblContent.frame = CGRectMake(commentCell.lblContent.frame.origin.x,commentCell.lblContent.frame.origin.y, commentCell.lblContent.frame.size.width, labelsize.height);
    }
    [commentCell.btnDelete addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchDown];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return commentCell;
}

-(void)deleteComment:(UIButton *)sender{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"确定删除评论吗？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    currentIndex = sender.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showLoading:@"正在删除..."];
        
        NSString *url;
        NSDictionary *parameters;
        NSDictionary *dicComment = [tableArray objectAtIndex:currentIndex];
        if (typeComment == 0) {
            url = [[NSString alloc] initWithFormat:@"%@/Comment/DeleteComment/%@",REMOTE_URL,[dicComment valueForKey:@"_id"]];
            
        }else{
            
            url = [[NSString alloc] initWithFormat:@"%@/AndroidApi/CFService/deleteTalk",REMOTE_URL];
            parameters = @{@"Id":[dicComment valueForKey:@"id"]};
            
        }
        
        [HttpClient POST:url
              parameters:nil
                  isjson:TRUE
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary *jsonDic = [StringUitl getDicFromData:responseObject];
             if (typeComment == 0) {
                 //处理返回
                 if([[jsonDic valueForKey:@"result"] isEqualToString:@"True"]){
                     [tableArray removeObjectAtIndex:currentIndex];
                     [self.commentsTableView reloadData];
                     [self hideHud];
                     [self showOk:@"删除成功！"];
                     
                 }else{
                     [self hideHud];
                     [self showNo:@"删除失败！"];
                 }
             }else{
                 //处理返回
                 if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){
                     [tableArray removeObjectAtIndex:currentIndex];
                     [self.commentsTableView reloadData];
                     
                     [self hideHud];
                     [self showOk:@"删除成功！"];
                 }else{
                     [self hideHud];
                     [self showNo:@"删除失败！"];
                 }
             }
             
             
         }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self requestFailed:error];
             
         }];
    }
}


- (void)requestFailed:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:ERROR_INNER];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray .count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    userMessageCommentNewTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"userMessageCommentNewCell"];
    NSDictionary *dicComment = [tableArray  objectAtIndex:indexPath.row];
    NSString *commnetContent = @"内容";
    if (typeComment == 0) {
        commnetContent =  [dicComment valueForKey:@"_content"];
    } else {
        commnetContent =  [dicComment valueForKey:@"content"];
    }
    
    //评论内容自适应
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(commentCell.lblContent.frame.size.width,2000);
    CGSize labelsize = [commnetContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if (labelsize.height > 20) {
        return  57 + labelsize.height;
    }
    else{
        return 77;
    }
}

//行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *row = [tableArray objectAtIndex:indexPath.row];
    artId = [[row valueForKey:@"_article_id"] stringValue];
    NSString *category_index = [row valueForKey:@"_category_call_index"];
    if(typeComment==0){

        if ([category_index isEqualToString:@"albums"]) {//相册
            
            [self loadGirlPics:artId];
            [self goPhotoView:artId];
            
        } else if ([category_index isEqualToString:@"city"]) {//文章
            
            [self goArticelView:artId];
            
        } else {//视频
            
            [self goVideoView:artId];
            
        }
        
    }else{
        PeopleDetailViewController *deatilViewController =  (PeopleDetailViewController *)[self getVCFromSB:@"peopleDetail"];
        passValelegate = deatilViewController;
        [passValelegate passValue:[row valueForKey:@"projectId"]];
        [self.navigationController pushViewController:deatilViewController animated:YES];
    }
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:NO  leftIcon:nil rightIcon:nil]];
}

-(void)goPreviou{
    [super goPreviou];
}

- (IBAction)cstarBtnClick:(id)sender {
    [self showLoading:@"加载中..."];
    [self.zcBtn setImage:[UIImage imageNamed:@"mydiscu_zhongchou.png"] forState:UIControlStateNormal];
    [self.cstarBtn setImage:[UIImage imageNamed:@"mydiscu_star_on.png"] forState:UIControlStateNormal];
    typeComment = 0;
    [self getCommentList];
    
}

- (IBAction)zcBtnClick:(id)sender {
    [self showLoading:@"加载中..."];
    [self.zcBtn setImage:[UIImage imageNamed:@"mydiscu_zhongchou_on.png"] forState:UIControlStateNormal];
    [self.cstarBtn setImage:[UIImage imageNamed:@"mydiscu_star.png"] forState:UIControlStateNormal];
    typeComment = 1;
    [self getCommentList];
}


-(void)goVideoView:(NSString *)articleId{
    
    GirlsVideoViewController *girlVideoView = (GirlsVideoViewController*)[self getVCFromSB:@"girlsVideo"];
    passValelegate = girlVideoView;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:girlVideoView animated:YES];
    
}

-(void)goArticelView:(NSString *)articleId{
    
    StoryDetailViewController *storyDetail = (StoryDetailViewController *)[self getVCFromSB:@"storyDetail"];
    passValelegate = storyDetail;
    [passValelegate passValue:articleId];
    [self.navigationController pushViewController:storyDetail animated:YES];
    
}

-(void)goPhotoView:(NSString *)articleId{
    
    
    self.photos = [[totalData valueForKey:articleId] valueForKey:@"imageArr"];
    self.thumbs = [[totalData valueForKey:articleId] valueForKey:@"thumb_ImageArr"];
    
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
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:nc animated:YES completion:nil];
    
    self.tabBarController.tabBar.hidden = YES;
    InitTabBarViewController *tabBarController = (InitTabBarViewController *)self.tabBarController;
    [tabBarController hiddenDIYTaBar];
    
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
    
    NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
    if ([self isEmpty:userId]) {
        LoginViewController *login = (LoginViewController *)[self getVCFromSB:@"userLogin"];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }else{
        StoryCommentViewController *storyComment = (StoryCommentViewController *)[self getVCFromSB:@"storyComment"];
        passValelegate = storyComment;
        [passValelegate passValue:artId];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:@"xc" forKey:@"stype"];
        [passValelegate passDicValue:param];
        
        [self.navigationController pushViewController:storyComment animated:YES];
    }
    
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%d / %d", index+1,_photos.count];
}


@end
