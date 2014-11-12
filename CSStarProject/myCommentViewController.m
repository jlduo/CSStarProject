//
//  myCommentViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-9.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "myCommentViewController.h"

@interface myCommentViewController (){
    UIImageView *imgchangshaxing;
    UIImageView *imgzhongchou;
    UITableView *commentTable;
    NSInteger typeComment;
    NSMutableArray *tableArray;
    NSInteger currentIndex;
}

@end

@implementation myCommentViewController


-(void)dealloc{
    NSLog(@"go dealloc....");
    [self releaseDMemery];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear....");
    [super viewDidDisappear:YES];
    [self releaseDMemery];
}

-(void)releaseDMemery{
    NSLog(@"releaseDMemery....");
    imgchangshaxing = nil;
    imgzhongchou = nil;
    commentTable = nil;
    tableArray = nil;
}

- (void)viewDidLoad
{
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [StringUitl colorWithHexString:CONTENT_BACK_COLOR];
    
    //长沙星
    imgchangshaxing = [[UIImageView alloc] init];
    imgchangshaxing.frame = CGRectMake(50, 69, 35, 35);
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star_on.png"];
    [self.view addSubview:imgchangshaxing];
    
    UIButton *changshaxing = [[UIButton alloc] init];
    [changshaxing setTitle:@"长沙星" forState:UIControlStateNormal];
    [changshaxing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changshaxing.titleLabel.font = main_font(16);
    changshaxing.frame = CGRectMake(80, 69, 50, 35);
    [changshaxing addTarget:self action:@selector(changshaxing) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:changshaxing];
    
    //分割线
    UIImageView *imgSpl = [[UIImageView alloc] init];
    imgSpl.frame = CGRectMake(165, 80, 1, 14);
    imgSpl.image = [UIImage imageNamed:@"homeplaynumbg.png"];
    [self.view addSubview:imgSpl];
    
    //众筹
    imgzhongchou =[[UIImageView alloc] init];
    imgzhongchou.frame = CGRectMake(198, 69, 35, 35);
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou.png"];
    [self.view addSubview:imgzhongchou];
    
    UIButton *zhongchou = [[UIButton alloc] init];
    [zhongchou setTitle:@"众筹" forState:UIControlStateNormal];
    [zhongchou setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    zhongchou.titleLabel.font = main_font(16);
    zhongchou.frame = CGRectMake(220, 69, 50, 35);
    [zhongchou addTarget:self action:@selector(zhongchou) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:zhongchou];
    
    //评论列表
    commentTable = [[UITableView alloc] init];
    commentTable.delegate = self;
    commentTable.dataSource = self;
    [commentTable setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]]];
    commentTable.frame = CGRectMake(0, NAV_TITLE_HEIGHT + 69, SCREEN_WIDTH, MAIN_FRAME_H -  NAV_TITLE_HEIGHT -49); 
    [self.view addSubview:commentTable];
    
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"userMessageCommentNewTableViewCell" bundle:nil];
    [commentTable registerNib:nibCell forCellReuseIdentifier:@"userMessageCommentNewCell"];
    
    //默认类型 0、长沙星 1、众筹
    typeComment = 0;
    
    //获取数据
    [self getCommentList];
}

//长沙星按钮
-(void)changshaxing{
    [self showLoading:@"加载中..."];
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star_on.png"];
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou.png"];
    typeComment = 0;
    [self getCommentList];
    [commentTable reloadData];
}

