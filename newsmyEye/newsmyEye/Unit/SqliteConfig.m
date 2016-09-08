//
//  NSObject+OtherConfig.m
//  aiterWfi
//
//  Created by 王维 on 14-10-28.
//  Copyright (c) 2014年 王维. All rights reserved.
//

#import "SqliteConfig.h"
#import <sqlite3.h>
@implementation SqliteConfig : NSObject

+(void)SQLDataSteup{
    
    //创建数据库对象
    sqlite3 * dataBase = NULL;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
    
    //打开数据库
    int result = sqlite3_open([filePath UTF8String],&dataBase);
    
    if (SQLITE_OK == result) {
        
        /**
         *  创建一个名称为WarningMsgList的表-----存储报警信息
         *  2015年04月26日  王维
         *
         *  @param id            自增id
         *  @param createrTime   创建时间(时间戳)
         *  @param accountId     用户id
         *  @param imageUrl      图片路径
         *  @param warningType   报警类型 //1:移动侦测告警,6:PM2.5告警,7:烟感告警,8:燃气告警
         *  @param deviceId   报警设备别名
         *  @param isRead        是否已读
         *  @param warningParam  预警参数
         */
        
        char * sqlStageCreater = "CREATE TABLE WarningMsgList(id integer primary key AutoIncrement,accountId varchar(30),createrTime varchar(30),imageUrl varchar(50),warningType varchar(20),deviceId varchar(20),isRead varchar(1),warningParam varchar(3))";
        char * error = NULL;
        sqlite3_exec(dataBase, sqlStageCreater, nil, nil, &error);
        
        if (error) {
            DDLogWarn(@"创建数据库-报警信息表 错误信息---%s",error);
        }
        
        
        
        /**
         *  创建一个名称为DeviceMsg的表-----存储设备信息
         *  2015年04月26日  王维
         *
         *  @param id            自增id
         *  @param accountId     用户id
         *  @param deviceId      设备id
         *  @param alias         设备别名
         *  @param deviceType    设备类型
         */
        
        char * sqlStageCreaterForDevice = "CREATE TABLE DeviceMsg(id integer primary key AutoIncrement,accountId varchar(30),deviceId varchar(30),alias varchar(30),deviceType varchar(1))";
        char * errorDevice = NULL;
        
        sqlite3_exec(dataBase, sqlStageCreaterForDevice, nil, nil, &errorDevice);
        if (errorDevice) {
            DDLogWarn(@"创建数据库-设备信息表 错误信息---%s",errorDevice);
        }
        
        
        /**
         *  创建一个名称为LocationVideo的表-----存储视频信息
         *  2015年04月26日  王维
         *
         *  @param id            自增id
         *  @param accountId     用户id
         *  @param updateTime    更新时间-时间戳形式
         *  @param filePath      文件路径
         *  @param fileType      文件类型- 1:video(mp4) 2:image(jpeg)
         *  @param deviceId      设备id
         *  @param screenshotPath截图地址
         */
        char * sqlStageCreaterForVideo = "CREATE TABLE LocationVideo(id integer primary key AutoIncrement,accountId varchar(30),updateTime varchar(30),filePath varchar(50),fileType varchar(2),deviceId varchar(20),screenshotPath varchar(20))";
        char * errorVideo = NULL;
        
        sqlite3_exec(dataBase, sqlStageCreaterForVideo, nil, nil, &errorVideo);
        if (errorVideo) {
            DDLogWarn(@"创建数据库-本地视频信息表 错误信息---%s",errorVideo);
        }

        
        //数据库使用完成后关闭数据库
        sqlite3_close(dataBase);
    }
}




@end
