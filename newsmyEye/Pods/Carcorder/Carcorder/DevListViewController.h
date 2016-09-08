//
//  DevListViewController.h
//  Carcorder
//
//  Created by YF on 16/3/17.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DevListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property (nonatomic,strong)UITableView *tableView;

@end
