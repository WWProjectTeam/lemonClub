//
//  AppDelegate.h
//  Carcorder
//
//  Created by YF on 15/12/24.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIView* waitDialog;

//风火轮的方法
-(void)showWaitDialog;

//结束风火轮的方法
-(void)dismissDialog;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

@property (strong, nonatomic) UIWindow *window;
/**
 *  向JPush注册别名
 *
 *  @param stringAccountId 用户的账号id
 */
- (void)JPushRegisterAliasWithAccountId:(NSString *)stringAccountId;

@end

