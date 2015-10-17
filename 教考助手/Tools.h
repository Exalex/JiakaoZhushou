//
//  Tools.h
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
//字符串转数组（解析数据库答案和题干）
+(NSArray *)getAnswerWithString:(NSString *)str;
@end
