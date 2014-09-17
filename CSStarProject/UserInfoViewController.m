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
    
    UserBigTableViewCell *bigCell;
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
    CGRect frameRect = CGRectMake(MAIN_FRAME_X, MAIN_FRAME_H+20, SCREEN_WIDTH, 200);
    sheetView = [[UIView alloc]initWithFrame:frameRect];
    sheetView.backgroundColor = [UIColor whiteColor];
    
    UIButton *pzBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-60,45)];
    pzBtn.backgroundColor = [UIColor redColor];
    [pzBtn setTitle:@"拍 照" forState:UIControlStateNormal];
    [pzBtn setTitle:@"拍 照" forState:UIControlStateHighlighted];
    [pzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pzBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    pzBtn.layer.masksToBounds = YES;
    pzBtn.layer.cornerRadius = 3.5;
    
    [pzBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchDown];
    
    
    UIButton *tpBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 75, SCREEN_WIDTH-60,45)];
    tpBtn.backgroundColor = [UIColor redColor];
    [tpBtn setTitle:@"从相册选择照片" forState:UIControlStateNormal];
    [tpBtn setTitle:@"从相册选择照片" forState:UIControlStateHighlighted];
    [tpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    tpBtn.layer.masksToBounds = YES;
    tpBtn.layer.cornerRadius = 3.5;
    
    [tpBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchDown];
    
    UIButton *ceBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 130, SCREEN_WIDTH-60,45)];
    ceBtn.backgroundColor = [UIColor darkGrayColor];
    [ceBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [ceBtn setTitle:@"取 消" forState:UIControlStateHighlighted];
    [ceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    ceBtn.layer.masksToBounds = YES;
    ceBtn.layer.cornerRadius = 3.5;
    
    [ceBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [sheetView addSubview:pzBtn];
    [sheetView addSubview:tpBtn];
    [sheetView addSubview:ceBtn];
    
    
    //[self.view addSubview:sheetView];
    

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarController.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H);
    [stableView setFrame:temFrame];
    
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
    [self.view addSubview:[self setNavBarWithTitle:@"个人信息" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
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
        NSLog(@"y=%f",sheetView.frame.origin.y);
        NSLog(@"y=%f",MAIN_FRAME_H);
        if (sheetView.frame.origin.y == MAIN_FRAME_H+20) {
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
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];

}

//点击拍照按钮
-(void)cameraBtnClick{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.sourceType = sourceType;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
        [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
        NSLog(@"保存头像！");
    //[userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //[userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    bigCell.bigCellPic.image = selfPhoto;
    [self uploadUserLogo:imageFilePath];
    //处理完图片关闭窗口
    [self cancelBtnClick];
}


//上传用户头像
-(BOOL)uploadUserLogo:(NSString *)imageUrl{
    if([StringUitl isEmpty:imageUrl]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        imageUrl = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    }
    
    NSLog(@"imageUrl->>%@",imageUrl);
    
    NSURL *uploadImgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,UPLOAD_IMG_URL]];
    NSLog(@"uploadImgUrl->>%@",uploadImgUrl);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:uploadImgUrl];
    [ASIHTTPRequest setSessionCookies:nil];
    
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    //上传图片
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imageUrl];
    if(imageData==nil){
        return FALSE;
    }
    NSString *base64Str = [imageData base64Encoding];
    NSLog(@"base64Str->>%@",base64Str);
    [request setPostValue:@"jpg" forKey:@"fileExt"];
    [request setPostValue:base64Str forKey:@"base64"];
    [request setPostValue:@"username" forKey:[StringUitl getSessionVal:LOGIN_USER_NAME]];
    [request buildPostBody];
    [request startAsynchronous];
    
    [request setDidFailSelector:@selector(uploadFailed:)];
    [request setDidFinishSelector:@selector(uploadFinished:)];
    

    return YES;
}

- (void)uploadFinished:(ASIHTTPRequest *)req
{
    
    NSLog(@"upload->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//上传失败
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//上传成功
        
        //存储头像信息
        [self loadUserInfo:[StringUitl getSessionVal:LOGIN_USER_NAME]];
        
    }
    
}

- (void)uploadFailed:(ASIHTTPRequest *)req
{
    
    [StringUitl alertMsg:@"请求数据失败！" withtitle:@"错误提示"];
}

//获取用户信息
-(void)loadUserInfo:(NSString *)userName{
    if([StringUitl isNotEmpty:userName]){
        
        NSURL *getUserUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?username=%@",REMOTE_URL,USER_CENTER_URL,userName]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:getUserUrl];
        [ASIHTTPRequest setSessionCookies:nil];
        
        [request setUseCookiePersistence:YES];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];
        [request setStringEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        [request setDidFailSelector:@selector(uploadFailed:)];
        [request setDidFinishSelector:@selector(getUserInfoFinished:)];
        
    }
}

- (void)getUserInfoFinished:(ASIHTTPRequest *)req
{
    
    NSLog(@"getUserInfo->%@",[req responseString]);
    NSData *respData = [req responseData];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableLeaves error:nil];
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//获取信息失败
        [StringUitl alertMsg:[jsonDic valueForKey:@"info"] withtitle:@"错误提示"];
    }
    if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//获取信息成功
        
        //存储用户信息
        [StringUitl setSessionVal:[jsonDic valueForKey:USER_LOGO] withKey:USER_LOGO];
        
    }
    
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// 保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
            bigCell= [stableView dequeueReusableCellWithIdentifier:@"UserBigCell"];
            bigCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //处理圆形图片
            NSString *userLogo = [StringUitl getSessionVal:USER_LOGO];
            NSRange range = [userLogo rangeOfString:@"upload"];
            if(range.location==NSNotFound){
                cellImg = [UIImage imageNamed:@"avatarbig.png"];
            }else{
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[StringUitl getSessionVal:USER_LOGO]]];
                cellImg = [UIImage imageWithData:imgData];
            }
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
            smallCell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 1:
                    smallCell1.smallCellValue.text =[StringUitl getSessionVal:USER_NICK_NAME];
                    smallCell1.smallCellTitle.text =@"我的昵称";
                    break;
                case 2:
                    smallCell1.smallCellValue.text =[StringUitl getSessionVal:LOGIN_USER_NAME];
                    smallCell1.smallCellTitle.text =@"手机号码";
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
        smallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                smallCell.smallCellValue.text =[StringUitl getSessionVal:USER_SEX];
                smallCell.smallCellTitle.text =@"性别";
                break;
            case 1:
                smallCell.smallCellValue.text =[StringUitl getSessionVal:USER_ADDRESS];
                smallCell.smallCellTitle.text =@"地区";
                break;
            default:
                break;
        }
        return smallCell;
    }
}

@end
