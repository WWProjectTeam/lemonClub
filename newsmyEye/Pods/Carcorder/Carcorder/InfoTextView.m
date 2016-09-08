//
//  InfoTextView.m
//  Carcorder
//
//  Created by YF on 16/3/14.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "InfoTextView.h"

@implementation InfoTextView

+(InfoTextView *)getInstance
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"textView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
