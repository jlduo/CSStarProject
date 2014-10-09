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
    NSArray *tableArray;
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
    imgchangshaxing.frame = CGRectMake(55, 69, 35, 35);
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star_on.png"];
    [self.view addSubview:imgchangshaxing];
    
    UIButton *changshaxing = [[UIButton alloc] init];
    [changshaxing setTitle:@"长沙星" forState:UIControlStateNormal];
    [changshaxing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changshaxing.titleLabel.font = main_font(16);
    changshaxing.frame = CGRectMake(85, 69, 50, 35);
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
    commentTable.backgroundColor = [UIColor redColor];
    [self.view addSubview:commentTable];
    
    //默认类型 0、长沙星 1、众筹
    typeComment = 0;
}

//长沙星按钮
-(void)changshaxing{
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star_on.png"];
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou.png"];
    typeComment = 0;
}

//众筹按钮
-(void)zhongchou{
    imgchangshaxing.image = [UIImage imageNamed:@"mydiscu_star.png"];
    imgzhongchou.image = [UIImage imageNamed:@"mydiscu_zhongchou_on.png"];
    typeComment = 1;
}

//获取评论
-(void)getCommentList{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoryCommentTableCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"storyCommentCell"];
    return commentCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray .count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"评论列表" hasLeftItem:YES hasRightItem:NO  leftIcon:nil rightIcon:nil]];
}

-(void)goPreviou{
    [super goPreviou];
}
@end
