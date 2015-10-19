//
//  SheetView.h
//  教考助手
//
//  Created by Alex on 15/10/19.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
//传值用代理
@protocol SheetViewDelegate
-(void)SheetViewClick:(int)index;
@end

@interface SheetView : UIView
{
    @public
    UIView *_backView;
}

-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuesCount:(int)count;

//声明代理 id-对象类型+<...>遵守的协议＋代理对象名
@property (nonatomic,weak)id<SheetViewDelegate> delegate;

@end
