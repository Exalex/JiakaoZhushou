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
        _currentPage = 0;
        _dataArray = [[NSArray alloc]initWithArray:array];
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
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
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
    
    AnswerModel *model;//判断显示页
    if (tableView == _leftTableView && _currentPage==0) {
        model=_dataArray[_currentPage];
    }else if (tableView == _leftTableView && _currentPage>0){
        model=_dataArray[_currentPage-1];
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
    
    if ([model.mtype intValue]==1) {
        cell.answerLabel.text = [[Tools getAnswerWithString:model.mquestion]objectAtIndex:indexPath.row+1];
    }
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        CGPoint currentOffset = scrollView.contentOffset;
    
    int page = (int)currentOffset.x/SIZE.width;
    if (page < _dataArray.count-1&&page>0) {
        //左右滑动效果 1.监控滑动偏移量，重设置tableView坐标
        _scrollView.contentSize = CGSizeMake(currentOffset.x+SIZE.width*2, 0);
        _mainTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
        _leftTableView.frame = CGRectMake(currentOffset.x-SIZE.width, 0, SIZE.width, SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x+SIZE.width, 0, SIZE.width, SIZE.height);
   }
    _currentPage = page;
    [self reloadData];
}

-(void)reloadData
{
    [_leftTableView reloadData];
    [_mainTableView reloadData];
    [_rightTableView reloadData];
}
    
@end
