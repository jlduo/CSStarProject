//
//  EditCityViewController.h
//  CSStarProject
//
//  Created by jialiduo on 14-9-18.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "CommonViewController.h"

@interface EditCityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cityBg;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (strong, nonatomic) NSString *cityValue;
@property (strong, nonatomic) NSString *provinceValue;

@property (weak, nonatomic) IBOutlet UIPickerView *cityPciker;
@property (copy,nonatomic) NSMutableArray *cityArray;//城市数据
@property (copy,nonatomic) NSMutableArray *cityArray1;//城市数据
@property (copy,nonatomic) NSMutableArray *provinceArray;//省份数据
@property (copy,nonatomic) NSMutableArray *provinceArray1;//省份数据


@end
