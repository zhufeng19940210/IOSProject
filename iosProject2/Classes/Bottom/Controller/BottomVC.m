//  BottomVC.m
//  iosProject2
//  Created by bailing on 2018/6/9.
//  Copyright © 2018年 zhufeng. All rights reserved.
#import "BottomVC.h"
#import "RunTimeVC.h"
#import "RunLoopVC.h"
#import "BlockVC.h"
#import "TestVC.h"
@interface BottomVC ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@end
@implementation BottomVC
-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"绘图QUART2D,核心动画,物理仿真",@"多线程，同步锁,列表加载图片",@"运行时RUNTIME,运行循环RunLoop",@"生命周期,block", nil];
    }
    return _titleArray;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@[@"绘图Quartz2D",@"核心动画CoreAnimatio",@"物理仿真"],@[@"Thread多线程",@"GCD多线程",@"NSOperation多线程",@"同步锁",@"列表图片下载"],@[@"Runtime",@"RunLoop"],@[@"viewController的生命周期",@"Block内存释放"]];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.title = @"底层原理";
    [self setupTableView];
}
#pragma mark setupTableView
-(void)setupTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
}
#pragma mark -- UITableViewDelegate | UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  [self.dataArray [section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return  30;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return  10;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleArray[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.textLabel.text = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            RunTimeVC *runtimevc = [[RunTimeVC alloc]init];
            runtimevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:runtimevc animated:YES];
        }else{
            RunLoopVC *loopvc = [[RunLoopVC alloc]init];
            loopvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loopvc animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            TestVC *testvc = [[TestVC alloc]init];
            testvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:testvc animated:YES];
        }else{
            BlockVC *blockvc = [[BlockVC alloc]init];
            blockvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:blockvc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
