//
//  WWFlowRechargeViewController.h
//  Carcorder
//
//  Created by newsmy on 16/6/2.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface WWFlowRechargeViewController : UIViewController<MBProgressHUDDelegate>
enum{
    RechargeTypeUpdatePackage = 1,//升级套餐
    RechargeTypepurchasePackage = 2//购买套餐
};

typedef NSUInteger WWFlowRechargeType;

@property (assign,nonatomic) WWFlowRechargeType rechargeType;
@end
