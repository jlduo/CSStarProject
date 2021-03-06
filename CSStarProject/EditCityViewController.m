//
//  EditCityViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-18.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "EditCityViewController.h"

@interface EditCityViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@end

@implementation EditCityViewController{
    
    NSString *pID;
    NSString *saveType;
    NSString *userAddStr;
    
    int selectedCityIndex;
    int selectedProvinceIndex;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [self showLoading:@"加载中..."];
    [super viewDidLoad];
    [self setNavgationBar];
    
    _provinceArray = [[NSMutableArray alloc]init];
    _cityArray = [[NSMutableArray alloc]init];
    _provinceArray1 = [[NSMutableArray alloc]init];
    _cityArray1 = [[NSMutableArray alloc]init];
    
    if([StringUitl isNotEmpty:saveType]){
        userAddStr = [StringUitl getSessionVal:ADDRESS_INFO];
        if([StringUitl isEmpty:userAddStr])userAddStr = nil;
        self.cityText.text = userAddStr;
        [self loadProvData];
        if([StringUitl isEmpty:[StringUitl getSessionVal:ADDRESS_PROVINCE_ID]]){
           [self loadCityData:@"1"];
        }else{
           [self loadCityData:[StringUitl getSessionVal:ADDRESS_PROVINCE_ID]];
        }
    }else{
         userAddStr = [StringUitl getSessionVal:USER_ADDRESS];
         if([StringUitl isEmpty:userAddStr])userAddStr = nil;
         self.cityText.text = userAddStr;
        [self loadProvData];
        [self loadCityData:@"1"];
    }
    
    self.cityText.delegate = self;
    self.cityPciker.delegate = self;
    
    [self.cityBg setAlpha:0.8f];
    self.view.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
    [StringUitl setViewBorder:self.cityBg withColor:@"#CCCCCC" Width:0.5f];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSString *name = [_provinceArray objectAtIndex:selectedProvinceIndex];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.name == %@",name];
    NSArray *result = [_provinceArray1 filteredArrayUsingPredicate:predicate];
    if(result!=nil && result.count>0){
        NSDictionary * ndic = (NSDictionary *)[result objectAtIndex:0];
        NSString *provId = [[ndic objectForKey:@"id"] stringValue];
        if([StringUitl isNotEmpty:provId]){
            self.provinceValue = provId;
            [self loadCityData:provId];
        }
    }
    
    NSString *cname = [_cityArray objectAtIndex:selectedCityIndex];
    predicate = [NSPredicate predicateWithFormat:@"self.name == %@",cname];
    NSArray *cresult = [_cityArray1 filteredArrayUsingPredicate:predicate];
    if(cresult!=nil && cresult.count>0){
        NSDictionary * ndic = (NSDictionary *)[cresult objectAtIndex:0];
        NSString *cityId = [[ndic objectForKey:@"id"] stringValue];
        self.cityValue = cityId;
    }
    
    [self.cityPciker reloadComponent:1];
    [self.cityPciker selectRow:selectedProvinceIndex inComponent:0 animated:YES];
    [self.cityPciker selectRow:selectedCityIndex inComponent:1 animated:YES];
    
    [self hideHud];
}


