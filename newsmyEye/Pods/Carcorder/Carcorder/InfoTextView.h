//
//  InfoTextView.h
//  Carcorder
//
//  Created by YF on 16/3/14.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTextView : UIView

@property(nonatomic,retain)IBOutlet UITextField *sendMessageTF;

@property(nonatomic,retain)IBOutlet UIButton *sendMessageBtn;

@property(nonatomic,strong)IBOutlet UIButton *locationBtn;

+(InfoTextView *)getInstance;

@end
