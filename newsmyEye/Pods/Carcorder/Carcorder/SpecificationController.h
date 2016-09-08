//
//  SpecificationController.h
//  Carcorder
//
//  Created by YF on 16/2/29.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface SpecificationController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property(nonatomic,strong)IBOutlet UIWebView *specificationWeb;

@property(nonatomic,strong)IBOutlet UIButton *upButton;

@end
