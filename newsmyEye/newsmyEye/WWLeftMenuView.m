//
//  WWLeftMenuView.m
//  newsmyEye
//
//  Created by ww on 16/8/7.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWLeftMenuView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WWLeftMenuView{
@private
    UIImageView * imageViewHead;
    UILabel * labelUserNickName;
    UIButton * btnMySend;
    UIButton * btnMyCollect;
    UIButton * btnMyMessage;
    UIButton * btnMyTag;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * backGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [backGround setImage:[UIImage imageNamed:@"personbackground-2"]];
        [backGround setContentMode:UIViewContentModeScaleAspectFill];
        //  [backGround setAlpha:.6f];
        [self addSubview:backGround];
        
        
        //        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        //        effectview.frame = backGround.bounds;
        //        effectview.alpha = 1.0f;
        //        [backGround addSubview:effectview];
        
        
        
        
        imageViewHead = [[UIImageView alloc]init];
        [imageViewHead setImage:[UIImage imageNamed:@"photo--default"]];
        imageViewHead.layer.cornerRadius = 35.5f;
        [self addSubview:imageViewHead];
        
        [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@104);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@71);
            make.height.equalTo(@71);
        }];
        
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [imageButton addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag = 1005;
        [self addSubview:imageButton];
        [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.height.equalTo(imageViewHead);
        }];
        
        
        //昵称
        labelUserNickName = [[UILabel alloc]init];
        [labelUserNickName setFont:font_nonr_size(14)];
        [labelUserNickName setText:@"黄海军"];
        [labelUserNickName setTextAlignment:NSTextAlignmentCenter];
        [labelUserNickName setTextColor:RGBCOLOR(50, 50, 50)];
        
        [self addSubview:labelUserNickName];
        
        [labelUserNickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(imageViewHead.mas_bottom).offset(15);
            make.height.equalTo(@15);
        }];
        
        //返回按钮
        UIButton * btnGoBack = [[UIButton alloc]init];
        [btnGoBack setImage:[UIImage imageNamed:@"back-gray1"] forState:UIControlStateNormal];
        [btnGoBack addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnGoBack];
        
        [btnGoBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.top.equalTo(@29);
            make.width.equalTo(@15);
            make.height.equalTo(@26);
        }];
        
        
        //设置按钮
        UIButton * btnSetting = [[UIButton alloc]init];
        [btnSetting setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [btnSetting addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        btnSetting.tag = 1000;
        [self addSubview:btnSetting];
        
        [btnSetting mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-17));
            make.top.equalTo(@30);
            make.width.equalTo(@23);
            make.height.equalTo(@24);
        }];
        
        //我的发布
        
        btnMySend = [[UIButton alloc]initWithFrame:CGRectMake((MainView_Width-200)/2,255, 124, 21)];
        [btnMySend setBackgroundImage:[UIImage imageNamed:@"publis1"] forState:UIControlStateNormal];
        btnMySend.tag = 1001;
        [btnMySend addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnMySend];
        
        
        
        //我的收藏
        
        btnMyCollect = [[UIButton alloc]initWithFrame:CGRectMake((MainView_Width-200)/2, CGRectGetMaxY(btnMySend.frame)+30, 124, 21)];
        [btnMyCollect setBackgroundImage:[UIImage imageNamed:@"store1"] forState:UIControlStateNormal];
        btnMyCollect.tag = 1002;
        [btnMyCollect addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnMyCollect];
        
        
        
        //消息
        
        btnMyMessage = [[UIButton alloc]initWithFrame:CGRectMake((MainView_Width-200)/2, CGRectGetMaxY(btnMyCollect.frame)+30, 144, 21)];
        [btnMyMessage setBackgroundImage:[UIImage imageNamed:@"message1"] forState:UIControlStateNormal];
        btnMyMessage.tag = 1003;
        [btnMyMessage addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnMyMessage];
        
        
        
        
        //标签
        
        btnMyTag = [[UIButton alloc]initWithFrame:CGRectMake((MainView_Width-200)/2, CGRectGetMaxY(btnMyMessage.frame)+30, 124, 21)];
        [btnMyTag setBackgroundImage:[UIImage imageNamed:@"pin1"] forState:UIControlStateNormal];
        btnMyTag.tag = 1004;
        [btnMyTag addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnMyTag];
        
        
    }
    return self;
}

-(void)setImageHead:(UIImage *)imageHead{
    [imageViewHead setImage:imageHead];
    //[imageViewHead sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:imageHead];
}

-(void)setImageHeadUrl:(NSString *)imageHeadUrl{
    [imageViewHead sd_setImageWithURL:[NSURL URLWithString:imageHeadUrl] placeholderImage:[UIImage imageNamed:@"photo--default"]];
}

-(void)setStrNickName:(NSString *)strNickName{
    [labelUserNickName setText:strNickName];
}

-(void)showView{
    UIWindow * currentWindows = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.6f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setFrame:CGRectMake(0, 0, currentWindows.frame.size.width, currentWindows.frame.size.height)];
        
        //动画1
        [UIView animateWithDuration:.6f delay:.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMySend setFrame:CGRectMake((MainView_Width-124)/2, 255, 124, 21)];
        } completion:nil];
        
        //动画2
        [UIView animateWithDuration:.6f delay:.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMyCollect setFrame:CGRectMake((MainView_Width-124)/2, CGRectGetMaxY(btnMySend.frame)+30, 124, 21)];
        } completion:nil];
        
        //动画3
        [UIView animateWithDuration:.6f delay:.4f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMyMessage setFrame:CGRectMake((MainView_Width-124)/2, CGRectGetMaxY(btnMyCollect.frame)+30, 144, 21)];
        } completion:nil];
        
        //动画4
        [UIView animateWithDuration:.6f delay:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMyTag setFrame:CGRectMake((MainView_Width-124)/2, CGRectGetMaxY(btnMyMessage.frame)+30,124 , 21)];
        } completion:nil];
    } completion:^(BOOL isFinish){
        
        
    }];
    
    
}
-(void)disMissView{
    UIWindow * currentWindows = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:.6f delay:.4f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setFrame:CGRectMake(-currentWindows.frame.size.width, 0, currentWindows.frame.size.width, currentWindows.frame.size.height)];
        
        //动画1
        [UIView animateWithDuration:.6f delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMySend setFrame:CGRectMake((MainView_Width-200)/2, 255, 124, 21)];
        } completion:nil];
        
        //动画2
        [UIView animateWithDuration:.6f delay:.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMyCollect setFrame:CGRectMake((MainView_Width-200)/2, CGRectGetMaxY(btnMySend.frame)+30, 124, 21)];
        } completion:nil];
        
        //动画3
        [UIView animateWithDuration:.6f delay:.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMyMessage setFrame:CGRectMake((MainView_Width-200)/2, CGRectGetMaxY(btnMyCollect.frame)+30, 144, 21)];
        } completion:nil];
        
        //动画4
        [UIView animateWithDuration:.6f delay:.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [btnMyTag setFrame:CGRectMake((MainView_Width-200)/2, CGRectGetMaxY(btnMyMessage.frame)+30,124 , 21)];
        } completion:nil];
    } completion:^(BOOL isFinish){
        
        
    }];
    
}

- (void)btnClickEvent:(UIButton *)sender{
    self.btnClickBolck(sender);
}

@end
