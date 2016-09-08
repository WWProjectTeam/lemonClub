//
//  FenceMapViewController.h
//  Carcorder
//
//  Created by EthanZhang on 16/1/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "URLHeader.h"

@interface FenceMapViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSString *num22;
    MACircle *circle;
    MAPointAnnotation *pointAnnotation;
    double num;
    NSString  *wdStr222;
    NSString  *jdStr222;
}
@end
