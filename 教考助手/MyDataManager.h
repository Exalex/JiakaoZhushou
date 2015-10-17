//
//  MyDataManager.h
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
//定义题库类型
typedef enum {
    chapter,//章节练习
    answer  //答题数据
}dataType;


@interface MyDataManager : NSObject
//获取数据类方法
+(NSArray *)getData:(dataType)type;

@end
