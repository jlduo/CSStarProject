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

-(void)dealloc{
    tableArray = nil;
}

- (void)viewDidLoad
{
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    [self getCommentList];
    
    self.commentsTableView.rowHeight = 80;
    self.commentsTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    
    //注册单元格
    UINib *nibCell = [UINib nibWithNibName:@"userMessageCommentNewTableViewCell" bundle:nil];
    [self.commentsTableView registerNib:nibCell forCellReuseIdentifier:@"userMessageCommentNewCell"];
    
    //默认类型 0、长沙星 1、众筹
    typeComment = 0;

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
    [self.commentsTableView reloadData];
    [self hideHud];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [self hideHud];
    NSError *error = [request error];
    NSLog(@"jsonDic->%@",error);
    
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
            [self.commentsTableView reloadData];
        }else{
            [self showCAlert:@"删除失败！" widthType:WARNN_LOGO];
        }
    }else{
        //处理返回
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"true"]){
            [tableArray removeObjectAtIndex:currentIndex];
            [self.commentsTableView reloadData];
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
        passValelegate = detailController;
        [passValelegate passValue:rowId];
        [self.navigationController pushViewController:detailController animated:YES];
    }else{
        PeopleDetailViewController *deatilViewController = [[PeopleDetailViewController alloc]init];
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
@end
