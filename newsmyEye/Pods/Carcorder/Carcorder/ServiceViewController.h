//
//  ServiceViewController.h
//  Carcorder
//
//  Created by YF on 15/12/31.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceViewController : UIViewController<UIWebViewDelegate>

@property(nonatomic,retain)IBOutlet UIWebView *serViceWeb;

@property(nonatomic,retain)IBOutlet UIButton *upButton;

@end
