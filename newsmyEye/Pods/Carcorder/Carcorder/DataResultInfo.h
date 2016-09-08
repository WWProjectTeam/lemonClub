//
//  DataResultInfo.h
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataResultInfo : NSObject

@property(nonatomic,copy)NSString *AccountID,*Account_Desc,*TimeZone;

@property(nonatomic,retain)NSMutableArray *DeviceListArr;

+(id)queryDeviceTrailWithDic:(NSDictionary *)aDic;

@end
