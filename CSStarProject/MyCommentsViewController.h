//
//  MyCommentsViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-11-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "NSDate+Category.h"
#import "ConvertJSONData.h"
#import "NSDateFormatter+Category.h"
#import "PeopleDetailViewController.h"
#import "userMessageCommentNewTableViewCell.h"

@interface MyCommentsViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>{
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cstarBtn;
@property (weak, nonatomic) IBOutlet UIButton *zcBtn;
- (IBAction)cstarBtnClick:(id)sender;
- (IBAction)zcBtnClick:(id)sender;

@end
