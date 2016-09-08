//
//  HttpEngine.h
//  Carcorder
//
//  Created by YF on 16/1/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInfo.h"
#import "FenceInfo.h"
#import "QueryTimeInfo.h"

@interface HttpEngine : NSObject

+(void)loginAccount:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion failure:(void(^)(NSError *error))failure;

+(void)getCheckCode:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion;

+(void)registerAccount:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion;

+(void)resetAccountPsw:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion;

+(void)queryDeviceTrail:(AccountInfo *)info time:(QueryTimeInfo *)timeInfo and:(void(^)(NSDictionary *responseDic))completion;

+(void)queryDevicefenceList:(QueryTimeInfo *)info and:(void(^)(NSMutableArray *array))completion;

+(void)accountQueryDeviceList:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion;

+(void)unblindDevice:(QueryTimeInfo *)info and:(void(^)(NSMutableArray *array))completion;

+(void)deviceSendMessage:(QueryTimeInfo *)info and:(void(^)(int code))completion;

+(void)deviceQueryDeviceSessionID:(QueryTimeInfo *)info and:(void(^)(NSString *str))completion;

+(void)queryFlowInfo:(FenceInfo *)info and:(void(^)(NSDictionary *dic))completion;

+(void)deviceOpenVideo:(NSString *)account device:(NSString *)deviceId imei:(NSString *)imei;

//流量升级时获取套餐列表
+(void)getUpdatePackageListInfo:(FenceInfo *)info and:(void(^)(NSDictionary *dic))completion;

//购买套餐获取套餐列表
+(void)getpurchasePackageListInfo:(FenceInfo *)info and:(void(^)(NSDictionary *dic))completion;


//获得支付配置
+(void)getPayConfigMsgRatePlan:(NSString *)ratePlan operType:(NSString *)operType imeiNumber:(NSString *)imeiNumber and:(void(^)(NSDictionary *dic))completion;
@end
