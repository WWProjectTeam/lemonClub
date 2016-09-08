//
//  AppDelegate.m
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "AppDelegate.h"
#import "WWLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#pragma mark - DeBugFlex
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
    DDLogInfo(@"调试器加载成功!");
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    WWLoginViewController * login = [[WWLoginViewController alloc]init];
    
    //导航条创建
    self.navtionViewControl = [[UINavigationController alloc]initWithRootViewController:login];
    
    
    [self.window setRootViewController:self.navtionViewControl];
    
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    /**
     处理由手Q唤起的跳转请求
     \param url 待处理的url跳转请求
     \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
     \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
     */
    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}


/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}
@end
