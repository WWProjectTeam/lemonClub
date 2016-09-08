//
//  WWUrlProfile.h
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#ifndef WWUrlProfile_h
#define WWUrlProfile_h

//服务器地址配置

#ifdef DEBUG
#   define ServiceDomain @"https://device.newsmycloud.cn:9100"
#   define ServicePath   @"/srm/"
#   define LOCALHOST     NSString stringWithFormat:@"%@%@",ServiceDomain,ServicePath]

#else
#   define ServiceDomain @"http://192.168.3.99:8080"
#   define ServicePath   @"/srm/"
#   define LOCALHOST     NSString stringWithFormat:@"%@%@",ServiceDomain,ServicePath]

#endif



//接口地址配置
#define UserLoginApiPath @"account/login"

#endif /* WWUrlProfile_h */
