//
//  ShareViewController.h
//  Carcorder
//
//  Created by YF on 15/12/31.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface ShareViewController : UIViewController <UITextFieldDelegate,MBProgressHUDDelegate>

@property(nonatomic,retain)IBOutlet UITextField *accountTF;

@property(nonatomic,retain)IBOutlet UITextField *confirmCodeTF;

@property(nonatomic,retain)IBOutlet UITextField *pswTF;

@property(nonatomic,retain)IBOutlet UITextField *certainPswTF;

@property(nonatomic,retain)IBOutlet UIImageView *accountLine;

@property(nonatomic,retain)IBOutlet UIImageView *codeLine;

@property(nonatomic,retain)IBOutlet UIImageView *pswLine;

@property(nonatomic,retain)IBOutlet UIImageView *certainPswLine;

@property(nonatomic,retain)IBOutlet UIButton *getCodeBtn;

@property(nonatomic,retain)IBOutlet UIButton *shareBtn;

@property(nonatomic,retain)UIButton *protocolBtn;

@property(nonatomic,retain)UILabel *proLabel;

-(BOOL)checkTelNumber:(NSString *)telNumber;

-(BOOL)checkPassword:(NSString *)password;

@end
