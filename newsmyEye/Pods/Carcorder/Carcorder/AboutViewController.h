//
//  AboutViewController.h
//  Carcorder
//
//  Created by YF on 16/1/18.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_table;
}

@property(nonatomic,strong)IBOutlet UILabel *allowLab;

@end
