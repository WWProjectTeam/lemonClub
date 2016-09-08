//
//  PerInfoViewController.h
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    IBOutlet UITableView *_table;
}
@end
