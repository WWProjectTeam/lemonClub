//
//  WWLoginViewController.h
//  newsmyEye
//
//  Created by ww on 16/7/25.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#define APP_ID @"1105450346"
@interface WWLoginViewController : UIViewController<TencentSessionDelegate>

@end
