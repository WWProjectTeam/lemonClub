//
//  MyInfoViewController.h
//  Carcorder
//
//  Created by YF on 16/1/27.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_table;
}

@end
