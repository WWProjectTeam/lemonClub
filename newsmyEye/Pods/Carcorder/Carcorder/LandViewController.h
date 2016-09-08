//
//  LandViewController.h
//  Carcorder
//
//  Created by YF on 15/12/29.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LandViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
 
    BOOL isPswHighLighted;
    
    BOOL isCancel;
    
    BOOL isSecretEntry;
    
    int _keyBoardHeight;

}

@property(nonatomic,retain)IBOutlet UITextField *accountTF;

@property(nonatomic,retain)IBOutlet UITextField *pswTF;

@property(nonatomic,retain)IBOutlet UIButton *accountImgBtn;

@property(nonatomic,retain)IBOutlet UIButton *pswImgBtn;

@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;

@property(nonatomic,retain)IBOutlet UIButton *secretEntryBtn;

@property(nonatomic,retain)IBOutlet UIButton *loginBtn;

@property(nonatomic,retain)IBOutlet UIImageView *accountLine;

@property(nonatomic,retain)IBOutlet UIImageView *pswLine;

@property(nonatomic,retain)IBOutlet UIButton *registerBtn,*finderBtn;

@end
