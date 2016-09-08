//
//  CheckViewController.h
//  Carcorder
//
//  Created by YF on 16/1/18.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Media.h"

@interface CheckViewController : UIViewController

@property(strong,nonatomic)UIImage *mediaImg;

@property(strong,nonatomic)NSURL *mediaUrl;

@property(retain,nonatomic)IBOutlet UIImageView *checkImgView;

@end
