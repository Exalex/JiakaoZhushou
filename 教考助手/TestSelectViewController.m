//
//  TestSelectViewController.m
//  教考助手
//
//  Created by Alex on 15/10/15.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "TestSelectViewController.h"
#import "TestSelectTableViewCell.h"
#import "TestSelectModel.h"
#import "AnswerViewController.h"

@interface TestSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableview;
}
@end

@implementation TestSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //排除navigationBar的布局
    self.edgesForExtendedLayout = UIRectEdgeNone;    [self creatTableView];
    //设置标题
    self.title = _myTitle;
    [self creatTableView];
}

- (void)creatTableView
{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)style:UITableViewStylePlain];
//    设置代理和数据源
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}

#pragma mark - delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TestSelectTableViewCell";
    TestSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中样式
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8;//圆角
    //给cell赋值
    
    TestSelectModel *model = _dataArray[indexPath.row];//用模型对象接收传进来的数组
    cell.numberLabel.text = model.pid;
    cell.titleLabel.text = model.pname;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerViewController *avc = [[AnswerViewController alloc]init];
    avc.number = indexPath.row;
    [self.navigationController pushViewController:avc animated:YES];
}

@end
