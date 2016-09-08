//
//  FenceInfoView.m
//  Carcorder
//
//  Created by EthanZhang on 16/1/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "FenceInfoView.h"

@implementation FenceInfoView

+(FenceInfoView *)getInstance
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"Address" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)valueChanged:(id)sender
{
    UITextField *txt=(UITextField*)sender;
    float radio=[txt.text floatValue];
    [self.radioSlider setValue:radio animated:YES];
}

@end
