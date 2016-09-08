//
//  Message.h
//  Carcorder
//
//  Created by EthanZhang on 16/2/19.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic) NSInteger id;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *device;
@property(nonatomic) NSInteger type;
@property(nonatomic) NSInteger point_or_text;
@property(nonatomic,strong) NSString *time;
@end
