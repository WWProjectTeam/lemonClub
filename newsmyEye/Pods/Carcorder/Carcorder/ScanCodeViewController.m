//
//  ScanfImageViewController.m
//  AlterViewDemo
//
//  Created by 红尘 on 15/8/12.
//  Copyright (c) 2015年 红尘. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "UIView+Toast.h"
#import <QuartzCore/CABase.h>

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHigh  [UIScreen mainScreen].bounds.size.height
static CGFloat const kRadius = 100;

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ScanCodeViewController
{
    NSTimer *timer;
    CALayer *_scanLayer;
    UIView *_boxView;
    UIView  *_viewPreview;
    NSString *stringValue;
    UIView *holeView;
    CGRect bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"二维码扫描";
    _viewPreview = [[UIView alloc]initWithFrame:self.view.bounds];
    _viewPreview.backgroundColor = [UIColor clearColor];
    _viewPreview.autoresizingMask = 0;
    [self.view addSubview:_viewPreview];
    [self setupCamera];
    [self addHoleSubview];
    
    /*
    UIButton *LButton = [[UIButton alloc]init];
    LButton.frame = CGRectMake(20, 40, 18, 18);
    [LButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [LButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:LButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    */
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] init];
    
    backBarItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backBarItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHoleSubview
{
    holeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10000, 10000)];
    holeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    holeView.autoresizingMask = 0;
    [self.view addSubview:holeView];
    [self addMaskToHoleView];
}
- (void)addMaskToHoleView
{
    bounds = holeView.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGRect const circleRect = CGRectMake(CGRectGetMidX(bounds) - kRadius, CGRectGetMidY(bounds) - kRadius, 2 * kRadius, 2 * kRadius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:circleRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    holeView.layer.mask = maskLayer;
    //设置遮罩层的位置
    holeView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    

    //扫面框
    //_boxView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 2, self.view.bounds.size.width /2)];
    
    _boxView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(bounds) - kRadius,CGRectGetMidY(bounds) - kRadius,2 * kRadius, 2 * kRadius)];
    _boxView.center = self.view.center;
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    [_viewPreview addSubview:_boxView];
    
    CGSize size = self.view.bounds.size;
    CGRect cropRect = _boxView.frame;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; // 使用了1080p的图像输出
    
    if (p1 < p2)
    {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight, cropRect.origin.x/size.width, cropRect.size.height/fixHeight, cropRect.size.width/size.width);
    }
    else
    {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height, (cropRect.origin.x + fixPadding)/fixWidth, cropRect.size.height/size.height, cropRect.size.width/fixWidth);
    }
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        self.output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    }
    
    // _output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    
    // 条码类型 AVMetadataObjectTypeQRCode
    // _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode] ;
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    //_preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_viewPreview.layer insertSublayer:self.preview atIndex:0];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    // Start
    [_session startRunning];
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y)
    {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }
    else
    {
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        // 第一步,创建URL
        NSString *strurl = [NSString stringWithFormat:@"%@track/api/device.jsp",localhost];
        NSURL *url = [NSURL URLWithString:strurl];
        
        // 第二步,创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];// 设置请求方式为POST,默认为GET
        NSString *str = [NSString stringWithFormat:@"account_id=%@&imei_number=%@&command=a_bundling_d",[USER objectForKey:@"userName"],stringValue];// 设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        // 第三步,连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (received==nil)
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有网络,退出程序!" delegate:nil    cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [view show];
            
            return;
        }
        
        NSString *str1 = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str1);
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *result = [[dict valueForKey:@"flag"] stringValue];
        NSString *pd = @"1";
        if ([result isEqualToString:pd])
        {
            /*
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备绑定成功!" delegate:nil    cancelButtonTitle:@"确定"   otherButtonTitles:nil];
            [view show];
            
            [self.navigationController popViewControllerAnimated:YES];
            */
             
            /*
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"设备绑定成功!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *certainAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

            }];
            
            [alert addAction:certainAction];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            */
             
            [self.view makeToast:@"正在处理" duration:3 position:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            /*
            NSString *mesgStr = dict[@"message"];
            UIAlertView*view = [[UIAlertView alloc]initWithTitle:@"提示" message:mesgStr       delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [view show];
            */
            
            NSString *mesgStr = dict[@"message"];
            
            /*
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:mesgStr preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *certainAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            }];
            
            [alert addAction:certainAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            */
            
            [self.view makeToast:mesgStr duration:2.0 position:nil];
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:2];
        }
        
    }
    
    [_session stopRunning];
    
    /*
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"结果：%@",stringValue] delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了",@"重新扫描",nil];
    [alert show];
    */
}

-(void) popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^
         {
             [timer invalidate];
         }];
        //[timer invalidate];
        [_session startRunning];
    }
    else
    {
        [_session startRunning];
    }
}


@end
