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
    UIView *_backView;
    UIView *_superView;
    //可以开始移动
    BOOL _startMoveing;
    float _hight;
    float _width;
    float _y;
}
@end

@implementation SheetView

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        _superView = superView;
        _width = frame.size.width;
        _hight = frame.size.height;
        _y = frame.origin.y;
        [self creatView];
    }
    return self;
}

-(void)creatView
{
    _backView = [[UIView alloc]initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor grayColor];
    _backView.alpha = 0;
    [_superView addSubview:_backView];
}
//手指在屏幕滑动时调用的函数
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //得到屏幕上点的对象
    UITouch *touch = [touches anyObject];
    //获取在view上的点
    CGPoint point = [touch locationInView:[touch view]];
    if (point.y<25) {
        _startMoveing = YES;
    }
    if (_startMoveing&&self.frame.origin.y>=_y-_hight) {
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _hight);
    }
}
//自动收起view
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _startMoveing = NO;
    if (self.frame.origin.y>_y-_hight/2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y,_width, _hight);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y-_hight,_width, _hight);
        }];
    }

}
@end