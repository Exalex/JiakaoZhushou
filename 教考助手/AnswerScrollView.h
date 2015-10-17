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
@property (nonatomic ,assign) int currentPage;//当前页数
@end
