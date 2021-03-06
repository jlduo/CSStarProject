//
//  ReturnsViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ReturnsViewController.h"

@interface ReturnsViewController (){
    NSDictionary *cellDic;
    NSString *dataId;
    int target_id;
}

@end

@implementation ReturnsViewController

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
    [super viewDidLoad];
    [self initLoadData];
    [self loadTableList];
}

-(void)initLoadData{
   
    _returnListTable.rowHeight = 180;
    _returnListTable.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    _returnListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _returnListTable.showsVerticalScrollIndicator = NO;
    
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"选择回报" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)passDicValue:(NSDictionary *)vals{
    NSLog(@"vals====%@",vals);
}

-(void)loadTableList{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_RETURNS_URL,dataId];
    NSArray *returnArr = (NSArray *)[ConvertJSONData requestData:url];
    if(returnArr!=nil && returnArr.count>0){
        _peopleReturnList = [NSMutableArray arrayWithArray:returnArr];
    }
    //NSLog(@"_peopleReturnList====%@",_peopleReturnList);
    
}




#pragma mark 设置组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _peopleReturnList.count;
}


#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到详情页面
    OrderInfoViewController *orderController = (OrderInfoViewController*)[self getVCFromSB:@"orderInfo"];
    passValelegate = orderController;
    [passValelegate passDicValue:[self.peopleReturnList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:orderController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//     PeopleReturnCell *peopelCell = [tableView dequeueReusableCellWithIdentifier:@"ReturnCell"];
//    if (peopelCell == nil) {
//        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PeopleReturnCell" owner:self options:nil] ;
//        peopelCell = [nib objectAtIndex:0];
//    }
//    NSDictionary *dicReturn = [_peopleReturnList  objectAtIndex:indexPath.row];
//    NSString *returnContent = [dicReturn valueForKey:@"description"];
//    
//    //评论内容自适应
//    UIFont *font = [UIFont systemFontOfSize:12];
//    CGSize size = CGSizeMake(peopelCell.descText.frame.size.width,2000);
//    CGSize labelsize = [returnContent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//    
//    if (labelsize.height > 20) {
//        return  140 + labelsize.height;
//    }else{
//        return 170;
//    }
    return 200;
    
}

#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PeopleReturnCell *peopelCell;
    cellDic = [self.peopleReturnList objectAtIndex:indexPath.row];
    if(cellDic!=nil){
        
        static NSString *CustomCellIdentifier = @"ReturnCell";
        peopelCell=  (PeopleReturnCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (peopelCell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PeopleReturnCell" owner:self options:nil] ;
            peopelCell = [nib objectAtIndex:0];
        }
        
        peopelCell.selectionStyle =UITableViewCellSelectionStyleNone;
        peopelCell.backgroundColor = [UIColor clearColor];
        
        peopelCell.cellTitle.font = TITLE_FONT;
        peopelCell.cellTitle.text = [NSString stringWithFormat:@"￥%.2f",[[cellDic valueForKey:@"amount"] doubleValue]];
        NSString *persons = [cellDic valueForKey:@"persons"];
        if ([persons isEqual:[NSNull null]]) {
            persons = @"0";
        }
        
        peopelCell.supportNum.font = main_font(12);
        peopelCell.supportNum.text = [NSString stringWithFormat:@"%@人支持",persons];
        peopelCell.descText.text = [cellDic valueForKey:@"description"];
        peopelCell.descText.font = DESC_FONT;
        
        peopelCell.saveBtn.titleLabel.font = main_font(20);
        peopelCell.saveBtn.layer.cornerRadius = 5.0;
        peopelCell.saveBtn.layer.masksToBounds = TRUE;
        
        [peopelCell.saveBtn setTag:indexPath.row];
        [peopelCell.saveBtn addTarget:self action:@selector(goOrderInfo:) forControlEvents:UIControlEventTouchDown];
        
        
//        UIButton *textBtn = [[UIButton alloc]initWithFrame:peopelCell.descText.frame];
//        [textBtn setTag:indexPath.row];
//        textBtn.backgroundColor = [UIColor clearColor];
//        [textBtn addTarget:self action:@selector(goOrderInfo:) forControlEvents:UIControlEventTouchDown];
//        [peopelCell addSubview:textBtn];
        
        if(indexPath.row%2==1){
            peopelCell.backgroundColor = [StringUitl colorWithHexString:@"#F5F5F5"];
            peopelCell.descText.backgroundColor = [UIColor clearColor];
        }else{
            peopelCell.backgroundColor = [UIColor whiteColor];
        }
        
    }
    return peopelCell;
}


-(void)goOrderInfo:(UIButton *)sender{
    //NSLog(@"go order");
    OrderInfoViewController *orderController = (OrderInfoViewController*)[self getVCFromSB:@"orderInfo"];
    passValelegate = orderController;
    [passValelegate passDicValue:[self.peopleReturnList objectAtIndex:sender.tag]];
    [self.navigationController pushViewController:orderController animated:YES];
}
         
         
-(void)goOrderInfo1:(UITapGestureRecognizer *)gester{
    //NSLog(@"gester.view.tag==%d",gester.view.tag);
    OrderInfoViewController *orderController = (OrderInfoViewController*)[self getVCFromSB:@"orderInfo"];
    passValelegate = orderController;
    [passValelegate passDicValue:[self.peopleReturnList objectAtIndex:gester.view.tag]];
    [self.navigationController pushViewController:orderController animated:YES];
}
         
         


@end
