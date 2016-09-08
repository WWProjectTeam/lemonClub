//
//  TrackViewController.h
//  Carcorder
//
//  Created by YF on 16/1/13.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZQDatePickerView.h"
#import "MBProgressHUD.h"

@interface TrackViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,HZQDatePickerViewDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *_table;
    
}

@property(nonatomic,retain)IBOutlet UIView *buttonView;

@property(nonatomic,retain)IBOutlet UIButton *startTimeBtn;

@property(nonatomic,retain)IBOutlet UIButton *endTimeBtn;

@property(nonatomic,retain)IBOutlet UILabel *startLabel,*endLabel;

@property(nonatomic,retain)UIDatePicker *datePicker;

@end
