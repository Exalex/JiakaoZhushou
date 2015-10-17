//
//  Tools.m
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+(NSArray *)getAnswerWithString:(NSString *)str
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    //用<BR>分割字符串，返回数组
    NSArray *arr = [str componentsSeparatedByString:@"<BR>"];
    //题干加入第一个元素
    [array addObject:arr[0]];
    //取选项，并取出字母（前两个字符）
    for (int i=0; i<4; i++) {
        [array addObject:[ arr[i+1] substringFromIndex:2]];
    }
    return array;
}
@end
