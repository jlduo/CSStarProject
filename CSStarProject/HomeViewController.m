//
//  HomeViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-8-28.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "HomeViewController.h"
#import "UserViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView{
    [super loadView];
    [self.view addSubview:[super setNavBarWithTitle:@"首 页" hasLeftItem:NO hasRightItem:YES]];
}



#pragma mark 设置组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _headTitleArray.count;
}

#pragma mark 设置组高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

#pragma mark 设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_headTitleArray objectAtIndex:section];
            break;
        case 1:
            return [_headTitleArray objectAtIndex:section];
            break;
            
        default:
            return @"unknow title";
            break;
    }
    
}


#pragma mark 设置每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_girlsDataList count];
            break;
        case 1:
            return [_storyDataList count];
            break;
        case 2:
            return [_peopleDataList count];
            break;
        case 3:
            return [_friendDataList count];
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark 行选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodCell *cell = (GoodCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *msg =[[NSString alloc] initWithFormat:@"选中的是:%@",cell.nameText.text];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark 删除数据
-(void)tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        switch (indexPath.section) {
            case 0:
                [_dataList removeObjectAtIndex:indexPath.row];
                break;
            case 1:
                [_dataList2 removeObjectAtIndex:indexPath.row];
                break;
                
            default:
                break;
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        NSLog(@"点击删除操作！");
    }
}

#pragma mark 拖动更新数据
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"重新加载数据.......!");
    [self setTableData];
    [self.myTableView reloadData];
}


#pragma mark 加载数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static BOOL isNibregistered = NO;
    static NSString *nibIdentifier = @"IDENTIFIER";
    if(!isNibregistered){
        UINib *nibCell = [UINib nibWithNibName:@"GoodCell" bundle:nil];
        [tableView registerNib:nibCell forCellReuseIdentifier:nibIdentifier];
        isNibregistered = YES;
    }
    
    GoodCell *cell = [_myTableView dequeueReusableCellWithIdentifier:nibIdentifier];
    
    switch (indexPath.section) {
        case 0:
            dic = [self.dataList objectAtIndex:indexPath.row];
            break;
        case 1:
            dic = [self.dataList2 objectAtIndex:indexPath.row];
            break;
            
        default:
            cell.textLabel.text = @"unknow";
            break;
    }
    
    
    cell.nameText.text = [dic valueForKey:@"name"];
    cell.priceText.text = [[dic valueForKey:@"price"] stringValue];
    cell.descText.text = [dic valueForKey:@"desc"];
    cell.numText.text = [[dic valueForKey:@"num"] stringValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *img =[UIImage imageNamed:[dic valueForKey:@"pic"]];
    [cell.picBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    return cell;
}





@end
