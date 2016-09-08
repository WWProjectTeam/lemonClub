//
//  PDFWebViewController.m
//  Carcorder
//
//  Created by YF on 16/3/3.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "PDFWebViewController.h"

@interface PDFWebViewController ()

@end

@implementation PDFWebViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"帮助";

    self.helpWeb.scrollView.bounces=NO;
    
    self.helpWeb.scalesPageToFit = YES;
    
    //Opaque:不透明的
    [self.helpWeb setOpaque:YES];
    
    for (UIScrollView *view in self.helpWeb.subviews)
    {
        view.showsHorizontalScrollIndicator=YES;
        
        view.showsVerticalScrollIndicator=YES;
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            view.hidden=YES;
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"纽眼手机客户端v1.0.2——操作手册（IOS）.pdf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.helpWeb loadRequest:request];
    
}
- (IBAction)upButtonClick:(id)sender
{
    [self.upButton setBackgroundImage:[UIImage imageNamed:@"置顶"] forState:UIControlStateNormal];
    
    [self.upButton setBackgroundImage:[UIImage imageNamed:@"置顶_d"] forState:UIControlStateHighlighted];
    
    //webView回到顶部的方法
    if ([self.helpWeb subviews])
    {
        UIScrollView *scrollView = [[self.helpWeb subviews] objectAtIndex:0];
        
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
