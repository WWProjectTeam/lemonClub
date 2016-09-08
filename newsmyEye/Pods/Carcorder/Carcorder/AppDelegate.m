//
//  AppDelegate.m
//  Carcorder
//
//  Created by YF on 15/12/24.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LandViewController.h"
#import "DevListViewController.h"
#import "PhotoViewController.h"
#import "MyInfoViewController.h"
#import "AlarmViewController.h"
#import "HttpEngine.h"
#import "AccountInfo.h"
#import "ParserInfo.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AdSupport/ASIdentifierManager.h>
#import "SqlLiteHelp.h"
//#import "APService.h"
#import "JPUSHService.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    
#pragma mark - jpush接入
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    
    
    [JPUSHService setupWithOption:launchOptions appKey:@"30d839c2f91a0e083277b938"
                          channel:@"APPStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];

    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"accountId"]) {
        [self JPushRegisterAliasWithAccountId:[[NSUserDefaults standardUserDefaults] stringForKey:@"accountId"]];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
//
//    
//    
//    //Required
//    //可以添加自定义categories
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    //Required
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    } else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
//    
//
//    
//    [JPUSHService setupWithOption:launchOptions];
//    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
//
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidReceiveMessage:)
//                          name:kJPFNetworkDidReceiveMessageNotification object:nil];
//    //NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//    
//    //Required
//    //初始化,获取appkey
    
    if (launchOptions)
    {
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification)
        {
            NSLog(@"推送消息==== %@",remoteNotification);
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    
     /*状态栏显示网络活动状态*/
     //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
     /*状态栏隐藏网络活动状态*/
     //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [MAMapServices sharedServices].apiKey = @"d1799e1374bc86c92b3984e05ed0e06b";
    [AMapSearchServices sharedServices].apiKey = @"d1799e1374bc86c92b3984e05ed0e06b";
   
    SqlLiteHelp * sqllite=[[SqlLiteHelp alloc]init];
    [sqllite createMessageTable];

    //设置导航条的的前景色
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    
    //设置输入框光标的颜色
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    
    AccountInfo *info=[[AccountInfo alloc] init];
    
    NSString *userNameStr=[USER valueForKey:@"userName"];
    
    info.accountID=userNameStr;
    
    NSString *pswStr=[USER valueForKey:@"pswName"];
    
    info.psw=pswStr;
    
    if (![userNameStr isEqualToString:@""]&&![pswStr isEqualToString:@""])
    {

        [HttpEngine loginAccount:info and: ^(NSMutableArray *array) {
            
            ParserInfo *info=array[0];
         
                //点击响应事件
                if (![info.Message isEqualToString:@"登录成功！"])
                {

                    return ;
                }
            [self JPushRegisterAliasWithAccountId:userNameStr];

            UITabBarController *tabBarVC=[[UITabBarController alloc] initWithNibName:@"TabbarViewController" bundle:nil];
            
            DevListViewController *deviceVC=[[DevListViewController alloc] init];
            
            UINavigationController *deviceNav=[[UINavigationController alloc] initWithRootViewController:deviceVC];
            
            PhotoViewController *photoVC=[[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
            
            UINavigationController *photoNav=[[UINavigationController alloc] initWithRootViewController:photoVC];
            
            MyInfoViewController *myInfoVC=[[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
            
            UINavigationController *myInfoNav=[[UINavigationController alloc] initWithRootViewController:myInfoVC];
            
            UITabBarItem *deviceItem=[[UITabBarItem alloc] initWithTitle:@"设备" image:[[UIImage imageNamed:@"设备-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"设备-绿"] ];
            
            deviceNav.tabBarItem=deviceItem;
            
            UITabBarItem *photoItem=[[UITabBarItem alloc] initWithTitle:@"相册" image:[[UIImage imageNamed:@"相册-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"相册-绿"]];
            
            photoNav.tabBarItem=photoItem;
            
            UITabBarItem *myInfoItem=[[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"我的-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"我的-绿"]];
            
            myInfoNav.tabBarItem=myInfoItem;
            
            tabBarVC.viewControllers=@[deviceNav,photoNav,myInfoNav];

            self.window.rootViewController=tabBarVC;
        } failure:^(NSError *error) {
            
        }];
    }

    /*延迟启动画面*/
    /*
    [NSThread sleepForTimeInterval:2.0];
    
    [self.window makeKeyAndVisible];
    */
     
    LandViewController *landVC=[[LandViewController alloc] init];

    self.window.rootViewController=landVC;
    
    return YES;
}

-(void)jPushCallBack
{
    
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    //取得APNs标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//    
//    //取得自定义字段内容
//    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数,key是自己定义的
//    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
//    
//    //Required
//    [JPUSHService handleRemoteNotification:userInfo];
//}

-(void)goToMssageViewControllerWith:(NSDictionary*)msgDic
{
    //将字段存入本地,因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面
    [USER setObject:@"push"forKey:@"push"];
    [USER synchronize];
    NSString * targetStr = [msgDic objectForKey:@"target"];
    if ([targetStr isEqualToString:@"notice"])
    {
        AlarmViewController * alarmVC = [[AlarmViewController alloc]init];
        
        //这里加导航栏是因为我跳转的页面带导航栏,如果跳转的页面不带导航，那这句话请省去
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:alarmVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

////iOS7 Remote Notification
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    //NSString *TimeStr = [userInfo valueForKey:@"Time"];
//    
//    [USER setObject:userInfo forKey:@"mesInfo"];
//    
//    [USER synchronize];
//    
//    NSString *content = [aps valueForKey:@"alert"];//推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];//badge数量
//    NSString *sound = [aps valueForKey:@"sound"];//播放的声音
//    
//    //取得自定义字段内容
//    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"];//自定义参数,key是自己定义的
//    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
//    
//    NSLog(@"this is iOS7 Remote Notification");
//    AudioServicesPlaySystemSound(1007);  // 1106
//    //Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNoData);
//}
//
//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
//{
// 
//    application.applicationIconBadgeNumber = -1;
//    
//}
//
//-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
//{
//    if (jsonString == nil)
//    {
//        return nil;
//    }
//    
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//    if(err)
//    {
//        NSLog(@"json解析失败：%@",err);
//        
//        return nil;
//    }
//    return dic;
//}
//
////自定义消息
//-(void)networkDidReceiveMessage:(NSNotification *)notification
//{
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *userNameStr=[USER valueForKey:@"userName"];
//    NSString *key=[NSString stringWithFormat:@"%@mesList",userNameStr];
//    NSMutableArray *mesInfoList = [NSMutableArray arrayWithArray:[USER objectForKey:key]];
//    [mesInfoList addObject:userInfo];
//    [USER setObject:mesInfoList forKey:key];
//    
//    
//    [USER synchronize];
//    //[USER setObject:userInfo forKey:@"mesInfo"];
//    //[USER removeObjectForKey:@"mesInfo"];
//    
//    NSString *content=[userInfo valueForKey:@"content"];
//    NSDictionary *dicContent= [self dictionaryWithJsonString:content];
//    NSString *device = [dicContent valueForKey:@"deviceId"];
//    NSString *streetAddress=[dicContent valueForKey:@"streetAddress"];
//    
//    long event=[[dicContent valueForKey:@"event"] longLongValue];
//    
//    if(event==101)
//    {
//        content=[NSString stringWithFormat:@"%@车辆发生震动",device];
//        
//        AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
//        alarmVC.strDeviceId = device;
//        [self.window.rootViewController.navigationController pushViewController:alarmVC animated:YES];
//    }
//    else if(event ==102)
//    {
//        content=[NSString stringWithFormat:@"%@进入电子围栏区域:%@",device,streetAddress];
//        
//        
//        AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
//        alarmVC.strDeviceId = device;
//        [self.window.rootViewController.navigationController pushViewController:alarmVC animated:YES];
//    }
//    else if(event==103)
//    {
//        content=[NSString stringWithFormat:@"%@离开电子围栏区域:%@",device,streetAddress];
//        
//        
//        AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
//        alarmVC.strDeviceId = device;
//        [self.window.rootViewController.navigationController pushViewController:alarmVC animated:YES];
//    }
//    
//    
//
//    
//    
//    NSLog(@"报警信息为:%@",content);
//    
//    //NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    //NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    
//    [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:5] alertBody:content badge:1 alertAction:@"取消" identifierKey:@"identifierKey" userInfo:nil soundName:nil];
//}

-(void)showWaitDialog
{
    if(!_waitDialog)
    {
        _waitDialog = [[UIView alloc] init];
        _waitDialog.frame = CGRectMake(0, 0, kScreen_width, kScreen_height);
        _waitDialog.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        UIView* layout = [[UIView alloc] init];
        layout.frame = CGRectMake(0, 0, 120, 120);
        layout.layer.cornerRadius = 5;
        layout.layer.masksToBounds = YES;
        layout.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        layout.center = CGPointMake(kScreen_width/2, kScreen_height/2);
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] init];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activity.center = CGPointMake(60, 60);
        [activity startAnimating];
        [layout addSubview:activity];
        
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 75, 120, 20);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"努力加载中...";
        [layout addSubview:label];
        
        [_waitDialog addSubview:layout];
    }
    
    [self.window addSubview:_waitDialog];
}

-(void)dismissDialog
{
    [_waitDialog removeFromSuperview];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplicationWillResignActive" object:self];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self beingBackgroundUpdateTask];
    
    [self endBackgroundUpdateTask];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
          //  NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           // NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];//清除角标
    [application cancelAllLocalNotifications];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"shoudaole");
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - JPush Init
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];

}



- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//- (void)application:(UIApplication *)application
//didRegisterUserNotificationSettings:
//(UIUserNotificationSettings *)notificationSettings {
//}
//
//// Called when your app has been activated by the user selecting an action from
//// a local notification.
//// A nil action identifier indicates the default action.
//// You should call the completion handler as soon as you've finished handling
//// the action.
//- (void)application:(UIApplication *)application
//handleActionWithIdentifier:(NSString *)identifier
//forLocalNotification:(UILocalNotification *)notification
//  completionHandler:(void (^)())completionHandler {
//}
//
//// Called when your app has been activated by the user selecting an action from
//// a remote notification.
//// A nil action identifier indicates the default action.
//// You should call the completion handler as soon as you've finished handling
//// the action.
//- (void)application:(UIApplication *)application
//handleActionWithIdentifier:(NSString *)identifier
//forRemoteNotification:(NSDictionary *)userInfo
//  completionHandler:(void (^)())completionHandler {
//}
//#endif



/**
 *  向JPush注册别名
 *
 *  @param stringAccountId 用户的账号id
 */
- (void)JPushRegisterAliasWithAccountId:(NSString *)stringAccountId{
  //  [JPUSHService setTags:nil aliasInbackground:StringAppend(stringAccountId)];
    
    [JPUSHService setTags:nil alias:StringAppend(stringAccountId) fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    
    [self receiveJPush:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    
    [self receiveJPush:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    //NSDictionary *userInfo = [notification userInfo];
    
   // [self receiveJPush:userInfo];
        NSDictionary * userInfo = [notification userInfo];
        NSString *userNameStr=[USER valueForKey:@"userName"];
        NSString *key=[NSString stringWithFormat:@"%@mesList",userNameStr];
        NSMutableArray *mesInfoList = [NSMutableArray arrayWithArray:[USER objectForKey:key]];
        [mesInfoList addObject:userInfo];
        [USER setObject:mesInfoList forKey:key];
    
    
        [USER synchronize];

    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString *content=[userInfo valueForKey:@"content"];
        NSDictionary *dicContent= [self dictionaryWithJsonString:content];
        NSString *device = [dicContent valueForKey:@"deviceId"];
        NSString *streetAddress=[dicContent valueForKey:@"streetAddress"];
    
        int event=[[dicContent valueForKey:@"event"] intValue];
    
        if(event==101)
        {
            content=[NSString stringWithFormat:@"%@车辆发生震动",device];
    
            AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
            alarmVC.strDeviceId = device;
            [self.window.rootViewController.navigationController pushViewController:alarmVC animated:YES];
        }
        else if(event ==102)
        {
            content=[NSString stringWithFormat:@"%@进入电子围栏区域:%@",device,streetAddress];
    
    
            AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
            alarmVC.strDeviceId = device;
            [self.window.rootViewController.navigationController pushViewController:alarmVC animated:YES];
        }
        else if(event==103)
        {
            content=[NSString stringWithFormat:@"%@离开电子围栏区域:%@",device,streetAddress];
    
    
            AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
            alarmVC.strDeviceId = device;
            [self.window.rootViewController.navigationController pushViewController:alarmVC animated:YES];
        }
        
    });

    AudioServicesPlaySystemSound(1007);  // 1106
}



#pragma mark - jpush MSG Load
-(void)receiveJPush:(NSDictionary *)msgBody{
    
    
    if (!msgBody[@"content"]) {
        return;
    }
    
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    return dic;
}

@end
