//
//  WWServiceRespCodeProfile.h
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#ifndef WWServiceRespCodeProfile_h
#define WWServiceRespCodeProfile_h

#define MESSAGE_SUCCESS  1000//成功

#define MESSAGE_FAIL  1001//失败

#define MESSAGE_PHONE_NUMBER_EXIST  1002//手机号已经存在

#define MESSAGE_DEVICE_BIND_EXIST 1003	//改设备已绑定其他账户

#define MESSAGE_PHONE_NUMBER_NOT_EXIST  1004//手机号不存在

#define MESSAGE_CAPTCHA_WRONG  1005//验证码错误

#define MESSAGE_CAPTCHA_INVALIDATION  1006 //验证码失效

#define MESSAGE_ACCOUNT_NOT_EXIST   1007//账号不存在

#define MESSAGE_NO_LINKED_ACCOUNT_FOR_THRID_PARTY_ACCOUNT  1008//没有关联的账号

#define MESSAGE_BINDING_NEED_TO_VERIFY   1009 //绑定需要主账号验证

#define MESSAGE_BIND_DEVICE_NEED_CAPTCHA  1010 //绑定设备需要验证码

#define MESSAGE_DEVICE_NOT_EXIST  1011	//设备不存在

#define MESSAGE_DEVICE_NOT_BINDING_ACCOUNT  1012 //该账号与该设备不存在绑定关系
#define MESSAGE_ACCOUNT_PASSWORD_WRONG  1013//密码错误
#define MESSAGE_NEED_CAPTCHA  1014//请点击获取验证码
#define DEVICEUNBINDED        1016   //设备未绑定
#define ACCOUNTBINDDEVICE  1017  //该账号已绑定该设备
#define RESULT_STRING   @"result"

#define CREATE_ACCOUNT   0

#define CHANGE_PASSWORD   1

#define BINDING_PRIMARY_ACCOUNT   1	//设备绑定主账号

#define BINDING_DEPUTY_ACCOUNT    2	//设备绑定副账号

#endif /* WWServiceRespCodeProfile_h */
