//
//  AccountResult.h
//  Carcorder
//
//  Created by EthanZhang on 15/12/8.
//  Copyright © 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountResult : NSObject

@property (copy, nonatomic) NSString * accountID;
@property (assign, nonatomic) NSUInteger flag;
@property (copy, nonatomic) NSString * message;

@end
