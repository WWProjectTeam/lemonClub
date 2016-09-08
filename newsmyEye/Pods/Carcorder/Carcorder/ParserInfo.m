//
//  ParserInfo.m
//  Carcorder
//
//  Created by YF on 16/1/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "ParserInfo.h"

@implementation ParserInfo

-(id)initWithDic:(NSDictionary *)aDic
{
    if(self=[super init])
    {
        _AccountID=aDic[@"account_id"];
        
        _Flag=aDic[@"flag"];
        
        _Message=aDic[@"message"];
        
    }
    
    return self;
}

+(id)loginAccountWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initWithDic:aDic];
}

+(id)getCheckCodeWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initWithDic:aDic];
}

+(id)registerAccountWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initWithDic:aDic];
}

+(id)resetAccountPswWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initWithDic:aDic];
}

-(id)initQueryDeviceFenceWithDic:(NSDictionary *)aDic
{
    if(self=[super init])
    {
        _AccountID=aDic[@"account_id"];
        
        _Flag=aDic[@"flag"];
        
        _MessageArr=aDic[@"message"];
        
    }
    
    return self;
}

+(id)queryDeviceFenceListWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initQueryDeviceFenceWithDic:aDic];
}

+(id)accountQueryDeviceListWithDic:(NSDictionary *)aDic
{
    return [[self alloc] initQueryDeviceFenceWithDic:aDic];
}

@end
