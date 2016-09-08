//
//  QueryTimeInfo.h
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryTimeInfo : NSObject

@property(nonatomic,assign)int startDate,endDate;

@property(nonatomic,copy)NSString *accountID;

@property(nonatomic,copy)NSString *IMEI;

@property(nonatomic,copy)NSString *deviceID,*messageStr;

@end
