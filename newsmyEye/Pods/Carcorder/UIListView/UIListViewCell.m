//
//  UIListViewCell.m
//  UIListView
//
//  Created by SeeKool on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIListViewCell.h"

@implementation UIListViewCell

@synthesize textLabel = _textLabel;

#pragma mark -
#pragma mark - init
- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0];
        /*
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 0.0f, kScreen_width/7-1.0f, kButtonViewFrame)];
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.textColor = [UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1.0f, 0.0f, kScreen_width/7-1.0f, kButtonViewFrame)];
        _bgImgView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_bgImgView];
        */
        
        _textButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.frame=CGRectMake(0.0f, 0.0f, (kScreen_width+60)/7-1.0f, kButtonViewFrame);
        _textButton.backgroundColor=[UIColor whiteColor];
        [_textButton setTitleColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self addSubview:_textButton];
    }
    
    return self;
}

@end
