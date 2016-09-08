//
//  FenceInfo.h
//  Carcorder
//
//  Created by YF on 16/1/20.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenceInfo : NSObject

@property(nonatomic,copy)NSString *AccountID,*Device_id,*Z_id,*Z_streetAddress,*SimPhoneNum,*Uniq_id,*IMEI,*Description,*Is;

@property(nonatomic,assign)float Z_latitude,Z_longitude;

@property(nonatomic,assign)int Z_radial,Z_type;

+(id)queryFencetWithDic:(NSDictionary *)aDic;

+(id)queryDeviceWithDic:(NSDictionary *)aDic;

@end
