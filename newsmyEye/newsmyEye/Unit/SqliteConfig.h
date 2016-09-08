//
//  NSObject+OtherConfig.h
//  handheldSupply
//
//  Created by 王维 on 14-10-28.
//  Copyright (c) 2014年 掌上供. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  SqliteConfig:NSObject

enum{
    MotionDetection,//移动监测
    PM25Monitoring,//PM2.5监测
    SmokeGasMonitoring,//烟感燃气
    temperatureHumidityMonitoring//温度湿度监测
};

typedef NSUInteger deviceMonitoringType;

//数据库创建方法
+(void)SQLDataSteup;


@end
