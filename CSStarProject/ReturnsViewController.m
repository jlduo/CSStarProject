//
//  ReturnsViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-10-13.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "ReturnsViewController.h"

@interface ReturnsViewController (){
    UITableView *returnsTableView;
    NSDictionary *cellDic;
    NSString *dataId;
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
    if(IOS_VERSION>=7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initLoadData];
    
    [self loadTableList];
}

-(void)initLoadData{
    //计算高度
    CGRect tframe = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-49);
    
    returnsTableView = [[UITableView alloc] initWithFrame:tframe];
    returnsTableView.delegate = self;
    returnsTableView.dataSource = self;
    returnsTableView.rowHeight = 180;
    
    returnsTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:CONTENT_BACKGROUND]];
    returnsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏多余的行
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [returnsTableView setTableFooterView:view];
    returnsTableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:returnsTableView];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[self setNavBarWithTitle:@"选择回报" hasLeftItem:YES hasRightItem:NO leftIcon:nil rightIcon:nil]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    InitTabBarViewController * customTabar = (InitTabBarViewController *)self.tabBarController;
    [customTabar hiddenDIYTaBar];
    CGRect temFrame = CGRectMake(0, 64, SCREEN_WIDTH,MAIN_FRAME_H-44);
    [returnsTableView setFrame:temFrame];
    
    [returnsTableView reloadData];
    
}

//传递过来的参数
-(void)passValue:(NSString *)val{
    dataId = val;
    NSLog(@"dataId====%@",dataId);
}

-(void)loadTableList{
    
    ConvertJSONData *convertJson = [[ConvertJSONData alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",REMOTE_URL,GET_RETURNS_URL,dataId];
    NSArray *returnArr = (NSArray *)[convertJson requestData:url];
    if(returnArr!=nil && returnArr.count>0){
        _peopleReturnList = [NSMutableArray arrayWithArray:returnArr];
    }
    NSLog(@"_peopleReturnList====%@",_peopleReturnList);
    
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
        peopelCell.cellTitle.text = [NSString stringWithFormat:@"￥%@",[[cellDic valueForKey:@"amount"] stringValue]];
        peopelCell.supportNum.text = [NSString stringWithFormat:@"%@人支持",[cellDic valueForKey:@"persons"]];
        peopelCell.descText.text = [cellDic valueForKey:@"description"];
        
        peopelCell.saveBtn.layer.cornerRadius = 5.0;
        peopelCell.saveBtn.layer.masksToBounds = TRUE;
        
        if(indexPath.row%2==1){
            peopelCell.backgroundColor = [StringUitl colorWithHexString:@"#C4C4C4"];
        }else{
            peopelCell.backgroundColor = [StringUitl colorWithHexString:@"#FFFFFF"];
        }
        
        
        
    }
    return peopelCell;
}








@end
