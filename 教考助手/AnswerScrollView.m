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
    

}

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化变量，当前为第0题
        _currentPage = 0;
        _dataArray = [[NSArray alloc]initWithArray:array];
        _hadAnswerArray = [[NSMutableArray alloc]init];
        //答题逻辑变量，是否答过，答过0，答过纪录ABCD
        for (int i=0; i<array.count-1; i++) {
            [_hadAnswerArray addObject:@"0"];
        }
        
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

//自动适应，返回头视图高度（题干部分）
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    //调用方法，分别给三个tableView选取合适的模型
    AnswerModel *model = [self getTheFitModel:tableView];
    //判断选择题还是是非题
    if ([model.mtype intValue] == 1){
        //用tool方法从模型中截取题干
        NSString *str = [[Tools getAnswerWithString:model.mquestion]objectAtIndex:0];
        UIFont *font = [UIFont systemFontOfSize:16];
        //返回头视图高度,get方法自适应后返回CGSIZE，取height在加20高度
        height = [Tools getSizeWithString:str with:font withSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    }else{
        //str直接取model.mquestion就是判断题
        NSString *str = model.mquestion;
        UIFont *font = [UIFont systemFontOfSize:16];
        height =  [Tools getSizeWithString:str with:font withSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    }
//再次判断，如小于限定值则返回最小值80
    if (height<80) {
        return 80;
    }else{
        return height;
    }
}

//自动适应高度，返回表底部视图高度（答案解析部分）
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //复用自动调整高度的代码
    AnswerModel *model = [self getTheFitModel:tableView];
    NSString *str = [NSString stringWithFormat:@"答案解析：%@",model.mdesc];
    UIFont *font = [UIFont systemFontOfSize:16];
    return [Tools getSizeWithString:str with:font withSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
}

//返回一个view做表格的头视图：返回题干的视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //复用之前判断头视图高度的代码
    NSString *str;
    CGFloat height;
    AnswerModel *model = [self getTheFitModel:tableView];
    if ([model.mtype intValue] == 1){
        str = [[Tools getAnswerWithString:model.mquestion]objectAtIndex:0];
        UIFont *font = [UIFont systemFontOfSize:16];
        height = [Tools getSizeWithString:str with:font withSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    }else{
        str = model.mquestion;
        UIFont *font = [UIFont systemFontOfSize:16];
        height =  [Tools getSizeWithString:str with:font withSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    }
    //返回高度
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, height)];
    //创建显示文字的label
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tableView.frame.size.width-20, height-20)];
    //显示题号和题干内容，题号要判断一下
    lab.text = [NSString stringWithFormat:@"%d.%@",[self getQuestionNumber:tableView andCurrentPage:_currentPage],str];
    lab.font = [UIFont systemFontOfSize:16];
    lab.numberOfLines = 0;//自动换行
    [view addSubview:lab];
    return view;
}

//返回一个view做表格的足视图：返回答案解析的视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //复用之前判断头视图高度的代码
    NSString *str;
    CGFloat height;
    AnswerModel *model = [self getTheFitModel:tableView];
    str = [NSString stringWithFormat:@"答案解析：%@",model.mdesc];
    UIFont *font = [UIFont systemFontOfSize:16];
    height = [Tools getSizeWithString:str with:font withSize:CGSizeMake(tableView.frame.size.width-20, 400)].height+20;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, height)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tableView.frame.size.width-20, height-20)];
    lab.text = str;
    lab.font = [UIFont systemFontOfSize:16];
    lab.numberOfLines = 0;
    lab.textColor = [UIColor greenColor];
    [view addSubview:lab];
    
    //得到题号
    int page = [self getQuestionNumber:tableView andCurrentPage:_currentPage];
    //判断是否答过，没打过不提前显示答案
    if ([_hadAnswerArray[page-1] integerValue]!=0) {
        return view;
    }
    return nil;
}

//判断当前显示的题号
-(int)getQuestionNumber:(UITableView *)tableView andCurrentPage:(int)page
{
    if (tableView==_leftTableView&&page==0) {
        return 1;
    }else if(tableView==_leftTableView&&page>0){
        return page;
    }else if (tableView==_mainTableView&&page>0&&page<_dataArray.count-1){
        return page+1;
    }else if(tableView==_mainTableView&&page==0){
        return 2;
    }else if (tableView==_mainTableView&&page==_dataArray.count-1){
        return page;
    }else if (tableView==_rightTableView&&page<_dataArray.count-1){
        return page+2;
    }else if (tableView==_rightTableView&&page==_dataArray.count-1){
        return page+1;
    }
    return 0;
}

//cell的数据源方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"AnswerTableViewCell";
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnswerTableViewCell" owner:self options:nil]lastObject];
    }
    cell.numberLabel.layer.masksToBounds = YES;
    cell.numberLabel.layer.cornerRadius = 10;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numberLabel.text = [NSString stringWithFormat:@"%c",(char)('A'+indexPath.row)];//强转成a，b，c，d
    
    //赋值先取模型
    AnswerModel *model = [self getTheFitModel:tableView];
    
    //判断是选择题还是判断题，执行数据库get方法，并赋值给answerLabel
    if ([model.mtype intValue]==1) {
        cell.answerLabel.text = [[Tools getAnswerWithString:model.mquestion]objectAtIndex:indexPath.row+1];
    }
    
    //判断答题后显示对错图标的image
    int page = [self getQuestionNumber:tableView andCurrentPage:_currentPage];
    
    if ([_hadAnswerArray[page-1] intValue]!=0) {//已经答过的情况
        if ([model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]) {
            cell.numberImage.hidden = NO;
            cell.numberImage.image = [UIImage imageNamed:@"19.png"];
        }else if (![model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+[_hadAnswerArray[page-1]intValue]-1]] &&indexPath.row==[_hadAnswerArray[page-1]intValue]-1) {
            cell.imageView.image = nil;
            cell.numberImage.hidden = NO;
            cell.numberImage.image = [UIImage imageNamed:@"20.png"];
        }else{
            cell.numberImage.hidden=YES;
        }
    }else{
            cell.numberImage.hidden = YES;
  }
    return cell;
    }

//抽取的方法：选取合适的模型来给cell赋值
-(AnswerModel *)getTheFitModel:(UITableView *)tableView
{
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
    return model;
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

//tableView点击方法（点击列表答题后的操作）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   //判断是否答过
    int page = [self getQuestionNumber:tableView andCurrentPage:_currentPage];
    if ([_hadAnswerArray[page-1] integerValue]!=0) {
        return;
    }else{//没答过纪录下答案
        [_hadAnswerArray replaceObjectAtIndex:page-1 withObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    }
    //答题完之后刷新数据
    [_leftTableView reloadData];
    [_mainTableView reloadData];
    [_rightTableView reloadData];
}




@end
