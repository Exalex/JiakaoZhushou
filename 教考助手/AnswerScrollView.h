//
//  AnswerScrollView.h
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerScrollView : UIView
//重写init方法
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array;
//当前第几题
@property (nonatomic ,assign,readonly) int currentPage;

@end