//众筹按钮
-(void)zhongchou{
    [self showLoading:@"加载中..."];
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star.png"];
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou_on.png"];
    typeComment = 1;
    [self getCommentList];
    [commentTable reloadData];
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
    //处理路劲
    NSURL *reqUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:reqUrl];
    //设置代理
    [request setDelegate:self];
    [request startAsynchronous];
    [request setTag:type];
    
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSData *respData = [request responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *returnArr = (NSArray *)jsonDic;
    if(returnArr!=nil && returnArr.count>0){
        tableArray = [NSMutableArray arrayWithArray:returnArr];
    }else{
        tableArray = [[NSMutableArray alloc]init];
    }
    
    [commentTable reloadData];
    [self hideHud];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [self hideHud];
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    userMessageCommentNewTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"userMessageCommentNewCell"];
    NSDictionary *dicComment = [tableArray  objectAtIndex:indexPath.row];
    
    if(typeComment == 0){
        DateUtil *utilDate = [[DateUtil alloc] init];
        NSString *addTime = [utilDate getLocalDateFormateUTCDate1:[dicComment valueForKey:@"_add_time"]];
        commentCell.lblTime.text = addTime;
        
        commentCell.lblTitle.text = [dicComment valueForKey:@"_article_title"]; 
        commentCell.lblContent.text = [dicComment valueForKey:@"_content"];
        commentCell.btnDelete.tag = indexPath.row;
    }
    else {
        DateUtil *utilDate = [[DateUtil alloc] init];
        NSString *addTime = [utilDate getLocalDateFormateUTCDate2:[dicComment valueForKey:@"addTime"]];
        commentCell.lblTime.text = addTime;
        
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
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"确定删除？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
    currentIndex = sender.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dicComment = [tableArray objectAtIndex:currentIndex]; 
        if (typeComment == 0) {
            NSString *url = [[NSString alloc] initWithFormat:@"%@/Comment/DeleteComment/%@",REMOTE_URL,[dicComment valueForKey:@"_id"]];
            NSURL *request_url = [NSURL URLWithString:url];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:request_url];
            [ASIHTTPRequest setSessionCookies:nil];
            
            [request setUseCookiePersistence:YES];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setStringEncoding:NSUTF8StringEncoding];
            [request buildPostBody];
            
            [request startAsynchronous];
            [request setDidFailSelector:@selector(requestLoginFailed:)];
            [request setDidFinishSelector:@selector(requestLoginFinished:)];
        }else{
            NSString *url = [[NSString alloc] initWithFormat:@"%@/AndroidApi/CFService/deleteTalk",REMOTE_URL];
            NSURL *request_url = [NSURL URLWithString:url];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:request_url];
            [ASIHTTPRequest setSessionCookies:nil];
            
            [request setUseCookiePersistence:YES];
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            [request setStringEncoding:NSUTF8StringEncoding];
            
            [request setPostValue:[dicComment valueForKey:@"id"] forKey:@"Id"];
            
            [request buildPostBody];
            
            [request startAsynchronous];
            [request setDidFailSelector:@selector(requestLoginFailed:)];
            [request setDidFinishSelector:@selector(requestLoginFinished:)];
        }
    }
}

//请求完成
- (void)requestLoginFinished:(ASIHTTPRequest *)req{
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if (typeComment == 0) {
        //处理返回
        if([[jsonDic valueForKey:@"result"] isEqualToString:@"True"]){
            [tableArray removeObjectAtIndex:currentIndex];
            [commentTable reloadData];
        }else{
            [self showCAlert:@"删除失败！" widthType:WARNN_LOGO];
        }
    }else{
        //处理返回
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){
            [tableArray removeObjectAtIndex:currentIndex];
            [commentTable reloadData];
        }else{
            [self showCAlert:@"删除失败！" widthType:WARNN_LOGO];
        }
    }
}

- (void)requestLoginFailed:(ASIHTTPRequest *)req{
    [self showCAlert:@"删除失败！" widthType:WARNN_LOGO];
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
    NSString *rowId = [row valueForKey:@"_article_id"];
    
    if(typeComment==0){
        StoryDetailViewController *detailController = [[StoryDetailViewController alloc] init];
        delegate = detailController;
        [delegate passValue:rowId];
        [self.navigationController pushViewController:detailController animated:YES];
    }else{
        PeopleDetailViewController *deatilViewController = [[PeopleDetailViewController alloc]init];
        delegate = deatilViewController;
        [delegate passValue:[row valueForKey:@"projectId"]];
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
@end
