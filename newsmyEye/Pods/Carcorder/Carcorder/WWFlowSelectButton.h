//
//  WWFlowSelectButton.h
//  Carcorder
//
//  Created by newsmy on 16/6/2.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWFlowSelectButton : UIView{
    id              _delegate;
    UIControlEvents controlEvent;
    SEL             methodAction;
    
    
    UIColor * norColor;
    UIColor * higColor;
    
    UILabel * labelTime;
//    UILabel * labelFlow;
    UILabel * labelPrice;
}


@property (strong)UILabel * labelFlow;


/**
 *  绑定事件
 *
 *  @param target        目标
 *  @param action        事件
 *  @param controlEvents 控制监听
 */
 - (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;


/**
 *  设置背景颜色
 *
 *  @param backgroundColor 颜色
 *  @param controlEvents   状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forControlEvents:(UIControlEvents)controlEvents;


//设置各种文字
-(void)setTimeTitle:(NSString *)string forControlEvents:(UIControlState)State;
-(void)setFlowTitle:(NSString *)string forControlEvents:(UIControlState)State;
-(void)setPriceTitle:(NSString *)string forControlEvents:(UIControlState)State;
-(void)setViewBoardColor:(UIColor *)color forControlEvents:(UIControlState)State;

-(void)setEnable:(BOOL)control;

@property (strong) NSString * strTitle;
@property (assign,nonatomic) NSInteger groupID;

@end
