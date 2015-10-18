//
//  Tools.h
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject
//字符串转数组（解析数据库答案和题干）
+ (NSArray *)getAnswerWithString:(NSString *)str;
//根据字多少来进行尺寸自适应(参数：字符串 字体 范围)
+ (CGSize)getSizeWithString:(NSString *)str with:(UIFont *)font withSize:(CGSize)Size;
@end
