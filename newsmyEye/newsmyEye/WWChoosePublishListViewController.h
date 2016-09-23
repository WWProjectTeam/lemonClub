//
//  WWChoosePublishListViewController.h
//  newsmyEye
//
//  Created by songs on 16/9/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWChoosePublishListViewController : UIViewController

@property (nonatomic,strong) void (^cellSelectBlock)(NSString *name, NSString *tagIndex);

@property (strong)UITableView     *publishListTableView;
@property (strong)NSMutableArray  *publishListArray;

@property (nonatomic,strong)NSString *is_select;

@end
