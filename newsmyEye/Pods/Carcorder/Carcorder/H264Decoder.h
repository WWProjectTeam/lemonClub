//
//  H264Decoder.h
//  PPCS_Client
//
//  Created by EthanZhang on 15/9/1.
//  Copyright (c) 2015年 internet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPackage.h"
#import <CoreVideo/CVPixelBuffer.h>

@interface H264Decoder : NSObject
-(void)setSPS:(VideoPackage *)vp;
-(uint8_t*) getSPS;
-(NSInteger)getSPSSize;
-(void)setPPS:(VideoPackage *)vp;
-(uint8_t*) getPPS;
-(NSInteger)getPPSSize;

-(BOOL)initDecoder;
-(void)clearDecoder;
-(CVPixelBufferRef)decode:(VideoPackage *)vp;
@end
