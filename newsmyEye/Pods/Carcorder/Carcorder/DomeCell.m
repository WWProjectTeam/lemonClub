//
//  DomeCell.m
//  Carcorder
//
//  Created by YF on 16/3/17.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "DomeCell.h"
#define CarImg_width 220
#define CarImg_height 255

@implementation DomeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    //创建一个UIView比self.contentView小一圈
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreen_width - 24, kScreen_width * 9/16)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    //给bgView边框设置阴影
    self.bgView.layer.shadowOffset = CGSizeMake(2,2);
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.contentView addSubview:self.bgView];
    
    self.devImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    self.devImg.image=[UIImage imageNamed:@"设备-n"];
    [self.bgView addSubview:self.devImg];
    
    self.devNameLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.devImg.bounds)+10, 5, self.bgView.frame.size.width-85, self.devImg.frame.size.height)];
    self.devNameLab.textColor=[UIColor darkGrayColor];
    self.devNameLab.font=[UIFont systemFontOfSize:17.0];
    [self.bgView addSubview:self.devNameLab];
    
    self.pointImg=[[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width-30,5+CGRectGetHeight(self.devImg.bounds)/2-2.5, 20, 5)];
    self.pointImg.image=[UIImage imageNamed:@"点点点"];
    [self.bgView addSubview:self.pointImg];
    
    self.picImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10+CGRectGetHeight(self.devImg.bounds), self.bgView.frame.size.width-10, (self.bgView.frame.size.width-10)*9/16-(CGRectGetMaxY(self.devImg.bounds)+5))];
    [self.picImg setBackgroundColor:[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:0.9]];
    [self.bgView addSubview:self.picImg];
    
    self.carImg=[[UIImageView alloc] initWithFrame:CGRectMake((self.picImg.frame.size.width-self.picImg.frame.size.height/1.5)/2, (self.picImg.frame.size.height-self.picImg.frame.size.height/1.5)/2, self.picImg.frame.size.height/1.5, self.picImg.frame.size.height/1.5)];
    self.carImg.image=[UIImage imageNamed:@"car.jpg"];
    [self.picImg addSubview:self.carImg];
}

+(CGFloat)getHeight
{
    //在这里能计算高度，动态调整
    return kScreen_width *9/16;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
