//
//  AlarmViewController.h
//  Carcorder
//
//  Created by YF on 16/1/19.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *_table;
}

@property(nonatomic,strong)IBOutlet UIView *headerView;

@property (strong) NSString * strDeviceId;

@end
