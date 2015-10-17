//
//  SubjectTwoViewController.m
//  教考助手
//
//  Created by Alex on 15/10/17.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "SubjectTwoViewController.h"
#import "SubjectTwoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
@interface SubjectTwoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    MPMoviePlayerViewController *movie;
}

@end

@implementation SubjectTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark - data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"SubjectTwoTableViewCell";
    SubjectTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:self options:nil]lastObject];
    }
    cell.titleImage.image = [UIImage imageNamed:@"movie01"];
    cell.titleLabel.text = [NSString stringWithFormat:@"视频%ld",(long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    1.创建文件路径对象
    NSString *path = [[NSBundle mainBundle]pathForResource:@"S03E03" ofType:@".mp4"];
//    2.创建url对象
    NSURL *url = [NSURL fileURLWithPath:path];
//    3.创建播放器控制器
    NSLog(@"%@",url);
    movie = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    movie.moviePlayer.shouldAutoplay = YES;
//    4.跳转控制器
    [self.navigationController pushViewController:movie animated:YES];
}

@end
