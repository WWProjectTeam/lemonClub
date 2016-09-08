//
//  DecodeCallback.h
//  iOSVideoPlay
//
//  Created by EthanZhang on 15/9/2.
//  Copyright (c) 2015年 EthanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CVPixelBuffer.h>

@protocol P2PListener <NSObject>
@required
-(void)onPixelBufferAvaiable:(CVPixelBufferRef)buffer;

@required
-(void)onP2PConnectting;

@required
-(void)onP2PConnected;

@required
-(void)onP2PConnectionError;

@required
-(void)onP2PDisConnected;
@end
