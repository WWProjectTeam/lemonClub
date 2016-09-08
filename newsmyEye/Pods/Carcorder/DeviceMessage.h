//
//  DeviceMessage.h
//  Carcorder
//
//  Created by EthanZhang on 15/12/8.
//  Copyright © 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceMessage : NSObject

@property (copy, nonatomic) NSString * message;
@property (assign, nonatomic) NSUInteger type;

@end
