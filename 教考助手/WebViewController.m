//
//  WebViewController.m
//  教考助手
//
//  Created by Alex on 15/10/17.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *_webView;
}
@end

@implementation WebViewController
//重写init方法
-(instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        //1.创建请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //2.创建web对象
        _webView = [[ UIWebView alloc]initWithFrame:self.view.frame];
        //3.调用request方法，添加子视图
        [_webView loadRequest:request];
        [self.view addSubview:_webView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
