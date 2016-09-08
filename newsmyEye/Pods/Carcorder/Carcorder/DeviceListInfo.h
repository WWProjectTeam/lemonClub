//
//  DeviceListInfo.h
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceListInfo : NSObject

@property(nonatomic,copy)NSString *Device,*Device_Desc;

@property(nonatomic,retain)NSMutableArray *EventDataArr;

+(id)deviceListWithDic:(NSDictionary *)aDic;

@end
