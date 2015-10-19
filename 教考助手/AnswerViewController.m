//
//  AnswerViewController.m
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerScrollView.h"
#import "MyDataManager.h"
#import "AnswerModel.h"
#import "SelectModelView.h"
#import "SheetView.h"

@interface AnswerViewController ()<SheetViewDelegate>
{
    AnswerScrollView *view;
    SelectModelView *modelView;
    SheetView * _sheetView;
}
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //模型接收get方法取到的数据
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSArray *array = [MyDataManager getData:answer];
    for (int i=0; i<array.count-1; i++) {
        AnswerModel *model =  array[i];
        if ([model.pid intValue]==_number+1) {
            [arr addObject:model];
        }
    }
    
    //初始化自定义view
    view = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-60) withDataArray:array];
    
    [self.view addSubview:view];
    //创建工具条视图
    [self creatToolBar];
    //创建模式选择视图
    [self creatModel];
    //创建上拉菜单
    [self creatSheet];
}

//创建上拉菜单
-(void)creatSheet
{
    _sheetView = [[SheetView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-80) withSuperView:self.view andQuesCount:50];
    _sheetView.delegate = self;
    [self.view addSubview:_sheetView];
}

#pragma mark - delegate(点击上拉菜单btn的值)
-(void)SheetViewClick:(int)index
{
    //用指针取得对象
    UIScrollView *scroll = view->_scrollView;
    scroll.contentOffset = CGPointMake((index-1)*scroll.frame.size.width, 0);
    //用代理模拟滑动事件
    [scroll.delegate scrollViewDidEndDecelerating:scroll];
    NSLog(@"sadasdasd%@",scroll);

}

//创建模式选择视图
-(void)creatModel
{
    modelView = [[SelectModelView alloc]initWithFrame:self.view.frame addTouch:^(SelectModel model) {
        NSLog(@"当前模式:%d",model);
    }];
    [self.view addSubview:modelView];
    modelView.alpha = 0;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"答题模式" style:UIBarButtonItemStylePlain target:self action:@selector(modelChange:)];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)modelChange:(UIBarButtonItem *)item
{
    [UIView animateWithDuration:0.3 animations:^{
        modelView.alpha =1;
    }];
    
}

//创建工具条视图
-(void)creatToolBar
{
    UIView *barView =[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-60-64, self.view.frame.size.width, 60)];
    barView.backgroundColor = [UIColor whiteColor];
 
    
    NSArray *arr = @[@"1111",@"查看答案",@"收藏本题"];
    for (int i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width/3*i+self.view.frame.size.width/3/2-22, 0, 40, 40);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",16+i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2.png",16+i]] forState:UIControlStateHighlighted];
        btn.tag=301+i;
        [btn addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(btn.center.x-30, 40, 60, 18)];
        lab.textAlignment = UITextAlignmentCenter;
        lab.text = arr[i];
        lab.font = [UIFont systemFontOfSize:13];
        [barView addSubview:btn];
        [barView addSubview:lab];
    }
    
    [self.view addSubview:barView];
}

-(void)clickToolBar:(UIButton *)btn
{
    switch (btn.tag) {
            
        case 301://上拉菜单
        {
            [UIView animateWithDuration:0.3 animations:^{
                _sheetView.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
            }];
            _sheetView->_backView.alpha=0.8;
          
            
        }
        case 302://点击查看答案
        {
            if ([view.hadAnswerArray[view.currentPage] intValue]!=0) {
                return;//答过直接返回不操作
            }else{
                AnswerModel *model = [view.dataArray objectAtIndex:view.currentPage];
                NSString *answer = model.manswer;
                char an = [answer characterAtIndex:0];
                
                [view.hadAnswerArray replaceObjectAtIndex:view.currentPage withObject:[NSString stringWithFormat:@"%d",an-'A'+1]];
                 }
        }
                 break;
                 
            default:
                 break;
                 }
}
                 
@end