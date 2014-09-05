//
//  UserInfoViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-4.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserTableViewCell.h"
#import "UserSmallTableViewCell.h"
#import "UserBigTableViewCell.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIImage *cellImg;
    NSString *imgName;
    NSString *cellTitle;
    
    UITableView *stableView;
    NSMutableDictionary *_userDictionay;
    
    UIView *bgView;
    UIView *sheetView;
}


@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUserDicData];
     //加入导航
    //[self setNavgationBar];
    
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-64-49);

    stableView = [[UITableView alloc] initWithFrame:tframe];
    stableView.delegate = self;
    stableView.dataSource = self;
    
    [stableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"con_bg@2x.jpg"]]];
    stableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [stableView setTableFooterView:view];
    
    //处理头部信息
    [self.view addSubview:stableView];
    
    //处理actionSheet
    CGRect frameRect = CGRectMake(MAIN_FRAME_X, MAIN_FRAME_H, SCREEN_WIDTH, 200);
    sheetView = [[UIView alloc]initWithFrame:frameRect];
    sheetView.backgroundColor = [UIColor whiteColor];
    
    UIButton *pzBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, SCREEN_WIDTH-80,35)];
    pzBtn.backgroundColor = [UIColor redColor];
    [pzBtn setTitle:@"拍 照" forState:UIControlStateNormal];
    [pzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pzBtn.layer.masksToBounds = YES;
    pzBtn.layer.cornerRadius = 3.5;
    
    [pzBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchDown];
    
    
    UIButton *tpBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 65, SCREEN_WIDTH-80,35)];
    tpBtn.backgroundColor = [UIColor redColor];
    [tpBtn setTitle:@"从相册选择照片" forState:UIControlStateNormal];
    [tpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tpBtn.layer.masksToBounds = YES;
    tpBtn.layer.cornerRadius = 3.5;
    
    [tpBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchDown];
    
    UIButton *ceBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, SCREEN_WIDTH-80,35)];
    ceBtn.backgroundColor = [UIColor darkGrayColor];
    [ceBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [ceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ceBtn.layer.masksToBounds = YES;
    ceBtn.layer.cornerRadius = 3.5;
    
    [ceBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [sheetView addSubview:pzBtn];
    [sheetView addSubview:tpBtn];
    [sheetView addSubview:ceBtn];
    
    
    //[self.view addSubview:sheetView];
    

}


-(void)setUserDicData{
    
    _userDictionay = [[NSMutableDictionary alloc]init];
    [_userDictionay setValue:@"4.png" forKey:@"user_pic"];
    [_userDictionay setValue:@"独孤求败" forKey:@"nick_name"];
    [_userDictionay setValue:@"13787047370" forKey:@"mobile_num"];
    [_userDictionay setValue:@"湖南 长沙" forKey:@"country"];
    [_userDictionay setValue:@"男" forKey:@"sex"];
    NSLog(@"userDic==%@",_userDictionay);
    
}


-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, SCREEN_WIDTH, NAV_TITLE_HEIGHT)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"个人信息"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];

}


-(void)goPreviou{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"个人信息" hasLeftItem:YES hasRightItem:NO]];
    
}

#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
       return 10;
    }else{
       return 15;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGRect headFrame;
    UIView *sectionHeadView;
    if(section==0){
       headFrame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    }else{
       headFrame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
    }
    sectionHeadView = [[UIView alloc]initWithFrame:headFrame];
    sectionHeadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"con_bg@2x.jpg"]];
    
    return sectionHeadView;
}


#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
       return 3;
    }else{
       return 2;
    }
}

#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0) {
        return 100;
    }else{
        return 50;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"2232342342");
    if(indexPath.section==0){
        switch (indexPath.row) {
            case 0:
                //调用action sheet
                [self showSheet];
                
                break;
            case 1:
               
                
                break;
            case 2:

                
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                
                break;
                
            default:
                break;
        }

    }
}

