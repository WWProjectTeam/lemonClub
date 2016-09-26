//
//  WWBlankPageView.m
//  newsmyEye
//
//  Created by push on 16/9/11.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWBlankPageView.h"

@implementation WWBlankPageView

- (id)initWithFrame:(CGRect)frame blankImg:(UIImage *)image blankTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *blankImg = [[UIImageView alloc]init];
        blankImg.image = image;
        [self addSubview:blankImg];
        [blankImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).multipliedBy(0.55);
            make.top.mas_equalTo(200);
        }];
        
        UILabel *blankText = [[UILabel alloc]init];
        blankText.text = title;
        blankText.textColor = RGBCOLOR(153, 153, 153);
        blankText.font = [UIFont systemFontOfSize:13];
        [self addSubview:blankText];
        [blankText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).multipliedBy(0.8);
            make.centerY.equalTo(blankImg.mas_centerY);
        }];
        
    }
    return self;
}

@end
