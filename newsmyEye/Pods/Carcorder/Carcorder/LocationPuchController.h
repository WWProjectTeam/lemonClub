//
//  LocationPuchController.h
//  Carcorder
//
//  Created by L on 15/8/8.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SqlLiteHelp.h"

@interface LocationPuchController : UIViewController<UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSString *num22;
    MAPointAnnotation *pointAnnotation;
    UIView *AdderssView;
    UILabel *AddressLab;
    UIButton *rightBtn;
    NSString  *mapAddressPush;
    NSString *jdStr22;
    NSString *wdStr22;
}
@end
