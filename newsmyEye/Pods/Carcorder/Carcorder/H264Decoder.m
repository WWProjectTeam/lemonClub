//
//  H264Decoder.m
//  PPCS_Client
//
//  Created by EthanZhang on 15/9/1.
//  Copyright (c) 2015年 internet. All rights reserved.
//

#import "H264Decoder.h"
#import "VideoPackage.h"
#import <VideoToolbox/VideoToolbox.h>
#import <UIKit/UIKit.h>

@interface H264Decoder() {
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
    VTDecompressionSessionRef _decoderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
}
@end

static void didDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

@implementation H264Decoder
-(void)setSPS:(VideoPackage *)vp
{
    _spsSize = vp.size - 4;
    _sps = malloc(_spsSize);
    memset(_sps, 0, _spsSize);
    memcpy(_sps, vp.buffer + 4, _spsSize);
}
-(uint8_t*)getSPS
{
    return _sps;
}
-(NSInteger)getSPSSize
{
    return _spsSize;
}


-(void)setPPS:(VideoPackage *)vp
{
    _ppsSize = vp.size - 4;
    _pps = malloc(_ppsSize);
    memset(_pps, 0, _ppsSize);
    memcpy(_pps, vp.buffer + 4, _ppsSize);
}
-(uint8_t*)getPPS
{
    return _pps;
}
-(NSInteger)getPPSSize
{
    return _ppsSize;
}

-(BOOL)initDecoder
{
    if (_decoderSession)
        return YES;
    if (_spsSize == 0 || _ppsSize == 0)
        return FALSE;
    
    const uint8_t* const parameterSetPointers[2] = {_sps, _pps};
    const size_t parameterSetSizes[2] = {_spsSize, _ppsSize};
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                          2,
                                                                          parameterSetPointers,
                                                                          parameterSetSizes,
                                                                          4,
                                                                          &_decoderFormatDescription);

    if (status == noErr) {
        CFDictionaryRef attrs = NULL;
        const void * keys[] = {kCVPixelBufferPixelFormatTypeKey};
        uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
        const void * values[] = {CFNumberCreate(NULL, kCFNumberSInt32Type, &v)};
        attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        
        VTDecompressionOutputCallbackRecord callbackRecord;
        callbackRecord.decompressionOutputCallback = didDecompress;
        callbackRecord.decompressionOutputRefCon = NULL;
        
        status = VTDecompressionSessionCreate(kCFAllocatorDefault, _decoderFormatDescription, NULL, attrs, &callbackRecord, &_decoderSession);
        CFRelease(attrs);
    } else {
        NSLog(@"IOS8VT: reset decoder session failed status=%d", status);
    }
    return YES;
}


-(void)clearDecoder {
    if(_decoderSession) {
        VTDecompressionSessionInvalidate(_decoderSession);
        CFRelease(_decoderSession);
        _decoderSession = NULL;
    }
    
    if(_decoderFormatDescription) {
        CFRelease(_decoderFormatDescription);
        _decoderFormatDescription = NULL;
    }
    
    free(_sps);
    free(_pps);
    _spsSize = _ppsSize = 0;
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bytesPerRow = width * 4;
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);

    
    return (image);
}

-(CVPixelBufferRef)decode:(VideoPackage *)vp
{
    CVPixelBufferRef outputPixelBuffer = NULL;
    CMBlockBufferRef blockBuffer = NULL;
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                          (void*)vp.buffer, vp.size,
                                                          kCFAllocatorNull,
                                                          NULL, 0, vp.size,
                                                          0, &blockBuffer);
    if (status == kCMBlockBufferNoErr) {
        CMSampleBufferRef sampleBuffer = NULL;
        const size_t sampleSizeArray[] = {vp.size};
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           blockBuffer,
                                           _decoderFormatDescription,
                                           1, 0, NULL, 1,
                                           sampleSizeArray,
                                           &sampleBuffer);
        if (status == kCMBlockBufferNoErr && sampleBuffer) {
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_decoderSession,
                                                                      sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            if(decodeStatus == kVTInvalidSessionErr) {
                NSLog(@"IOS8VT: Invalid session, reset decoder session");
                outputPixelBuffer = NULL;
            } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
                NSLog(@"IOS8VT: decode failed status=%d(Bad data)", decodeStatus);
                outputPixelBuffer = NULL;
            } else if(decodeStatus != noErr) {
                NSLog(@"IOS8VT: decode failed status=%d", decodeStatus);
                outputPixelBuffer = NULL;
            }
            
            CFRelease(sampleBuffer);
        }
        CFRelease(blockBuffer);
    }
    return outputPixelBuffer;
}
@end
