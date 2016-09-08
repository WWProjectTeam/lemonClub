//
//  DomeCell.h
//  Carcorder
//
//  Created by YF on 16/3/17.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DomeCell : UITableViewCell

@property (nonatomic,strong)UIView *bgView;

@property(nonatomic,retain)UILabel *devNameLab;

@property(nonatomic,retain)UIImageView *devImg,*pointImg,*picImg,*carImg;

+(CGFloat)getHeight;

@end
