//
//  MyCommentsViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-11-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "UIViewController+HUD.h"
#import "ViewPassValueDelegate.h"
#import "NSDate+Category.h"
#import "ConvertJSONData.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "NSDateFormatter+Category.h"
#import "PeopleDetailViewController.h"
#import "userMessageCommentNewTableViewCell.h"

@interface MyCommentsViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cstarBtn;
@property (weak, nonatomic) IBOutlet UIButton *zcBtn;
@property (weak, nonatomic) IBOutlet UIView *myCommentBackView;
- (IBAction)cstarBtnClick:(id)sender;
- (IBAction)zcBtnClick:(id)sender;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
