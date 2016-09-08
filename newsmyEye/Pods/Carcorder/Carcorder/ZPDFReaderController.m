//
//  ZPDFReaderController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFReaderController.h"
#import "ZPDFPageController.h"

@interface ZPDFReaderController ()

@end

@implementation ZPDFReaderController

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"帮助";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, NULL);
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
  
    pdfPageModel = [[ZPDFPageModel alloc] initWithPDFDocument:pdfDocument];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:  UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];

    ZPDFPageController *initialVC = [pdfPageModel viewControllerAtIndex:1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    [pageViewCtrl setDataSource:pdfPageModel];
    [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward|UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL f){}];
    
    [self addChildViewController:pageViewCtrl];
    [self.view addSubview:pageViewCtrl.view];
    [pageViewCtrl didMoveToParentViewController:self];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
