//
//  EventDataInfo.m
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "EventDataInfo.h"

@implementation EventDataInfo

-(id)initWithDic:(NSDictionary *)aDic
{
    if (self=[super init])
    {
        _Device=aDic[@"Device"];
        
        _Timestamp=[aDic[@"Timestamp"] intValue];
        
        _Timestamp_date=aDic[@"Timestamp_date"];
        
        _Timestamp_time=aDic[@"Timestamp_time"];
        
        _StatusCode=[aDic[@"StatusCode"] intValue];
        
        _StatusCode_hex=aDic[@"StatusCode_hex"];
        
        _StatusCode_desc=aDic[@"StatusCode_desc"];
        
        _GPSPoint=aDic[@"GPSPoint"];
        
        _GPSPoint_lat=[aDic[@"GPSPoint_lat"] doubleValue];
        
        _GPSPoint_lon=[aDic[@"GPSPoint_lon"] doubleValue];
        
        _Speed_kph=[aDic[@"Speed_kph"] doubleValue];
        
        _Speed=[aDic[@"Speed"] doubleValue];
        
        _Speed_units=aDic[@"Speed_units"];
        
        _Altitude_meters=[aDic[@"Altitude_meters"] doubleValue];
        
        _Altitude=[aDic[@"Altitude"] intValue];
        
        _Altitude_units=aDic[@"Altitude_units"];
        
        _Index=[aDic[@"index"] intValue];
        
        _Heading=[aDic[@"Heading"] intValue];
        
        _Heading_desc=aDic[@"Heading_desc"];
    }
    
    return self;
}

+(id)eventDataWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initWithDic:aDic];
}

@end
