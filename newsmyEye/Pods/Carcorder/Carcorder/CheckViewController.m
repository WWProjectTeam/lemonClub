//
//  CheckViewController.m
//  Carcorder
//
//  Created by YF on 16/1/18.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "CheckViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CheckViewController ()

//视频播放控制器
@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;

@end

@implementation CheckViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"预览";
    
    if(self.mediaImg!=nil)
    {
       self.checkImgView.image=self.mediaImg;
    }
    else
    {
        //播放
       [self.moviePlayer play];
    
        //添加通知
       [self addNotification];
    }
}

-(void)dealloc
{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl
{
    //    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
    //    NSString *filePath2 = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/233.h264"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"233.h264" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:path];
    return url;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl
{
    NSString *urlStr=@"http://192.168.1.161/The New Look of OS X Yosemite.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer
{
    if (!_moviePlayer)
    {
        //NSURL *url=[self getFileUrl];
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:self.mediaUrl];
        _moviePlayer.view.frame=self.view.bounds;
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification
{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState)
    {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放");
            break;
        default:
            
            break;
    }
    NSLog(@"播放状态:%li",(long)self.moviePlayer.playbackState);
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification
{
    NSLog(@"播放完成.%li",(long)self.moviePlayer.playbackState);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
