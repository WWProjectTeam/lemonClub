//
//  EventDataInfo.h
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDataInfo : NSObject

@property(nonatomic,copy)NSString *Device,*Timestamp_date,*Timestamp_time,*StatusCode_hex,*StatusCode_desc,*GPSPoint,*Speed_units,*Altitude_units,*Heading_desc;
@property(nonatomic,assign)int Timestamp,StatusCode,Altitude,Index,Heading;

@property(nonatomic,assign)double GPSPoint_lat,GPSPoint_lon,Speed_kph,Speed,Altitude_meters;

+(id)eventDataWithDic:(NSDictionary *)aDic;

@end
