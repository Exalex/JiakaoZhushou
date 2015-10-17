//
//  FirstViewController.m
//  教考助手
//
//  Created by Alex on 15/10/15.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "TestSelectViewController.h"
#import "MyDataManager.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_tableView;
    NSArray *_dataArray;//下划线习惯用于区别系统变量和自定义变量
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //上半部分：表格
    [self creatTableView];
    //上半部分：label
    [self creatView];
}

- (void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width,350) style:UITableViewStylePlain];
    
    //设置代理和数据源为当前类
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //初始化一个表格label的数组
    _dataArray = @[@"章节练习",@"顺序练习",@"随机练习",@"专项练习",@"仿真模拟考试"];
}

- (void)creatView
{   //标签
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height-160, 300, 30)];
    label.textAlignment = NSTextAlignmentCenter;//文字居中
    label.text = @"·············我的考试分析·············";
    [self.view addSubview:label];
    
    //按钮  多个按钮和标题用for循环
    NSArray *arr = @[@"我的错题",@"我的收藏",@"我的成绩",@"练习统计"];
    for (int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/4/2-30, self.view.frame.size.height-120, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",12+i]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    //按钮下的标签
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/4/2-30,  self.view.frame.size.height-45, 60, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:13];
        lab.text = arr[i];
        [self.view addSubview:lab];
    }
}

#pragma mark -tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //自定义cell
    
    static NSString *ID = @"FirstTableViewCell";
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil]lastObject];//这函数会返回数组，取最后
    }
   cell.myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",indexPath.row+7]];
    cell.myLabel.text = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - tableView的代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://章节练习
        {
            TestSelectViewController *con = [[TestSelectViewController alloc]init];
            
            //用数据库类方法取得数组赋值给dataArray
            con.dataArray = [MyDataManager getData:chapter];
            
            con.myTitle = @"章节练习";
//            UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
//            item.title = @"";
//            self.navigationItem.leftBarButtonItem = item;
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
