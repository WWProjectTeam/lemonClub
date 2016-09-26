//
//  SWMessageViewController.h
//  newsmyEye
//
//  Created by push on 16/9/11.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWMessageViewController : UIViewController

@property (strong) UIScrollView *messageBackScrollview;
@property (strong) UITableView  *myMessageTableView;
@property (strong) NSMutableArray   *myMessageArray;
@property (strong) UITableView  *sysMessageTableView;
@property (strong) NSMutableArray   *sysMessageArray;

@end
