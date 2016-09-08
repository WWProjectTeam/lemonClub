//
//  SpecificationController.m
//  Carcorder
//
//  Created by YF on 16/2/29.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "SpecificationController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface SpecificationController ()

@end

@implementation SpecificationController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    
    [self.navigationController.navigationBar addSubview:_progressView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
    
     [_progressView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"说明书";
    
    UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWeb)];
    
    self.navigationItem.rightBarButtonItem=rightBarItem;
    
    self.specificationWeb.scrollView.bounces=NO;
    
    self.specificationWeb.scalesPageToFit = YES;
    
    //Opaque:不透明的
    [self.specificationWeb setOpaque:YES];
    
    for (UIScrollView* view in self.specificationWeb.subviews)
    {
        view.showsHorizontalScrollIndicator=YES;
        
        view.showsVerticalScrollIndicator=YES;
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            view.hidden=YES;
        }
    }
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _specificationWeb.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.0f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadWeb];
}

-(void)loadWeb
{    
    NSString *urlStr=@"http://device.newsmycloud.cn:8080/manual/newman_H3.1_S7.k86a.93_operation.html";
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    if ([self isConnectionAvailable])
    {
        [self.specificationWeb loadRequest:request];
    }
}

-(void)reloadWeb
{
    [self.specificationWeb reload];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    //加载显示pdf文档标题
    //self.title = [self.specificationWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self.specificationWeb stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='250%'"];
}

-(BOOL)isConnectionAvailable
{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"页面加载失败,请重新加载", nil);
        hud.minSize = CGSizeMake(100.0f, 50.0f);
        [hud hide:YES afterDelay:3.0];
        return NO;
    }
    
    return isExistenceNetwork;
}

- (IBAction)upButtonClick:(id)sender
{
    [self.upButton setBackgroundImage:[UIImage imageNamed:@"置顶"] forState:UIControlStateNormal];
    
    [self.upButton setBackgroundImage:[UIImage imageNamed:@"置顶_d"] forState:UIControlStateHighlighted];
    
    //webView回到顶部的方法
    if ([self.specificationWeb subviews])
    {
        
        UIScrollView *scrollView = [[self.specificationWeb subviews] objectAtIndex:0];
        
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
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
