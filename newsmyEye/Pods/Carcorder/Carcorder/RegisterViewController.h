//
//  RegisterViewController.h
//  Carcorder
//
//  Created by YF on 15/12/24.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"

@interface RegisterViewController :ShareViewController<UITextFieldDelegate>
{
    BOOL isCertain;
}

@property(nonatomic,retain)UIButton *serviceBtn;

@property(nonatomic,retain)UIView *serViceView;

@end
