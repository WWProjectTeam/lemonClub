//
//  ZPDFPageController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageController.h"
#import "ZPDFView.h"

@interface ZPDFPageController ()
{
    ZPDFView *pdfView;
}
@end

@implementation ZPDFPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
  

    self.edgesForExtendedLayout=NO;
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    pdfView = [[ZPDFView alloc] initWithFrame:frame atPage:self.pageNO withPDFDoc:self.pdfDocument];
    NSLog(@"pageNo====%lu",(unsigned long)self.pageNO);
    pdfView.backgroundColor=[UIColor whiteColor];
    [pdfView setMultipleTouchEnabled:YES];
    [pdfView setUserInteractionEnabled:YES];
    oldFrame = pdfView.frame;
    largeFrame = CGRectMake(-50, -100, 2 * oldFrame.size.width, 2 * oldFrame.size.height);
    
    NSUInteger pageNO=self.pageNO;
    UILabel *pageLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30)];
    pageLabel.backgroundColor=[UIColor clearColor];
    pageLabel.text=[NSString stringWithFormat:@"%lu/16",(unsigned long)pageNO];
    pageLabel.textAlignment=NSTextAlignmentCenter;
    pageLabel.textColor=[UIColor blackColor];
    pageLabel.font=[UIFont boldSystemFontOfSize:13.0];
    
    //[self addGestureRecognizerToView:pdfView];
    [self.view addSubview:pdfView];
    [self.view addSubview:pageLabel];
    
}

// 添加所有的手势
-(void)addGestureRecognizerToView:(UIView *)view
{
    // 拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
}

// 处理拖动手势
-(void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

// 处理缩放手势
-(void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
       
        if (pdfView.frame.size.width < oldFrame.size.width)
        {
            //让视图无法缩得比原视图小
            pdfView.frame = oldFrame;
        }
        if (pdfView.frame.size.width > 1.5 * oldFrame.size.width)
        {
            pdfView.frame = largeFrame;
        }
        
        pinchGestureRecognizer.scale = 1;
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
