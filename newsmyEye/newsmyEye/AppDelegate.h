//
//  AppDelegate.h
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,QQApiInterfaceDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController * navtionViewControl;


@end

