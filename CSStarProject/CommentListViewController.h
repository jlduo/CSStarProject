//
//  CommentListViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-11.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CommonViewController.h"
#import "CommentTableListCell.h"
#import "ViewPassValueDelegate.h"
#import "DateUtil.h"

@interface CommentListViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,ViewPassValueDelegate>{
    
        NSMutableDictionary *headerData;//文章初始数据
        NSMutableArray *commentArray;//评论集合数据
    
        // 声明一个参数传递代理
        NSObject<ViewPassValueDelegate> *passValelegate;
    
}

@end
