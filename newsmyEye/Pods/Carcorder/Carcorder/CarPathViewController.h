//
//  CarPathViewController.h
//  Carcorder
//
//  Created by L on 15/8/8.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface CarPathViewController : UIViewController <MAMapViewDelegate>
{
    UITextField *StarTime;
    UITextField *EndTime;
    NSString *StarStr;
    NSString *EndStr;
    UIView *bgview;
    NSMutableArray *countData;
    MAPolyline *commonPolyline;
    double wd1;
    double jd1;
    NSString *StrStarTime;
    NSString *StrEndTime;
    NSString *StrStarTime2;
    NSString *StrEndTime2;
    CLLocationCoordinate2D GPSSTR;
    NSString  *StTimeStr;
    NSString  *EdTimeStr;
    
}

@property(strong,nonatomic) NSMutableArray *eventData;

@end