- (void)showSheet{
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(MAIN_FRAME_X, MAIN_FRAME_Y-20, MAIN_FRAME_W, MAIN_FRAME_H+64)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.7];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.png"]];
    imageView.frame = CGRectMake((SCREEN_WIDTH-160)/2, 90, 160, 160);
    imageView.layer.masksToBounds =YES;
    imageView.layer.cornerRadius =80;
    
    //[bgView addSubview:imageView];
    [self.view addSubview:bgView];
    [self.view addSubview:sheetView];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        CGPoint tempCenter = sheetView.center;
        if (sheetView.frame.origin.y == MAIN_FRAME_H) {
            tempCenter.y -= sheetView.bounds.size.height;
        } else {
            tempCenter.y += sheetView.bounds.size.height;
        }
        sheetView.center = tempCenter;
    }];
    
}

-(void)cancelBtnClick{
    
    [UIView animateWithDuration:0.35 animations:^{
        [bgView removeFromSuperview];
        CGPoint tempCenter = sheetView.center;
        tempCenter.y += sheetView.bounds.size.height;
        sheetView.center = tempCenter;
    }];

}

//选择相册图片
-(void)photoBtnClick{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentModalViewController:pickerImage animated:YES];
        
    }

}

//点击拍照按钮
-(void)cameraBtnClick{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
         sourceType = UIImagePickerControllerSourceTypeCamera;
        //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
        //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
        //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];//进入照相界面
    }
}


-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Action Sheet选择项"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        if(indexPath.row==0){
            UINib *nibCell = [UINib nibWithNibName:@"UserBigTableViewCell" bundle:nil];
            [stableView registerNib:nibCell forCellReuseIdentifier:@"UserBigCell"];
            UserBigTableViewCell *bigCell= [stableView dequeueReusableCellWithIdentifier:@"UserBigCell"];
            //处理圆形图片
            cellImg = [UIImage imageNamed:[_userDictionay valueForKey:@"user_pic"]];
            [bigCell.bigCellPic setImage:cellImg];
            
            bigCell.bigCellPic.frame = CGRectMake(10,5, 90, 90);
            bigCell.bigCellPic.layer.masksToBounds =YES;
            bigCell.bigCellPic.layer.cornerRadius =45;
            bigCell.bigCellTitle.text = @"更改头像";
            
            return bigCell;
        }else{
            
            UINib *nibCell = [UINib nibWithNibName:@"UserSmallTableViewCell" bundle:nil];
            [stableView registerNib:nibCell forCellReuseIdentifier:@"UserSmallCell"];
            UserSmallTableViewCell *smallCell1= [stableView dequeueReusableCellWithIdentifier:@"UserSmallCell"];
            
            switch (indexPath.row) {
                case 1:
                    smallCell1.smallCellValue.text =[_userDictionay valueForKey:@"country"];
                    NSLog(@"nick_name==%@",[_userDictionay valueForKey:@"country"]);
                    smallCell1.smallCellTitle.text =@"我的昵称";
                    break;
                case 2:
                    smallCell1.smallCellValue.text =[_userDictionay valueForKey:@"mobile_num"];
                    smallCell1.smallCellTitle.text =@"手机号码";
                    NSLog(@"mobile_num==%@",[_userDictionay valueForKey:@"mobile_num"]);
                    break;
                default:
                    break;
            }
            
            return smallCell1;
            
        }

        
        
    }else{//section
        
        UINib *nibCell = [UINib nibWithNibName:@"UserSmallTableViewCell" bundle:nil];
        [stableView registerNib:nibCell forCellReuseIdentifier:@"UserSmallCell"];
        UserSmallTableViewCell *smallCell= [stableView dequeueReusableCellWithIdentifier:@"UserSmallCell"];
        switch (indexPath.row) {
            case 0:
                smallCell.smallCellValue.text =[_userDictionay valueForKey:@"sex"];
                smallCell.smallCellTitle.text =@"性别";
                break;
            case 1:
                smallCell.smallCellValue.text =[_userDictionay valueForKey:@"country"];
                smallCell.smallCellTitle.text =@"地区";
                break;
            default:
                break;
        }
        return smallCell;
    }
}

@end
