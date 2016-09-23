//
//  WWUserCenterViewController.h
//  newsmyEye
//
//  Created by songs on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWUserCenterViewController : UIViewController
{
    UIImageView *imageViewHead;
    UILabel *labelUserNickName;
    UIImageView *sexImage;
    UIButton *ageButton;
    
    //  选择
    UIView *chooseView;
    UIButton *publishBtn;
    UIButton *collectionBtn;
    UILabel  *chooseLine;
}

@property (strong) UIScrollView *BackScrollview;
@property (strong) UITableView  *publishTableView;
@property (strong) NSMutableArray   *publishArray;
@property (strong) UITableView  *collectionTableView;
@property (strong) NSMutableArray   *collectionArray;


@end
