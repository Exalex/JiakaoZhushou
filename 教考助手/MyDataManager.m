//
//  MyDataManager.m
//  教考助手
//
//  Created by Alex on 15/10/16.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "MyDataManager.h"
#import "FMDatabase.h"
#import "TestSelectModel.h"
#import "AnswerModel.h"
@implementation MyDataManager

+(NSArray *)getData:(dataType)type
{   //用来接收赋完值的model数组
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    //1.创建数据库对象
    static FMDatabase * dataBase;
    if (!dataBase) {
        //2.数据库获取路径
        NSString *path = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"sqlite"];
        //3.用路径创建对象
        dataBase = [[FMDatabase alloc]initWithPath:path];
    }
    if ([dataBase open]) {
        NSLog(@"数据库打开成功");
    }else{
        return arr;
    }
    //4.数据库进行查找
    switch (type) {  //用swich区分哪个类型的数据
        case chapter:
        {
            //4.1 写数据库查询语句(@"select +需要查询的元素 FROM ＋哪张表)
            NSString *sql = @"select pid,pname,pcount FROM firstlevel";
            
            //4.2用查询语句创建查询结果对象
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {//布尔类型 next返回1则继续循环
                
                //4.3创建模型实例创建对象
                TestSelectModel *model = [[TestSelectModel alloc]init];
                //4.4用模型属性来接收数据库数据（类型不对用格式化字符串方法）
                model.pid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pid"]];
                model.pname = [rs stringForColumn:@"pname"];
                model.pcount = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pcount"]];
                //4.5把model加到可变数组中
                [arr addObject:model];
                
            }
        }
            break;
            
        case answer:
        {
            NSString *sql = @"select mquestion,mdesc,mid,manswer,miamge,pid,pname,sid,sname,mtype FROM leaflevel";
            
            FMResultSet *rs = [dataBase executeQuery:sql];
            while ([rs next]) {
           
            AnswerModel *model = [[AnswerModel alloc]init];
                
            model.mquestion = [rs stringForColumn:@"mquestion"];
            model.mdesc = [rs stringForColumn:@"mdesc"];
            model.mid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"mid"]];
            model.manswer = [rs stringForColumn:@"manswer"];
            model.miamge = [rs stringForColumn:@"miamge"];
            model.pid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"pid"]];
            model.pname = [rs stringForColumn:@"pname"];
            model.sid = [NSString stringWithFormat:@"%d",[rs intForColumn:@"sid"]];
            model.sname = [NSString stringWithFormat:@"%d",[rs intForColumn:@"sname"]];
            model.mtype = [NSString stringWithFormat:@"%d",[rs intForColumn:@"mtype"]];
        
            [arr addObject:model];
                
            }
        }
            break;
            
        default:
            break;
    }
    return arr;
}

@end
