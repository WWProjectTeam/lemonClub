//
//  UIScanCodeViewController.m
//  newsmy_smarthome_securitydevice_ios
//
//  Created by yangyong on 16/4/7.
//  Copyright © 2016年 EthanZhang. All rights reserved.
//

#import "UIScanCodeViewController.h"
#import "UIView+Toast.h"

@interface UIScanCodeViewController ()

@end

@implementation UIScanCodeViewController
{
    ZBarReaderView *readview;
    UIImageView *scanZomeBack;
    UIImageView *readLineView;
    BOOL is_Anmotion;
    UILabel *word;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"二维码扫描";
}
-(void)viewWillAppear:(BOOL)animated
{
    [self InitScan];
    [self loopDrawLine];
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)InitScan
{
    readview = [ZBarReaderView new];
    readview.backgroundColor = [UIColor clearColor];
    readview.frame=CGRectMake(0, 0, kScreen_width, kScreen_height+48);
     [self.view addSubview:readview];
    readview.readerDelegate = self;
    readview.torchMode=0;
    readview.allowsPinchZoom = YES;//使用手势变焦
    readview.trackingColor = [UIColor redColor];
    readview.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示
    readview.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
    
    UIImage *hbImage=[UIImage imageNamed:@"scan_bg"];
    scanZomeBack=[[UIImageView alloc] initWithImage:hbImage];
    //将被扫描的图像的区域

   scanZomeBack.frame=CGRectMake((readview.bounds.size.width-200)/2,(readview.bounds.size.height-200-112)/2,200, 200);
    [readview addSubview:scanZomeBack];
    readview.scanCrop = [self getScanCrop:scanZomeBack.frame readerViewBounds:readview.bounds];
    [readview start];
   
}

#pragma mark 扫描动画
-(void)loopDrawLine
{
    CGRect  rect = CGRectMake(scanZomeBack.frame.origin.x, scanZomeBack.frame.origin.y, scanZomeBack.frame.size.width, 2);
    if (readLineView) {
        [readLineView removeFromSuperview];
    }
    readLineView = [[UIImageView alloc] initWithFrame:rect];
    [readLineView setImage:[UIImage imageNamed:@"scan_line"]];
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改fream的代码写在这里
                         readLineView.frame =CGRectMake(scanZomeBack.frame.origin.x, scanZomeBack.frame.origin.y+scanZomeBack.frame.size.height, scanZomeBack.frame.size.width, 2);
                         [readLineView setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         if (!is_Anmotion) {
                             
                             [self loopDrawLine];
                         }
                         
                     }];
    if(readLineView.frame.origin.x!=0)
    {
        [readview addSubview:readLineView];
    }
     readview.scanCrop = [self getScanCrop:scanZomeBack.frame readerViewBounds:readview.bounds];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
        // 是否QR二维码
    }
    
    // 第一步,创建URL
    NSString *strurl = [NSString stringWithFormat:@"%@track/api/device.jsp",localhost];
    NSURL *url = [NSURL URLWithString:strurl];
    
    // 第二步,创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];// 设置请求方式为POST,默认为GET
    NSString *str = [NSString stringWithFormat:@"account_id=%@&imei_number=%@&command=a_bundling_d",[USER objectForKey:@"userName"],symbolStr];// 设置参数
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
        [self.view makeToast:@"正在处理" duration:3 position:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        NSString *mesgStr = dict[@"message"];
               [self.view makeToast:mesgStr duration:2.0 position:nil];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:2];
    }

}
- (void) readerViewDidStart: (ZBarReaderView*) readerView
{
    
}
- (void) readerView: (ZBarReaderView*) readerView
   didStopWithError: (NSError*) error
{
    
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
