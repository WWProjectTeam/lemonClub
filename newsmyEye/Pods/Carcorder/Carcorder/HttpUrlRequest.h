//
//  HttpUrlRequest.h
//  Carcorder
//
//  Created by L on 15/8/5.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUrlRequest : NSObject

+ (void)post:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;//post请求封装
@end
