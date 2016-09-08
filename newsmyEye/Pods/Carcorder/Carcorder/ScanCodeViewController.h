//
//  ScanfImageViewController.h
//  AlterViewDemo
//
//  Created by 红尘 on 15/8/12.
//  Copyright (c) 2015年 红尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanCodeViewController : UIViewController


@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@end