-(void)setNavgationBar{
    //处理导航开始
    self.navigationController.navigationBarHidden = YES;
    UINavigationBar *navgationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_TITLE_HEIGHT+20)];
    [navgationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_BG_ICON] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    //处理标题
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 50, 44)];
    [titleLabel setText:@"修改地区"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    titleLabel.font = main_font(20);
    
    //设置左边箭头
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lbtn setFrame:CGRectMake(0, 0, 32, 32)];
    [lbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_LEFT_ICON] forState:UIControlStateNormal];
    [lbtn addTarget:self action:@selector(goPreviou) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:lbtn];
    
    //设置右侧按钮
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbtn setFrame:CGRectMake(0, 0, 45, 45)];
    [rbtn setTitle:@"保 存" forState:UIControlStateNormal];
    [rbtn setTitle:@"保 存" forState:UIControlStateHighlighted];
    [rbtn setTintColor:[UIColor whiteColor]];
    //[rbtn setFont:Font_Size(18)];
    rbtn.titleLabel.font=main_font(18);
    
    //[rbtn setBackgroundImage:[UIImage imageNamed:NAVBAR_RIGHT_ICON] forState:UIControlStateNormal];
    if([StringUitl isNotEmpty:saveType]){
        [rbtn addTarget:self action:@selector(saveAddressCity) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [rbtn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rbtn];
    
    navItem.titleView = titleLabel;
    navItem.leftBarButtonItem = leftBtnItem;
    navItem.rightBarButtonItem = rightBtnItem;
    [navgationBar pushNavigationItem:navItem animated:YES];
    
    [self.view addSubview:navgationBar];
    
}


//传递过来的参数
-(void)passValue:(NSString *)val{
    saveType = val;
    NSLog(@"saveType====%@",saveType);
}
-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals44====%@",vals);
}

-(void)goPreviou{
    if([[StringUitl getSessionVal:FORWARD_TYPE] isEqualToString:@"TAB"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)saveAddressCity{
    
    //处理收货地址信息
    [StringUitl setSessionVal:_cityText.text withKey:ADDRESS_INFO];
    [StringUitl setSessionVal:_provinceValue withKey:ADDRESS_PROVINCE_ID];
    [StringUitl setSessionVal:_cityValue withKey:ADDRESS_CITY_ID];
    
    AddAddressViewController *addressController =(AddAddressViewController *)[self findViewController:self];
    passValelegate = addressController;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:_cityText.text forKey:ADDRESS_INFO];
    [param setObject:_provinceValue forKey:ADDRESS_PROVINCE_ID];
    [param setObject:_cityValue forKey:ADDRESS_CITY_ID];
    
    [passValelegate passDicValue:param];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveUserInfo{
    
    NSString *cityVal = _cityValue;
    NSString *proVal = _provinceValue;
    if([StringUitl isEmpty:cityVal]){
        [StringUitl alertMsg:@"对不起，请先重新选择地区！"withtitle:@"错误提示"];
        return;
    }
    
    [self showLoading:@"数据保存中..."];
    //开始处理
    NSString * username = [StringUitl getSessionVal:LOGIN_USER_NAME];
    NSDictionary *parameters = @{USER_NAME:username,USER_ADDRESS:_cityText.text,CITY_ID:cityVal,PROVINCE_ID:proVal};
    [HttpClient updateUserInfo:parameters isjson:FALSE success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDic = [StringUitl getDicFromData:responseObject];
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"error"]){//修改失败
            [self hideHud];
            [self showNo:[jsonDic valueForKey:@"info"]];
        }
        if([[jsonDic valueForKey:@"status"] isEqualToString:@"success"]){//修改成功
            
            [self hideHud];
            [self showOk:[jsonDic valueForKey:@"info"]];
            
            [StringUitl setSessionVal:_cityValue withKey:CITY_ID];
            [StringUitl setSessionVal:_cityText.text withKey:USER_ADDRESS];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self requestFaild:error];
        
    }];
    
    
}

- (void)requestFaild:(NSError *)error
{
    [self hideHud];
    NSLog(@"error=%@",error);
    [self showNo:@"请求失败,网络错误!"];
}

-(void)loadProvData{
    
    NSString *userAdd = userAddStr;
    NSString *url = [NSString stringWithFormat:@"%@%@",REMOTE_URL,GET_CITY_URL];
    NSMutableArray *cityArr = (NSMutableArray *)[ConvertJSONData requestData:url];
    if(cityArr!=nil && cityArr.count>0){
        _provinceArray1 = cityArr;
        for (int i=0; i<cityArr.count; i++) {
            NSDictionary * dic = [cityArr objectAtIndex:i];
           [_provinceArray addObject:[dic valueForKey:@"name"]];
            NSRange range = [userAdd rangeOfString:[dic valueForKey:@"name"]];
            //NSLog(@"name==%@",[dic valueForKey:@"name"]);
            if([StringUitl isNotEmpty:userAdd] && range.location!=NSNotFound){
                selectedProvinceIndex = i;
            }
            
        }
    }
    
}

