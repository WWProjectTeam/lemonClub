//
//  ServiceViewController.m
//  Carcorder
//
//  Created by YF on 15/12/31.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import "ServiceViewController.h"
#import "RegisterViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"《纽眼》服务协议";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};
    
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_back-iOS7@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    
    //向四周延伸的方法,如果设置为NO,则滑动视图时不能穿过导航栏底下
    //self.edgesForExtendedLayout=NO;
    
    //自动适应,滑动视图时可以穿过导航栏底下
    //self.automaticallyAdjustsScrollViewInsets=YES;
    
    self.serViceWeb.scrollView.bounces=NO;
    
    self.serViceWeb.scalesPageToFit = YES;

    //Opaque:不透明的
    [self.serViceWeb setOpaque:YES];
    
    for (UIScrollView* view in self.serViceWeb.subviews)
    {
        
        view.showsHorizontalScrollIndicator=YES;
        
        view.showsVerticalScrollIndicator=YES;
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            view.hidden=YES;
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"注册协议--纽眼-v3.pdf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.serViceWeb loadRequest:request];
    self.tabBarController.tabBar.hidden=YES;

}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 回到顶部
- (IBAction)upButton:(id)sender
{
    [self.upButton setBackgroundImage:[UIImage imageNamed:@"置顶"] forState:UIControlStateNormal];
    
    [self.upButton setBackgroundImage:[UIImage imageNamed:@"置顶_d"] forState:UIControlStateHighlighted];
    
    //webView回到顶部的方法
    if ([self.serViceWeb subviews])
    {
        
        UIScrollView *scrollView = [[self.serViceWeb subviews] objectAtIndex:0];
        
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
