//
//  SqliteOperationsUtil.h
//  newsmy_smarthome_securitydevice_ios
//
//  Created by newsmy on 16/4/26.
//  Copyright © 2016年 EthanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SqliteOperationsUtil : NSObject


//#pragma mark - 设备信息相关
//
///**
// *  获得设备信息
// *
// *  @param deviceId 设备id-不传id时默认为查询所有设备信息
// *
// *  @return 设备信息列表
// */
//+(NSMutableArray *)readDeviceMsgWithDeviceId:(NSString *)deviceId;
//
//
///**
// *  删除对应设备信息-支持批量删除
// *
// *  @param deviceId 设备id
// *
// *  @return 操作状态
// */
//+(BOOL)delDeviceMsgWithDeviceId:(NSMutableArray *)deviceId;
//
//
///**
// *  更新/插入设备信息-支持批量
// *
// *  @param arrDeviceMsg   设备信息列表
// *
// *  @return 操作状态
// */
//+(BOOL)insertOrupdateDeviceMsgWithDeviceMsg:(NSMutableArray *)arrDeviceMsg;
//
//#pragma mark - 本地视频+图片
//
///**
// *  获得本地视频和图片-按时间降序
// *
// *  @param strAccountId 用户id
// *  @param fileType     文件类型
// *
// *  @return 本地数据列表
// */
//+(NSMutableArray *)readLocationMediaMsgWithAccountId:(NSString *)strAccountId
//                                           MediaType:(mediaType)fileType;
//
//
///**
// *  插入多媒体信息-支持批量插入
// *
// *  @param arrMediaMsg 信息列表
// *
// *  @return 操作状态
// */
//+(BOOL)insertMediaMsg:(NSMutableArray *)arrMediaMsg;
//
//
///**
// *  删除本地多媒体信息-支持批量删除 请注意本操作为耗时操作
// *
// *  @param arrMediaMsg 信息列表-删除依据为msgId
// *
// *  @return 操作状态
// */
//+(BOOL)delMediaMsg:(NSMutableArray *)arrMediaMsg;
//
//
//
//#pragma - make - 预警
//
///**
// *  获得报警信息-支持2个type
// *
// *  @param srtAccountId 用户id
// *  @param type         报警类型
// *
// *  @return 报警数据列表
// */
//+(NSMutableArray *)readAlertMsgListWithAccountId:(NSString *)srtAccountId
//                                      alertType1:(warningType)type1
//                                      alertType2:(warningType)type2;
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
//+(BOOL)insertAlertMsgWithList:(NSMutableArray *)arrList;
//
//
///**
// *  删除报警数据-支持批量删除 - 删除依据是msgId
// *
// *  @param arrList 数据列表
// *
// *  @return 操作状态
// */
//+(BOOL)delAlertMsgDataWithList:(NSMutableArray *)arrList;
//
///**
// *  更新预警信息-支持批量更新 - 更新数据的依据是msgId
// *
// *  @param arrList 数据列表
// *
// *  @return 操作状态
// */
//+(BOOL)updateAlertMsgDataWithList:(NSMutableArray *)arrList;
//
//
///**
// *  删除设备后，删除设备相关的报警信息，照片，视频
// *
// *  @param strDeviceID 设备ID
// *
// *  @return 操作状态
// */
//+(BOOL)DelAllDeviceMsgWithDeviceID:(NSString *)strDeviceID;
//
///**
// *  获得未读预警消息数量
// *
// *  @return 数量
// */
//+(int)getUNReadAlertNum;
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
//                      alertType2:(warningType)type2;
//
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
//             alertType2:(warningType)type2;

@end
