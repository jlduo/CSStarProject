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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    commentTable.frame = CGRectMake(0, NAV_TITLE_HEIGHT + 69, SCREEN_WIDTH, MAIN_FRAME_H -  NAV_TITLE_HEIGHT -49); 
    [self.view addSubview:commentTable];
    
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"commentTableViewCell" bundle:nil];
    [commentTable registerNib:nibCell forCellReuseIdentifier:@"commentCell"];
    
    //默认类型 0、长沙星 1、众筹
    typeComment = 0;
    
    //获取数据
    [self getCommentList];
}

//长沙星按钮
-(void)changshaxing{
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star_on.png"];
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou.png"];
    typeComment = 0;
    [self getCommentList];
    [commentTable reloadData];
}

//众筹按钮
-(void)zhongchou{
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star.png"];
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou_on.png"];
    typeComment = 1;
    [self getCommentList];
    [commentTable reloadData];
}

//获取评论
-(void)getCommentList{
    NSString *userId = [StringUitl getSessionVal:LOGIN_USER_ID];
    ConvertJSONData *jsonData = [[ConvertJSONData alloc] init];
    if (typeComment == 0) {
        NSString *url = [[NSString alloc] initWithFormat:@"%@/Comment/GetCommentsByUserId/%@",REMOTE_URL,userId];
        tableArray = (NSMutableArray *)[jsonData requestData:url];
    } else{
        NSString *url = [[NSString alloc] initWithFormat:@"%@/CF/getTalksByUserId/%@",REMOTE_URL,userId];
        tableArray = (NSMutableArray *)[jsonData requestData:url];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
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
    [commentCell.btnDelete addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchDown];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return commentCell;
}

-(void)deleteComment:(UIButton *)sender{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"系统提示"message:@"确定删除？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
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
            [self showCustomAlert:@"删除失败！" widthType:WARNN_LOGO];
        }
    }else{
        //处理返回
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){
            [tableArray removeObjectAtIndex:currentIndex];
            [commentTable reloadData];
        }else{
            [self showCustomAlert:@"删除失败！" widthType:WARNN_LOGO];
        }
    }
}

- (void)requestLoginFailed:(ASIHTTPRequest *)req{
    [self showCustomAlert:@"删除失败！" widthType:WARNN_LOGO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray .count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
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
    
    StoryDetailViewController *detailController = [[StoryDetailViewController alloc] init];
    delegate = detailController;
    [delegate passValue:rowId];
    [self.navigationController pushViewController:detailController animated:YES];
}

-(void)showCustomAlert:(NSString *)msg widthType:(NSString *)tp{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tp]];
    HUD.customView = imgView;
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    HUD.dimBackground = YES;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:NO  leftIcon:nil rightIcon:nil]];
}

-(void)goPreviou{
    [super goPreviou];
}
@end