-(void)loadCityData:(NSString *)provID{
    
    NSString *userAdd = userAddStr;
    NSString *url = [NSString stringWithFormat:@"%@%@?id=%@",REMOTE_URL,GET_CITY_URL,provID];
    NSMutableArray *cityArr = (NSMutableArray *)[ConvertJSONData requestData:url];
    if(cityArr!=nil && cityArr.count>0){
        _cityArray1 = cityArr;
        //先清除内容
        [_cityArray removeAllObjects];
        for (int i=0; i<cityArr.count; i++) {
            NSDictionary * dic = [cityArr objectAtIndex:i];
            [_cityArray addObject:[dic valueForKey:@"name"]];
            NSRange range = [userAdd rangeOfString:[dic valueForKey:@"name"]];
            //NSLog(@"name==%@",[dic valueForKey:@"name"]);
            if([StringUitl isNotEmpty:userAdd] && range.location!=NSNotFound){
                selectedCityIndex = i;
            }

        }
    }
    
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
      if(component==0){
        return [_provinceArray count];
      }else{
        return [_cityArray count];
     }
}

//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component==0){
      return [_provinceArray objectAtIndex:row];
    }else{
      return [_cityArray objectAtIndex:row];
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *myView = nil;
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 40)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_provinceArray objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
        
    }else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 40)];
        myView.text = [_cityArray objectAtIndex:row];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = 0.0;
    if(component == 0){
       componentWidth = 100.0; // 第一个组键的宽度
    }else{
       componentWidth = 100.0; // 第2个组键的宽度
    }
    return componentWidth;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 40.0;
}



//行选择事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component==0){
        //从省份数据中获取ID
         NSString *name = [_provinceArray objectAtIndex:row];
         NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.name == %@",name];
         NSArray *result = [_provinceArray1 filteredArrayUsingPredicate:predicate];
        if(result!=nil && result.count>0){
           NSDictionary * ndic = (NSDictionary *)[result objectAtIndex:0];
            NSString *cityId = [[ndic objectForKey:@"id"] stringValue];
            if([StringUitl isNotEmpty:cityId]){
                [self loadCityData:cityId];
            }
        }
        [self.cityPciker reloadComponent:1];
        [self.cityPciker selectRow:0 inComponent:1 animated:YES];
        
        //回填信息
        [self setCityValue];
        
    }else{
        
        [self setCityValue];

    }
    
}

-(void)setCityValue{
    
    NSInteger proInex = [self.cityPciker selectedRowInComponent:0];
    NSInteger cityInex = [self.cityPciker selectedRowInComponent:1];
    //NSLog(@"proInex=%d",proInex);
    //NSLog(@"cityInex=%d",cityInex);
    
    NSString *pname = [_provinceArray objectAtIndex:proInex];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.name == %@",pname];
    NSArray *presult = [_provinceArray1 filteredArrayUsingPredicate:predicate];
    if(presult!=nil && presult.count>0){
        NSDictionary * ndic = (NSDictionary *)[presult objectAtIndex:0];
        NSString *provId = [[ndic objectForKey:@"id"] stringValue];

        NSLog(@"pname=%@",pname);
        NSLog(@"provId=%@",provId);
        self.provinceValue = provId;
    }
    
 
    NSString *cname = [_cityArray objectAtIndex:cityInex];
    predicate = [NSPredicate predicateWithFormat:@"self.name == %@",cname];
    NSArray *cresult = [_cityArray1 filteredArrayUsingPredicate:predicate];
    if(cresult!=nil && cresult.count>0){
        NSDictionary * ndic = (NSDictionary *)[cresult objectAtIndex:0];
        NSString *cityId = [[ndic objectForKey:@"id"] stringValue];
        
        NSString * cityStr = [[NSString alloc]initWithFormat:@"%@,%@",pname,cname];
        
        NSLog(@"cname=%@",cname);
        NSLog(@"cityId=%@",cityId);
        self.cityText.text = cityStr;
        self.cityValue = cityId;
    }
}


@end
