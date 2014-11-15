//
//  MyProjectListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-10-20.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//
#import "ProjectTableViewCell.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "PeopleDetailViewController.h"

@interface MyProjectListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>
#pragma mark 回填数据
@property(nonatomic,retain)NSMutableArray *peopleProList;
@property(nonatomic,weak) NSObject<ViewPassValueDelegate> *passValelegate;

@property (weak, nonatomic) IBOutlet UITableView *myProjectListTable;
@property (weak, nonatomic) IBOutlet UIImageView *likeIconView;
@property (weak, nonatomic) IBOutlet UIImageView *supportIconView;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorIconView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtnView;
@property (weak, nonatomic) IBOutlet UIButton *supportBtnView;
@property (weak, nonatomic) IBOutlet UIButton *sponsorBtnView;
- (IBAction)clickLikeBtn:(id)sender;
- (IBAction)clickSupportBtn:(id)sender;
- (IBAction)clickSponsorBtn:(id)sender;

@end
