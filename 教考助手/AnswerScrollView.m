//
//  AnswerScrollView.m
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "AnswerScrollView.h"
#import "AnswerTableViewCell.h"
#import "AnswerViewController.h"
#import "AnswerModel.h"
#import "Tools.h"

#define SIZE self.frame.size
@interface AnswerScrollView( )<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

 }
@end

@implementation AnswerScrollView
{
    UIScrollView *_scrollView;
    UITableView *_leftTableView;
    UITableView *_mainTableView;
    UITableView *_rightTableView;
    NSArray *_dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化变量，当前为第0题
        _currentPage = 0;
        
        _dataArray = [[NSArray alloc]initWithArray:array];
        
        //初始化复用的tableView到scrollView上
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.delegate = self;
        _leftTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _mainTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _rightTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        //设置_scrollView效果
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //判断scrollView是否可滑动（一题以上可滑动）
        if (_dataArray.count>1) {
            _scrollView.contentSize = CGSizeMake(SIZE.width*2, 0);//scrollView的滑动范围
        }
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    _leftTableView.frame = CGRectMake(0, 0, SIZE.width, SIZE.height);
    _mainTableView.frame = CGRectMake(SIZE.width, 0, SIZE.width, SIZE.height);
    _rightTableView.frame = CGRectMake(SIZE.width*2, 0, SIZE.width, SIZE.height);
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_mainTableView];
    [_scrollView addSubview:_rightTableView];
    [self addSubview:_scrollView];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}
//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, 100)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"AnswerTableViewCell";
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnswerTableViewCell" owner:self options:nil]lastObject];
    }
    cell.numberLabel.layer.masksToBounds = YES;
    cell.numberLabel.layer.cornerRadius = 10;
    cell.numberLabel.text = [NSString stringWithFormat:@"%c",(char)('A'+indexPath.row)];//强转成a，b，c，d
    
    
    //赋值先取模型
    AnswerModel *model;
    //判断tableView的复用情况，选取合适的model赋值
    //各个tableView在不同情况下显示什么数据
    if (tableView == _leftTableView && _currentPage==0) {
        model=_dataArray[_currentPage];
    }else if (tableView == _leftTableView && _currentPage>0){
        model=_dataArray[_currentPage-1];
        
        //main在current＝0的时候在left右边，显示数组＋1
    }else if (tableView == _mainTableView && _currentPage==0 ){
        model=_dataArray[_currentPage+1];
    }else if (tableView == _mainTableView && _currentPage>0 &&_currentPage<_dataArray.count-1){
        model=_dataArray[_currentPage];
    }else if (tableView == _mainTableView && _currentPage==_dataArray.count-1){
        model=_dataArray[_currentPage-1];
    
    }else if (tableView == _rightTableView && _currentPage==_dataArray.count-1){
        model=_dataArray[_currentPage];
    }else if (tableView == _rightTableView && _currentPage<_dataArray.count-1){
        model=_dataArray[_currentPage+1];
    }
    
    //判断是选择题还是判断题，执行数据库get方法，并赋值给answerLabel
    if ([model.mtype intValue]==1) {
        cell.answerLabel.text = [[Tools getAnswerWithString:model.mquestion]objectAtIndex:indexPath.row+1];
    }
    return cell;
}

//滑动减速后调用的方法（滑动效果）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //拿到当前偏移量
    CGPoint currentOffset = scrollView.contentOffset;
    //判断滑动到第几页（屏幕宽度2倍则为第二页）
    int page = (int)currentOffset.x/SIZE.width;//取整（四舍五入）
    NSLog(@"%f",currentOffset.x);
    
    if (page<_dataArray.count-1 && page>0) {
        //左右滑动效果 1.监控滑动偏移量，重设置tableView坐标
        _scrollView.contentSize = CGSizeMake(currentOffset.x+SIZE.width*2, 0);
        _mainTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
        _leftTableView.frame = CGRectMake(currentOffset.x-SIZE.width, 0, SIZE.width, SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x+SIZE.width, 0, SIZE.width, SIZE.height);
   }
    _currentPage = page;

    //每次滑动都要刷新三个表格
    [_leftTableView reloadData];
    [_mainTableView reloadData];
    [_rightTableView reloadData];
}


    
@end
