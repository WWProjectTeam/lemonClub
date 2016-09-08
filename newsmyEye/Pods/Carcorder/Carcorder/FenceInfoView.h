//
//  FenceInfoView.h
//  Carcorder
//
//  Created by EthanZhang on 16/1/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FenceInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextField *radio;
@property (weak, nonatomic) IBOutlet UISlider *radioSlider;
+(FenceInfoView *)getInstance;
@end

