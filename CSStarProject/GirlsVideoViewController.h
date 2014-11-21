//
//  GirlsVideoViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-5.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "common.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UILabel+ContentSize.h"
#import "AllAroundPullView.h"
#import "UIViewController+HUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoTableViewCell.h"
#import "CommonViewController.h"
#import "ViewPassValueDelegate.h"
#import "ConvertJSONData.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+ShareMessage.h"

@interface GirlsVideoViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,
ViewPassValueDelegate,UITextViewDelegate> {
    // 声明一个参数传递代理
    __weak NSObject<ViewPassValueDelegate> *passValelegate;
}
@property (weak, nonatomic) IBOutlet UITableView *girlsVideoTable;

@end
