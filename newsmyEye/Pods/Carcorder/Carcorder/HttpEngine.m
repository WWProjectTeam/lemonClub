//
//  HttpEngine.m
//  Carcorder
//
//  Created by YF on 16/1/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "HttpEngine.h"
#import "AFNetworking.h"
#import "ParserInfo.h"
#import "DataResultInfo.h"
#import "URLHeader.h"

@implementation HttpEngine


#pragma mark - inithttps
+(AFSecurityPolicy *)inithttps{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"security_server" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    return securityPolicy;

}

#pragma mark 用户登录
+(void)loginAccount:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];


    
    manager.securityPolicy = [self inithttps];

    
    
    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&password=%@&command=login",k_URL,info.accountID,info.psw];
    
    NSString *encodingStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array=[NSMutableArray array];
        
        ParserInfo *info=[ParserInfo loginAccountWithDic:(NSDictionary *)jsonDic];
        
        [array addObject:info];
        
        completion(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

#pragma mark 获取用户验证码
+(void)getCheckCode:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    
    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&command=%@",k_URL,info.accountID,info.command];
    
    NSString *encodingStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array=[NSMutableArray array];
        
        ParserInfo *info=[ParserInfo getCheckCodeWithDic:(NSDictionary *)jsonDic];
        
        NSLog(@"info============%@",info.Message);
        
        [array addObject:info];
        
        completion(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark 用户账号注册
+(void)registerAccount:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&password=%@&captcha=%@&command=create",k_URL,info.accountID,info.psw,info.confirmCode];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array=[NSMutableArray array];
        
        ParserInfo *info=[ParserInfo registerAccountWithDic:(NSDictionary *)jsonDic];
        
        [array addObject:info];
        
        completion(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 重置用户密码
+(void)resetAccountPsw:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    
    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&password=%@&captcha=%@&command=set_password",k_URL,info.accountID,info.psw,info.confirmCode];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array=[NSMutableArray array];
        
        ParserInfo *info=[ParserInfo resetAccountPswWithDic:(NSDictionary *)jsonDic];
        
        [array addObject:info];
        
        completion(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 查询一段时间设备轨迹
+(void)queryDeviceTrail:(AccountInfo *)info time:(QueryTimeInfo *)timeInfo and:(void(^)(NSDictionary *responseDic))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

//    NSString *urlStr=[NSString stringWithFormat:@"%@?a=%@&p=%@&d=%@&rf=%d&rt=%d&g=1&l=999",k_Track_URL,info.accountID,info.psw,info.deviceID,timeInfo.startDate,timeInfo.endDate];
//=======
    NSString *urlStr=[NSString stringWithFormat:@"%@?a=%@&p=%@&d=%@&rf=%d&rt=%d&g=1&l=999",k_Track_URL,info.accountID,info.psw,info.deviceID,timeInfo.startDate-28800,timeInfo.endDate-28800];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        completion((NSDictionary *)jsonDic);
        
        NSLog(@"请求成功了");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"请求失败了");
        
        }];
}

#pragma mark 查询设备电子围栏列表
+(void)queryDevicefenceList:(QueryTimeInfo *)info and:(void(^)(NSMutableArray *array))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&imei_number=%@&command=d_search_z",k_Device_URL,info.accountID,info.IMEI];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array=[NSMutableArray array];
        
        ParserInfo *info=[ParserInfo queryDeviceFenceListWithDic:(NSDictionary *)jsonDic];
        
        for (int i=0; i<info.MessageArr.count; i++)
        {
            NSDictionary *fenceDic=info.MessageArr[i];
            
            FenceInfo *fenceInfo=[FenceInfo queryFencetWithDic:fenceDic];
            
            [array addObject:fenceInfo];
        }
        
        completion(array);
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

