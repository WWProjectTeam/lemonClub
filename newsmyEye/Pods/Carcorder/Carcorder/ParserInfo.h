//
//  ParserInfo.h
//  Carcorder
//
//  Created by YF on 16/1/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserInfo : NSObject

@property(nonatomic,strong)NSString *AccountID,*Flag,*Message;

@property(nonatomic,strong)NSMutableArray *MessageArr;

+(id)loginAccountWithDic:(NSDictionary *)aDic;

+(id)getCheckCodeWithDic:(NSDictionary *)aDic;

+(id)registerAccountWithDic:(NSDictionary *)aDic;

+(id)resetAccountPswWithDic:(NSDictionary *)aDic;

+(id)queryDeviceFenceListWithDic:(NSDictionary *)aDic;

+(id)accountQueryDeviceListWithDic:(NSDictionary *)aDic;

@end
