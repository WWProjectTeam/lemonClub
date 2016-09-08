//
//  MyPhotoTableViewCell.h
//  Carcorder
//
//  Created by YF on 16/1/18.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhotoTableViewCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel *dateLab;

@property(nonatomic,retain)IBOutlet UILabel *timeLab;

@property(nonatomic,retain)IBOutlet UIImageView *circleImg;

@property(nonatomic,retain)IBOutlet UIImageView *photoImg;

@property(nonatomic,retain)IBOutlet UIImageView *playImg;

@property(nonatomic,retain)IBOutlet UIButton *photoBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@end