#pragma mark 查询用户绑定设备列表
+(void)accountQueryDeviceList:(AccountInfo *)info and:(void(^)(NSMutableArray *array))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&command=get_device",k_URL,info.accountID];

    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *array=[NSMutableArray array];
        
        ParserInfo *info=[ParserInfo accountQueryDeviceListWithDic:(NSDictionary *)jsonDic];
        
        for (int i=0; i<info.MessageArr.count; i++)
        {
            NSDictionary *deviceDic=info.MessageArr[i];
            
            FenceInfo *deviceInfo=[FenceInfo queryDeviceWithDic:deviceDic];
            
            [array addObject:deviceInfo];
        }
        
        completion(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

#pragma mark 为用户解除一个设备绑定
+(void)unblindDevice:(QueryTimeInfo *)info and:(void(^)(NSMutableArray *array))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&imei_number=%@&command=a_delete_d",k_Device_URL,info.accountID,info.IMEI];
   
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array=[NSMutableArray array];
        completion(array);
        
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 发送消息
+(void)deviceSendMessage:(QueryTimeInfo *)info and:(void(^)(int code))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

//    NSString *urlStr=[NSString stringWithFormat:@"%@?device_id=%@&account_id=%@&message_type=4&message=%@&imei_number=%@&command=send_message",k_SendMsg_URL,info.deviceID,info.accountID,info.messageStr,info.IMEI];

    NSString *urlStr = [NSString stringWithFormat:@"%@?imei_number=%@&command=send_content&account_id=%@&message=%@",
                        k_SendMsg_URL, info.IMEI, info.accountID, info.messageStr];
    NSString *encodingStr=[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@" request : %@", encodingStr);
    
    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSDictionary *JSONDic=(NSDictionary *)jsonDic;
        
//        int resultCode=[JSONDic[@"result_code"] intValue];
        int resultCode=[JSONDic[@"result"] intValue];
       
        NSLog(@"request result = %d", resultCode);
        completion(resultCode);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark open video request
//   param.append(API.DEVICE).append("?device_id=").append(deviceInfo.getDevice_id()).append("&command=open_video")
//.append("&account_id=").append(accountInfo.getAccountId()).append("&imei_number=").append(deviceInfo.getImei_number());
+(void)deviceOpenVideo:(NSString *)account device:(NSString *)deviceId imei:(NSString *)imei
{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

//    NSString *urlStr=[NSString stringWithFormat:@"%@?device_id=%@&command=open_video&account_id=%@&imei_number=%@",
//                      k_Device_URL,deviceId, account, imei];
    NSString *urlStr=[NSString stringWithFormat:@"%@?command=open_video&account_id=%@&imei_number=%@",
                      k_SendMsg_URL, account, imei];
    NSLog(@"open video : %@", urlStr);
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSJSONSerialization * jsonResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * jsonObject = (NSDictionary *)jsonResult;
        NSLog(@"open video successful, result = %@", jsonObject[@"result"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"open video failed");
    }];
}

#pragma mark 查询用户绑定设备Session编号
+(void)deviceQueryDeviceSessionID:(QueryTimeInfo *)info and:(void(^)(NSString *str))completion
{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&imei_number=%@&command=get_session",k_Device_URL,info.accountID,info.IMEI];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSDictionary *JSONDic=(NSDictionary *)jsonDic;
        
        NSString *ssidDic=JSONDic[@"session_id"];
        
        completion(ssidDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 查询流量
+(void)queryFlowInfo:(FenceInfo *)info and:(void(^)(NSDictionary *dic))completion
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

     NSString *urlStr=[NSString stringWithFormat:@"%@?account_id=%@&command=query_device_usage&imei_number=%@",k_Device_URL,info.AccountID,info.IMEI];
    
    NSString *encodingStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *JSONDic=(NSDictionary *)jsonDic;
        
        NSDictionary *msgDic=JSONDic[@"message"];

        completion(msgDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//流量升级时获取套餐列表
+(void)getUpdatePackageListInfo:(FenceInfo *)info and:(void(^)(NSDictionary *dic))completion{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?command=getTrafficUpgradeList&imeiNumber=%@",K_RatePlane_URL,info.IMEI];
    
    NSString *encodingStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *JSONDic=(NSDictionary *)jsonDic;
        
      //  NSDictionary *msgDic=JSONDic[@"data"];
        
        completion(JSONDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

//购买套餐获取套餐列表
+(void)getpurchasePackageListInfo:(FenceInfo *)info and:(void(^)(NSDictionary *dic))completion{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?command=getPackageChangeList&imeiNumber=%@",K_RatePlane_URL,info.IMEI];
    
    NSString *encodingStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *JSONDic=(NSDictionary *)jsonDic;
        
       // NSDictionary *msgDic=JSONDic[@"data"];
        
        completion(JSONDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


//获得支付配置
+(void)getPayConfigMsgRatePlan:(NSString *)ratePlan operType:(NSString *)operType imeiNumber:(NSString *)imeiNumber and:(void(^)(NSDictionary *dic))completion{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    manager.securityPolicy = [self inithttps];

    NSString *urlStr=[NSString stringWithFormat:@"%@?imeiNumber=%@&command=order&ratePlan=%@&operType=%@",K_RatePlane_URL,imeiNumber,ratePlan,operType];
    
    NSString *encodingStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSJSONSerialization *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *JSONDic=(NSDictionary *)jsonDic;
        
        // NSDictionary *msgDic=JSONDic[@"data"];
        
        completion(JSONDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

@end
