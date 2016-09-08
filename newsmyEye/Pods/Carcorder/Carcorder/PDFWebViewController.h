//
//  PDFWebViewController.h
//  Carcorder
//
//  Created by YF on 16/3/3.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFWebViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,strong)IBOutlet UIWebView *helpWeb;

@property(nonatomic,strong)IBOutlet UIButton *upButton;

@end
