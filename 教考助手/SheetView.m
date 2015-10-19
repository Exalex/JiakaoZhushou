//
//  SheetView.m
//  教考助手
//
//  Created by Alex on 15/10/19.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "SheetView.h"
@interface SheetView()
{
    UIView *_superView;
    //可以开始移动
    BOOL _startMoveing;
    float _hight;
    float _width;
    float _y;
    
    //放sheet上的按钮
    UIScrollView *_scrollView;
    //保存题目数量（创建btn数量）
    int _count;
}
@end

@implementation SheetView

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuesCount:(int)count
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _superView = superView;
        _width = frame.size.width;
        _hight = frame.size.height;
        _y = frame.origin.y;
        _count = count;
        [self creatView];
    }
    return self;
}

-(void)creatView
{   //蒙板
    _backView = [[UIView alloc]initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [_superView addSubview:_backView];
    //放btn的scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    [self addSubview:_scrollView];
    //按钮
    for (int i=0; i<_count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((_width-44*6)/2+44*(i%6), 10+44*(i/6), 40, 40);
        btn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        if (i==0) {
            btn.backgroundColor = [UIColor orangeColor];
        }
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    //滑动范围
    int tip = (_count%6)?1:0;//如果求余有余数返回‘1’ 无余数那么就返回‘0’
    _scrollView.contentSize = CGSizeMake(0, 20+44*(_count/6+1+tip));
    
}

//小btn的点击方法
-(void)click:(UIButton *)btn
{
    int index = (int)btn.tag-100;
    for (int i=0; i<_count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+101];
        if (i!=index-1) {
            button.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }else{
            button.backgroundColor = [UIColor orangeColor];
        }
    }
    //代理对象执行方法
    [_delegate SheetViewClick:index];
    
}

//手指在屏幕滑动时调用的函数
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //得到屏幕上点的对象(返回的是{x, y})
    UITouch *touch = [touches anyObject];
    //获取在view上的点
    CGPoint point = [touch locationInView:[touch view]];
    if (point.y<25) {
        _startMoveing = YES;
    }
    if (_startMoveing&&self.frame.origin.y>=_y-_hight&&[self convertPoint:point toView:_superView].y>80) {//根据监控的点坐标修改frame的y值
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _hight);
        //取到偏移量比值(根据偏移量比值动态修改蒙板的alpha)
        float offset = (self.frame.size.height-self.frame.origin.y)/_superView.frame.size.height*0.8;
        _backView.alpha = offset;
    }
}
//自动收起view
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _startMoveing = NO;
    if (self.frame.origin.y>_y-_hight/2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y,_width, _hight);
            self.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y-_hight,_width, _hight);
            _backView.alpha = 0.8;
        }];
    }

}
@end