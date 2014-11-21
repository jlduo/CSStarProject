//
//  GirlsInfoViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-11-21.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "GirlsCollectionCell.h"
#import "GirlsCollectionHeadView.h"
#import "InitTabBarViewController.h"
#import "GirlsPhotoListViewController.h"
#import "ViewPassValueDelegate.h"

@interface GirlsInfoViewController : CommonViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@property (weak, nonatomic) IBOutlet UICollectionView *girlsCollectionView;
#pragma mark 美女私房数据
@property(nonatomic,retain)NSMutableArray *girlsDataList;

@end
