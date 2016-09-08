//
//  DevBtnCollectionViewCell.m
//  Carcorder
//
//  Created by YF on 16/3/4.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "DevBtnCollectionViewCell.h"

@implementation DevBtnCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.imgView=[[UIImageView alloc] init];
        
        self.imgView.frame=CGRectMake(27, 10, self.bounds.size.width-54, self.bounds.size.height-60);
        
        [self addSubview:self.imgView];
        
        
        self.imgLab=[[UILabel alloc] init];
        
        self.imgLab.frame=CGRectMake(0, self.imgView.frame.size.height+10+10, self.bounds.size.width, 30);
        
        self.imgLab.textAlignment=NSTextAlignmentCenter;
        
        [self addSubview:self.imgLab];
    }
    
    return self;
    
}

@end
