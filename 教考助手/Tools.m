//
//  Tools.m
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "Tools.h"

@implementation Tools

//用来分割题干
+(NSArray *)getAnswerWithString:(NSString *)str
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    //以<BR>为标记分割字符串，返回数组
    NSArray *arr = [str componentsSeparatedByString:@"<BR>"];
    //把第一个元素（题干）加入数组
    [array addObject:arr[0]];
    //循环arr[i+1]的元素（题干），［并去除字母substringFromIndex］
    for (int i=0; i<4; i++) {
        [array addObject:[arr[i+1] substringFromIndex:2]];
    }
    return array;
}
@end
