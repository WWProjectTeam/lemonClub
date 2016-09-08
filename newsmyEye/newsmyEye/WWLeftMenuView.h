//
//  WWLeftMenuView.h
//  newsmyEye
//
//  Created by ww on 16/8/7.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWLeftMenuView : UIView

//头像
@property (strong,nonatomic) UIImage * imageHead;
@property (strong,nonatomic) NSString * imageHeadUrl;
//昵称
@property (strong,nonatomic) NSString * strNickName;



-(instancetype)initWithFrame:(CGRect)frame;


-(void)setMessageBadge;


-(void)showView;
-(void)disMissView;
@end
