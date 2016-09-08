//
//  DataResultInfo.m
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "DataResultInfo.h"
#import "DeviceListInfo.h"

@implementation DataResultInfo

-(id)initDeviceTrailWithDic:(NSDictionary *)aDic
{
    if (self=[super init])
    {
        _AccountID=aDic[@"Account"];
        
        _Account_Desc=aDic[@"Account_desc"];
        
        _TimeZone=aDic[@"TimeZone"];
        
        _DeviceListArr=aDic[@"DeviceList"];
         
    }
    
    return self;
}

+(id)queryDeviceTrailWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initDeviceTrailWithDic:aDic];
}

@end
