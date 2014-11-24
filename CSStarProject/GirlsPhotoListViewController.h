//
//  GirlsPhotoListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-11-21.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "CommonViewController.h"
#import "InitTabBarViewController.h"
#import "ViewPassValueDelegate.h"
#import "GirlsPhotoCollectionCell.h"

@interface GirlsPhotoListViewController : CommonViewController<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate,ViewPassValueDelegate>{
    // 声明一个参数传递代理
    NSObject<ViewPassValueDelegate> *passValelegate;
}

@property (weak, nonatomic) IBOutlet UICollectionView *girlsPhotoTableView;
#pragma mark 美女私房数据
@property(nonatomic,retain)NSMutableArray *girlsPhotoList;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
