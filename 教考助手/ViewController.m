//
//  ViewController.m
//  教考助手
//
//  Created by Alex on 15/10/15.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "SelectView.h"
#import "FirstViewController.h"
#import "SubjectTwoViewController.h"
#import "WebViewController.h"
@interface ViewController ()
{
    SelectView *_selectView;//为了设置透明度
    __weak IBOutlet UIButton *selectBtn;//为了把btn传给控件设置图片
}
@end

@implementation ViewController
//所有首页按钮的点击方法
- (IBAction)click:(UIButton *)sender {
    //用tag值＋swich语句区分
    switch (sender.tag) {
        
        case 100://切换驾考车型
        {
            
            
           //点击时唤出蒙板
            [UIView animateWithDuration:0.3 animations:^{
                _selectView.alpha = 1;
            }];
        }
            break;
        
        case 101://科目一
        {   //点击按钮后push到firstViewController
            UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
            item.title = @"";
            self.navigationItem.leftBarButtonItem = item;
            [self.navigationController pushViewController:[[FirstViewController alloc]init] animated:YES];
        }
            break;
        
        case 102://科目二
        {
            [self.navigationController pushViewController:[[SubjectTwoViewController alloc]init] animated:YES];
        }
            break;
        
        case 103:
        {
            [self.navigationController pushViewController:[[SubjectTwoViewController alloc]init] animated:YES];
        }
            break;
       
        case 104:
        {
            
        }
            break;
        
        case 105:
        {
            [self.navigationController pushViewController:[[WebViewController alloc]initWithUrl:@"http://zhinan.jxedt.com/info/4655.htm"] animated:YES];
        }
            break;
       
        case 106:
        {
            [self.navigationController pushViewController:[[WebViewController alloc]initWithUrl:@"http://jiqiao.jxedt.com/info/7642.htm"] animated:YES];
        }
            break;
       
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //先创建view,设为透明
    _selectView = [[SelectView alloc]initWithFrame:self.view.frame andBtn:selectBtn];
    _selectView.alpha=0;
    [self.view addSubview:_selectView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
