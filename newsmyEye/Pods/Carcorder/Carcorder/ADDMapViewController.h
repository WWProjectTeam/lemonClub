//
//  ADDMapViewController.h
//  Carcorder
//
//  Created by L on 15/8/10.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ADDMapViewController : UIViewController<UIGestureRecognizerDelegate>
{
    NSString *num22;
    MACircle *circle;
    MAPointAnnotation *pointAnnotation;
    double num;
    NSString  *wdStr222;
    NSString  *jdStr222;
}
@end
