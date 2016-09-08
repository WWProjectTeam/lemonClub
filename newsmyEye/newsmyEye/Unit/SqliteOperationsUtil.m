//
//  SqliteOperationsUtil.m
//  newsmy_smarthome_securitydevice_ios
//
//  Created by newsmy on 16/4/26.
//  Copyright © 2016年 EthanZhang. All rights reserved.
//

#import "SqliteOperationsUtil.h"
#import <sqlite3.h>
@implementation SqliteOperationsUtil

#pragma mark - 设备信息相关

///**
// *  获得设备信息
// *
// *  @param deviceId 设备id-不传id时默认为查询所有设备信息
// *
// *  @return 设备信息列表
// */
//+(NSMutableArray *)readDeviceMsgWithDeviceId:(NSString *)deviceId{
//    
//    NSMutableArray * arrayRecevid = [[NSMutableArray alloc]init];
//    //创建数据库对象
//    sqlite3 * dataBase = NULL;
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    if (SQLITE_OK == result) {
//        //创建SQL语句查询
//        NSString *insert;
//        
//        /**
//         *  判断是否有deviceId，如果有，查询deviceID对应的信息，否则查询所有
//         */
//        if (deviceId) {
//            insert = [NSString stringWithFormat:@"SELECT * from DeviceMsg  where deviceId = '%@'",deviceId];
//        }
//        else
//        {
//            insert = [NSString stringWithFormat:@"SELECT * from DeviceMsg"];
//        }
//        
//        sqlite3_stmt *statement;
//        
//        int statu = sqlite3_prepare_v2(dataBase,[insert UTF8String],-1, &statement, nil);
//        
//        if (statu==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0: ID
//                 1: accountId
//                 2: deviceId
//                 3: alias
//                 4: deviceType
//                 */
//                
//                //查询结果处理
//                NSString * strMsgId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                NSString * strAccountId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
//                NSString * strDeviceId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//                NSString * strAlias =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
//                NSString * strDeviceType =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
//                
//                
//                DeviceModel * deviceModel = [[DeviceModel alloc]init];
//                deviceModel.deviceId = strDeviceId;
//                deviceModel.strAccountId = strAccountId;
//                deviceModel.strDeviceType = strDeviceType;
//                deviceModel.deviceName = strAlias;
//                deviceModel.strMsgId = strMsgId;
//
//                [arrayRecevid addObject:deviceModel];
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(dataBase);
//    }
//
//    return arrayRecevid;
//}
//
//
///**
// *  删除对应设备信息-支持批量删除
// *
// *  @param deviceId 设备id
// *
// *  @return 操作状态
// */
//+(BOOL)delDeviceMsgWithDeviceId:(NSMutableArray *)deviceId{
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        for (DeviceModel * deviceModel in deviceId) {
//            
//            NSString *insert = [NSString stringWithFormat:@"DELETE from DeviceMsg where deviceId = '%@'",deviceModel.deviceId];
//            
//            char * error = NULL;
//            
//            //obj-c字符串和c字符串需要转换
//            sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//}
//
//
///**
// *  更新/插入设备信息-支持批量
// *
// *  @param arrDeviceMsg   设备信息列表
// *
// *  @return 操作状态
// */
//+(BOOL)insertOrupdateDeviceMsgWithDeviceMsg:(NSMutableArray *)arrDeviceMsg{
//
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        
//        
//        for (DeviceModel * deviceModel in arrDeviceMsg) {
//
//            NSString * strCount;
//            
//            //先查询数据库是否有相同数据，有就更新，没有就插入
//            NSString * strSqlite = [NSString stringWithFormat:@"select count(*) from DeviceMsg where deviceId= '%@'",deviceModel.deviceId];;
//            sqlite3_stmt *statement;
//            
//            if (sqlite3_prepare_v2(dataBase,[strSqlite UTF8String],-1, &statement, nil)==SQLITE_OK) {
//                
//                while (sqlite3_step(statement)==SQLITE_ROW) {
//                    /*
//                     0: ID
//                     1: accountId
//                     2: deviceId
//                     3: alias
//                     4: deviceType
//                     */
//                    
//                    //查询结果处理
//                   strCount =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                    
//                    
//                }
//            }
//
//            /**
//             *  如果有，则更新，否则插入
//             */
//            if ([strCount integerValue]>0) {
//                
//                //组织SQL语句
//                NSString *sqlStr = [NSString stringWithFormat:@"update DeviceMsg set accountId = '%@',alias = '%@',deviceType = '%@' WHERE deviceId = '%@'", deviceModel.strAccountId, deviceModel.deviceName,deviceModel.strDeviceType,deviceModel.deviceId];
//                
//                char * error = NULL;
//                
//                //obj-c字符串和c字符串需要转换
//                sqlite3_exec(dataBase, [sqlStr UTF8String], nil, nil, &error);
//                
//                if (error) {
//                    return NO;
//                }
//            }
//            else
//            {
//                
//                NSString *insert = [NSString stringWithFormat:@"INSERT INTO DeviceMsg(accountId, deviceId, alias, deviceType) values ('%@','%@','%@','%@')",deviceModel.strAccountId,deviceModel.deviceId,deviceModel.deviceName,deviceModel.strDeviceType];
//                
//                char * error = NULL;
//                
//                //obj-c字符串和c字符串需要转换
//                sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//                
//                if (error) {
//                    return NO;
//                }
//
//            }
//            
//
//            
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//    
//    
//}
//
//
//
///**
// *  插入设备信息
// *
// *  @param arrDeviceList 设备信息列表
// *
// *  @return 操作状态
// */
//+(BOOL)insertDeviceMsgWithDeviceList:(NSMutableArray *)arrDeviceList{
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        for (DeviceModel * deviceModel in arrDeviceList) {
//            NSString *insert = [NSString stringWithFormat:@"INSERT INTO DeviceMsg(accountId, deviceId, alias, deviceType) values ('%@','%@','%@','%@')",deviceModel.strAccountId,deviceModel.deviceId,deviceModel.deviceName,deviceModel.strDeviceType];
//            
//            char * error = NULL;
//            
//            //obj-c字符串和c字符串需要转换
//            sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//
//    }
//    return NO;
//
//}
//
//
//#pragma mark - 本地多媒体文件相关
///**
// *  获得本地视频和图片
// *
// *  @param strAccountId 用户id
// *  @param fileType     文件类型
// *
// *  @return 本地数据列表
// */
//+(NSMutableArray *)readLocationMediaMsgWithAccountId:(NSString *)strAccountId
//                                           MediaType:(mediaType)fileType{
//
//    NSMutableArray * arrayRecevid = [[NSMutableArray alloc]init];
//    //创建数据库对象
//    sqlite3 * dataBase = NULL;
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    if (SQLITE_OK == result) {
//        //创建SQL语句查询
//        NSString *insert;
//        
//
//       insert = [NSString stringWithFormat:@"SELECT * from LocationVideo t where t.accountId = '%@' AND t.fileType = '%lu' ORDER BY id DESC",StringAppend(strAccountId),(unsigned long)fileType];
//        
//        sqlite3_stmt *statement;
//        
//        int statu = sqlite3_prepare_v2(dataBase,[insert UTF8String],-1, &statement, nil);
//        
//        if (statu==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0  @param id            自增id
//                 1  @param accountId     用户id
//                 2  @param updateTime    更新时间-时间戳形式
//                 3  @param filePath      文件路径
//                 4  @param fileType      文件类型- 1:video(mp4) 2:image(jpeg)
//                 5  @param deviceId      设备id
//                 5  @param screenshotPath截图
//                 */
//                
//                //查询结果处理
//                NSString * strMsgId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                NSString * strAccountId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
//                NSString * strUpdateTime =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//                NSString * strFilePath =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
//                NSString * strFileType =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
//                NSString * screenshotPath =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
//
//                
//                LocationMediaModel * mediaModel = [[LocationMediaModel alloc]init];
//                mediaModel.strUpdateTime = strUpdateTime;
//                mediaModel.strFilePath = strFilePath;
//                mediaModel.strMsgId = strMsgId;
//                mediaModel.strAccountId = strAccountId;
//                
//                if ([strFileType isEqualToString:@"1"]) {
//                    mediaModel.fileType = mediaTypeVideo;
//                    mediaModel.strScreenshotPath = screenshotPath;
//                }
//                else if ([strFileType isEqualToString:@"2"]){
//                    mediaModel.fileType = mediaTypeImage;
//
//                }
//                else
//                {
//                    mediaModel.fileType = mediaTypeUnKnow;
//                }
//                
//                
//                [arrayRecevid addObject:mediaModel];
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(dataBase);
//    }
//    
//    return arrayRecevid;
//
//    
//}
//
//
///**
// *  插入多媒体信息-支持批量插入
// *
// *  @param arrMediaMsg 信息列表
// *
// *  @return 操作状态
// */
//+(BOOL)insertMediaMsg:(NSMutableArray *)arrMediaMsg{
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        
//        
//        for (LocationMediaModel * mediaModel in arrMediaMsg) {
//            
//            /*
//             0  @param id            自增id
//             1  @param accountId     用户id
//             2  @param updateTime    更新时间-时间戳形式
//             3  @param filePath      文件路径
//             4  @param fileType      文件类型- 1:video(mp4) 2:image(jpeg)
//             5  @param deviceId      设备id
//             6  @param screenshotPath截图地址
//             */
//
//
//            
//                NSString *insert = [NSString stringWithFormat:@"INSERT INTO LocationVideo(accountId, updateTime, filePath, fileType ,deviceId ,screenshotPath) values ('%@','%@','%@','%lu','%@','%@')",mediaModel.strAccountId,mediaModel.strUpdateTime,mediaModel.strFilePath,(unsigned long)mediaModel.fileType,mediaModel.strDeviceId,mediaModel.strScreenshotPath];
//                
//                char * error = NULL;
//                
//                //obj-c字符串和c字符串需要转换
//                sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//                
//                if (error) {
//                    return NO;
//                }
//
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//
//    
//
//}
//
//
///**
// *  删除本地多媒体信息-支持批量删除 请注意本操作为耗时操作
// *
// *  @param arrMediaMsg 信息列表
// *
// *  @return 操作状态
// */
//+(BOOL)delMediaMsg:(NSMutableArray *)arrMediaMsg{
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        for (LocationMediaModel * mediaModel in arrMediaMsg) {
//            
//            NSString *insert = [NSString stringWithFormat:@"DELETE from LocationVideo where id = '%@'",mediaModel.strMsgId];
//            
//            char * error = NULL;
//            
//            //obj-c字符串和c字符串需要转换
//            sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//            
//            if (error) {
//                sqlite3_close(dataBase);
//                return  NO;
//            }
//
//            
//            
//            //删除数据库记录后执行本地文件删除
//
//            //判断是视频还是图片
//            
//            
//            
//            NSString *path;
//            if (mediaModel.fileType == mediaTypeVideo) {
//                path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"video"];
//            }
//            else
//            {
//                path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"image"];
//            }
//            
//            NSString * strFilePath = [path stringByAppendingPathComponent:mediaModel.strFilePath];
//            NSFileManager *fileMgr = [NSFileManager defaultManager];
//            BOOL bRet = [fileMgr fileExistsAtPath:strFilePath];
//            
//            
//            if (bRet) {
//                NSError *err;
//                [fileMgr removeItemAtPath:strFilePath error:&err];
//                if (err) {
//                    sqlite3_close(dataBase);
//                    return  NO;
//                }
//            }
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//
//}
//
//#pragma mark - 预警
//#pragma - make - 预警
//
///**
// *  获得报警信息
// *
// *  @param srtAccountId 用户id
// *  @param type         报警类型
// *
// *  @return 报警数据列表
// */
//+(NSMutableArray *)readAlertMsgListWithAccountId:(NSString *)srtAccountId
//                                      alertType1:(warningType)type1
//                                      alertType2:(warningType)type2{
//    
//    NSMutableArray * arrayRecevid = [[NSMutableArray alloc]init];
//    //创建数据库对象
//    sqlite3 * dataBase = NULL;
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    if (SQLITE_OK == result) {
//        //创建SQL语句查询
//        NSString *insert;
//        
//        insert = [NSString stringWithFormat:@"SELECT * from WarningMsgList t where t.accountId = '%@' AND t.warningType = '%lu' ORDER BY id DESC",StringAppend(srtAccountId),(unsigned long)type1];
//
//        
//        if (type2) {
//            insert = [NSString stringWithFormat:@"SELECT * from WarningMsgList t where t.accountId = '%@' AND t.warningType = '%lu' OR t.warningType = '%lu' ORDER BY id DESC",StringAppend(srtAccountId),(unsigned long)type1,(unsigned long)type2];
//
//        }
//        
//        
//        sqlite3_stmt *statement;
//        
//        int statu = sqlite3_prepare_v2(dataBase,[insert UTF8String],-1, &statement, nil);
//        
//        if (statu==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0  @param id            自增id
//                 1  @param createrTime   创建时间
//                 2  @param accountId     用户id
//                 3  @param imageUrl      图片路径
//                 4  @param warningType   报警类型 //1:移动侦测告警,6:PM2.5告警,7:烟感告警,8:燃气告警
//                 5  @param deviceId   报警设备别名
//                 6  @param isRead        是否已读
//                 7  @param warningParam  预警参数
//                 */
//                
//                //查询结果处理
//                NSString * strMsgId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                NSString * strAccountId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
//                NSString * strCeaterTime =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//                NSString * strwarningType =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
//                NSString * strDeviceId =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
//                NSString * isRead =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
//                NSString * strWarningParam =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
//
//                
//                AlertMsgModel * alertMoedl = [[AlertMsgModel alloc]init];
//                alertMoedl.strMsgId = strMsgId;
//                alertMoedl.strTime = strCeaterTime;
//                alertMoedl.strDeviceId = strDeviceId;
//                alertMoedl.strParam = strWarningParam;
//                
//                if ([isRead isEqualToString:@"1"]) {
//                    alertMoedl.isRead = YES;
//                }
//                
//                
//                alertMoedl.WarningType = [strwarningType intValue];
//                alertMoedl.strAccountId = strAccountId;
//                
//                
//                [arrayRecevid addObject:alertMoedl];
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(dataBase);
//    }
//    
//    return arrayRecevid;
//
//}
//
//
//
///**
// *  插入报警数据-支持批量插入
// *
// *  @param arrList 数据列表
// *
// *  @return 操作状态
// */
//+(BOOL)insertAlertMsgWithList:(NSMutableArray *)arrList{
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        
//        
//        for (AlertMsgModel * alertModel in arrList) {
//            
//            /*
//             0  @param id            自增id
//             1  @param createrTime   创建时间(时间戳)
//             2  @param accountId     用户id
//             3  @param imageUrl      图片路径
//             4  @param warningType   报警类型 //1:移动侦测告警,6:PM2.5告警,7:烟感告警,8:燃气告警
//             5  @param deviceId   报警设备别名
//             6  @param isRead        是否已读
//             7  @param warningParam  预警参数
//             */
//            
//            
//            NSString * strIsRead = @"";
//            if (alertModel.isRead) {
//                strIsRead = @"1";
//            }
//            else
//            {
//                strIsRead = @"0";
//            }
//            
//            
//            NSString *insert = [NSString stringWithFormat:@"INSERT INTO WarningMsgList(createrTime, accountId, warningType, deviceId, isRead, warningParam) values ('%@','%@','%lu','%@','%@','%@')",alertModel.strTime,alertModel.strAccountId,(unsigned long)alertModel.WarningType,alertModel.strDeviceId,strIsRead,alertModel.strParam];
//            
//            char * error = NULL;
//            
//            //obj-c字符串和c字符串需要转换
//            sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//            
//            if (error) {
//                return NO;
//            }
//            
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//    
//
//}
//
//
///**
// *  删除报警数据-支持批量删除 - 删除依据是msgId
// *
// *  @param arrList 数据列表
// *
// *  @return 操作状态
// */
//+(BOOL)delAlertMsgDataWithList:(NSMutableArray *)arrList{
//
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        for (AlertMsgModel * alertModel in arrList) {
//            
//            NSString *insert = [NSString stringWithFormat:@"DELETE from WarningMsgList where id = '%@'",alertModel.strMsgId];
//            
//            char * error = NULL;
//            
//            //obj-c字符串和c字符串需要转换
//            sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//            
//            if (error) {
//                sqlite3_close(dataBase);
//                return  NO;
//            }
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//}
//
//
///**
// *  更新预警信息-支持批量更新 - 更新数据的依据是msgId
// *
// *  @param arrList 数据列表
// *
// *  @return 操作状态
// */
//+(BOOL)updateAlertMsgDataWithList:(NSMutableArray *)arrList{
//
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        for (AlertMsgModel * alertModel in arrList) {
//            
//            /*
//             0  @param id            自增id
//             1  @param createrTime   创建时间(时间戳)
//             2  @param accountId     用户id
//             3  @param imageUrl      图片路径
//             4  @param warningType   报警类型 //1:移动侦测告警,6:PM2.5告警,7:烟感告警,8:燃气告警
//             5  @param deviceId   报警设备别名
//             6  @param isRead        是否已读
//             7  @param warningParam  预警参数
//             */
//            
//            NSString * strIsRead = @"";
//            if (alertModel.isRead) {
//                strIsRead = @"1";
//            }
//            else
//            {
//                strIsRead = @"0";
//            }
//            
//            NSString *sqlStr = [NSString stringWithFormat:@"update WarningMsgList set createrTime = '%@',accountId = '%@',warningType = '%lu',deviceId = '%@',isRead = '%@',warningParam = '%@' WHERE id = '%@'", alertModel.strTime, alertModel.strAccountId,(unsigned long)alertModel.WarningType,alertModel.strDeviceId,strIsRead,alertModel.strParam,alertModel.strMsgId];
//            
//            char * error = NULL;
//            
//            //obj-c字符串和c字符串需要转换
//            sqlite3_exec(dataBase, [sqlStr UTF8String], nil, nil, &error);
//            
//            if (error) {
//                sqlite3_close(dataBase);
//                return  NO;
//            }
//        }
//        
//        sqlite3_close(dataBase);
//        return YES;
//        
//    }
//    return NO;
//    
//
//
//}
//
//
///**
// *  获得未读预警消息数量
// *
// *  @return 数量
// */
//+(int)getUNReadAlertNum{
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        NSString * strCount;
//        
//        NSString * strSqlite = [NSString stringWithFormat:@"select count(*) from WarningMsgList where accountId= '%@' AND isRead = 0",[[NSUserDefaults standardUserDefaults] valueForKey:@"accountId"]];;
//        sqlite3_stmt *statement;
//        
//        if (sqlite3_prepare_v2(dataBase,[strSqlite UTF8String],-1, &statement, nil)==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0: ID
//                 1: accountId
//                 2: deviceId
//                 3: alias
//                 4: deviceType
//                 */
//                
//                //查询结果处理
//                strCount =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                
//                
//            }
//        }
//        
//        sqlite3_close(dataBase);
//        return [strCount intValue];
//    
//    }
//
//    return -1;
//
//}
//
//
///**
// *  检查是否有未读消息
// *
// *  @param type1 报警类型
// *  @param type2 报警类型
// *
// *  @return /
// */
//+(BOOL)checkUNReadAlertWithType1:(warningType)type1
//                      alertType2:(warningType)type2{
//
//    //创建数据库对象
//    sqlite3 * dataBase = NULL;
//    
//    NSString * strCount;
//
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    if (SQLITE_OK == result) {
//        
//        
//        //创建数据库语句
//        NSString * strSqlite = [NSString stringWithFormat:@"select count(*) from WarningMsgList where accountId= '%@' AND warningType = '%lu' AND isRead = '0' ",[[NSUserDefaults standardUserDefaults] valueForKey:@"accountId"],(unsigned long)type1];
//        
//        if (type2) {
//            strSqlite = [NSString stringWithFormat:@"select count(*) from WarningMsgList where accountId= '%@' AND (warningType = '%lu' or warningType = '%lu') AND isRead = '0'  ",[[NSUserDefaults standardUserDefaults] valueForKey:@"accountId"],(unsigned long)type1,(unsigned long)type2];
//            
//        }
//
//        //获得查询结果
//        sqlite3_stmt *statement;
//        
//        if (sqlite3_prepare_v2(dataBase,[strSqlite UTF8String],-1, &statement, nil)==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0: ID
//                 1: accountId
//                 2: deviceId
//                 3: alias
//                 4: deviceType
//                 */
//                
//                //查询结果处理
//                strCount =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                
//                
//            }
//        }
//        
//        sqlite3_close(dataBase);
//
//       
//    }
//    return [strCount intValue]>0?YES:NO;
//
//}
//
//
//
///**
// *  删除设备后，删除设备相关的报警信息，照片，视频
// *
// *  @param strDeviceID 设备ID
// *
// *  @return 操作状态
// */
//+(BOOL)DelAllDeviceMsgWithDeviceID:(NSString *)strDeviceID{
//    /**
//     *  开始删除报警信息
//     */
//    sqlite3 * dataBase = NULL;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    
//    if (SQLITE_OK == result) {
//        /**
//         *  开始删除报警信息
//         */
//        NSString *insert = [NSString stringWithFormat:@"DELETE from WarningMsgList where deviceId = '%@'",strDeviceID];
//        
//        char * error = NULL;
//        
//        //obj-c字符串和c字符串需要转换
//        sqlite3_exec(dataBase, [insert UTF8String], nil, nil, &error);
//        
//        if (error) {
//            sqlite3_close(dataBase);
//            return  NO;
//        }
//        
//        /**
//         *  查询出本地设备对应的照片和视频
//         */
//        //创建SQL语句查询
//        NSString * select;
//        
//        
//        select = [NSString stringWithFormat:@"SELECT * from LocationVideo  where deviceId = '%@'",strDeviceID];
//        
//        sqlite3_stmt *statement;
//        
//        int statu = sqlite3_prepare_v2(dataBase,[select UTF8String],-1, &statement, nil);
//        
//        if (statu==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0  @param id            自增id
//                 1  @param accountId     用户id
//                 2  @param updateTime    更新时间-时间戳形式
//                 3  @param filePath      文件路径
//                 4  @param fileType      文件类型- 1:video(mp4) 2:image(jpeg)
//                 5  @param deviceId      设备id
//                 */
//                
//                //查询结果处理
//                NSString * strFilePath =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
//                NSString * strFileType =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
//
//                //执行本地文件删除
//                //判断是视频还是图片
//                NSString *path;
//                if ([strFileType intValue] == mediaTypeVideo) {
//                    path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"video"];
//                }
//                else
//                {
//                    path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"image"];
//                }
//                
//                NSString * file = [path stringByAppendingPathComponent:strFilePath];
//                NSFileManager *fileMgr = [NSFileManager defaultManager];
//                BOOL bRet = [fileMgr fileExistsAtPath:file];
//                
//                if (bRet) {
//                    NSError *err;
//                    [fileMgr removeItemAtPath:strFilePath error:&err];
//                    
//                    if (err) {
//                        sqlite3_close(dataBase);
//                        return  NO;
//                    }
//                }
//                
//                
//            }
//        
//        /**
//         *  开始删除照片视频信息
//         */
//        
//        NSString *delSql = [NSString stringWithFormat:@"DELETE from LocationVideo where deviceId = '%@'",strDeviceID];
//        
//        char * error1 = NULL;
//        
//        //obj-c字符串和c字符串需要转换
//        sqlite3_exec(dataBase, [delSql UTF8String], nil, nil, &error1);
//        
//        if (error1) {
//            sqlite3_close(dataBase);
//            return  NO;
//        }
//        
//        }
//    }
//
//    sqlite3_close(dataBase);
//    return YES;
//}
//
//
///**
// *  检查报警消息数量
// *
// *  @param type1 报警类型
// *  @param type2 报警类型
// *
// *  @return /
// */
//+(BOOL)checkAlertMsgNum:(warningType)type1
//             alertType2:(warningType)type2{
//
//    //创建数据库对象
//    sqlite3 * dataBase = NULL;
//    
//    NSString * strCount;
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *filePath = [documents stringByAppendingPathComponent:@"NewsmyCache.sqlite"];
//    
//    //打开数据库
//    int result = sqlite3_open([filePath UTF8String],&dataBase);
//    
//    if (SQLITE_OK == result) {
//        
//        
//        //创建数据库语句
//        NSString * strSqlite = [NSString stringWithFormat:@"select count(*) from WarningMsgList where accountId= '%@' AND warningType = '%lu'",[[NSUserDefaults standardUserDefaults] valueForKey:@"accountId"],(unsigned long)type1];
//        
//        if (type2) {
//            strSqlite = [NSString stringWithFormat:@"select count(*) from WarningMsgList where accountId= '%@' AND (warningType = '%lu' or warningType = '%lu')",[[NSUserDefaults standardUserDefaults] valueForKey:@"accountId"],(unsigned long)type1,(unsigned long)type2];
//            
//        }
//        
//        //获得查询结果
//        sqlite3_stmt *statement;
//        
//        if (sqlite3_prepare_v2(dataBase,[strSqlite UTF8String],-1, &statement, nil)==SQLITE_OK) {
//            
//            while (sqlite3_step(statement)==SQLITE_ROW) {
//                /*
//                 0: ID
//                 1: accountId
//                 2: deviceId
//                 3: alias
//                 4: deviceType
//                 */
//                
//                //查询结果处理
//                strCount =[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                
//                
//            }
//        }
//        
//        sqlite3_close(dataBase);
//        
//        
//    }
//    return [strCount intValue]>0?YES:NO;
//    
//
//}

@end
