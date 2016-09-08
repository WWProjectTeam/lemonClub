//
//  PhotoViewController.h
//  Carcorder
//
//  Created by YF on 16/1/7.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_table;
}
@end
