//
//  FenceInfo.m
//  Carcorder
//
//  Created by YF on 16/1/20.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "FenceInfo.h"

@implementation FenceInfo

-(id)initFenceWithDic:(NSDictionary *)aDic
{
    if (self=[super init])
    {
        _AccountID=aDic[@"account_id"];
        
        _Device_id=aDic[@"device_id"];
        
        _Z_id=aDic[@"z_id"];
        
        _Z_streetAddress=aDic[@"z_streetAddress"];
        
        _Z_latitude=[aDic[@"z_latitude"] floatValue];
        
        _Z_longitude=[aDic[@"z_longitude"] floatValue];
        
        _Z_radial=[aDic[@"z_radial"] intValue];
        
        _Z_type=[aDic[@"z_type"] intValue];
        
        _SimPhoneNum=aDic[@"simPhoneNumber"];
        
        _Uniq_id=aDic[@"uniq_id"];
        
        _IMEI=aDic[@"imei_number"];
        
        _Description=aDic[@"description"];
        
        _Is=aDic[@"is"];
    }
    
    return self;
}

+(id)queryFencetWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initFenceWithDic:aDic];
}

+(id)queryDeviceWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initFenceWithDic:aDic];
}

@end
