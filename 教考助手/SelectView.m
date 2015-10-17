//
//  SelectView.m
//  教考助手
//
//  Created by Alex on 15/10/15.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView
{
    UIButton *_button;//成员变量来接收传来的btn
}
- (instancetype)initWithFrame:(CGRect)frame andBtn:(UIButton *)btn
{
    self = [super initWithFrame:frame];
    if (self) {
        //半透明颜色
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _button = btn;//外界传进来的btn
        [self creatBtn];
    }
    return self;
}

- (void)creatBtn
{   //for循环创建蒙板上的btn
    for (int i = 0 ; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width/4*i+self.frame.size.width/4/2-30, self.frame.size.height-80, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
//点击蒙板退出
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}
//点击btn后设置外面btn的图片
- (void)click:(UIButton *)btn
{
    //把btn的图片传给_button，并调用btn的背景图
    [_button setBackgroundImage:[btn backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    //点击btn后蒙板也消失
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}
@end
