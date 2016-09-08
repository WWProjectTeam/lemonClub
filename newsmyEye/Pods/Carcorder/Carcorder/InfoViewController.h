//
//  InfoViewController.h
//  Carcorder
//
//  Created by YF on 16/1/19.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface InfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *_table;

    int _keyBoardHeight;
    
    BOOL isLocation;
}

//@property(nonatomic,retain)IBOutlet UIView *textBgView;
//
//@property(nonatomic,retain)IBOutlet UITextField *sendMessageTF;
//
//@property(nonatomic,strong)IBOutlet UIButton *locationBtn;

@end
