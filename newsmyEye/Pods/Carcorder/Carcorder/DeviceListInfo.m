//
//  DeviceListInfo.m
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "DeviceListInfo.h"
#import "EventDataInfo.h"

@implementation DeviceListInfo

-(id)initWithDic:(NSDictionary *)aDic
{
    if(self=[super init])
    {
        _Device=aDic[@"Device"];
        
        _Device_Desc=aDic[@"Device_desc"];
        
        _EventDataArr=aDic[@"EventData"];
        
    }
    
    return self;
}

+(id)deviceListWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initWithDic:aDic];
}

@end
