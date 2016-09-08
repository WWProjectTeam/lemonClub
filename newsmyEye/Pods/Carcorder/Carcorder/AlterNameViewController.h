//
//  AlterNameViewController.h
//  Carcorder
//
//  Created by YF on 16/1/15.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterNameViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)IBOutlet UITextField *nameTF;

@property(nonatomic,retain)IBOutlet UIImageView *nameLine;

@end
