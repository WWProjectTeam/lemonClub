//
//  WWEditInformationViewController.h
//  newsmyEye
//
//  Created by songs on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLImageCrop.h"

@interface WWEditInformationViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLImageCropDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UIImageView *imageViewHead;
    UILabel *labelUserNickName;
    
    UIImagePickerController *_pickerImage;
    
    NSString *currentYearString;
    NSString *currentMonthString;
    NSString *currentDateString;
}

// 时间选择
@property (nonatomic,strong)        UIView                  *pickBackView;
@property (nonatomic,strong)        UIPickerView            *pickView;
@property (nonatomic,strong)        NSMutableArray          *yearArray;
@property (nonatomic,strong)        NSMutableArray          *monthArray;
@property (nonatomic,strong)        NSMutableArray          *daysArray;
@property (nonatomic,assign)        NSInteger               selectedMonthRow;
@property (nonatomic,assign)        NSInteger               selectedYearRow;
@property (nonatomic,assign)        NSInteger               selectedDayRow;

@end
