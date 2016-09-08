//
//  WWFlowSelectButton.m
//  Carcorder
//
//  Created by newsmy on 16/6/2.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWFlowSelectButton.h"

@implementation WWFlowSelectButton{
    UIColor * colorHighlighted;
}

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@synthesize labelFlow = _labelFlow;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:3];
        
        _strTitle = @"";
        
        UILabel * labelTimeGroup = ({
            labelTime = [[UILabel alloc]initWithFrame:CGRectMake(iphone_size_scale(22), 10, frame.size.width, iphone_size_scale(20))];
            [labelTime setFont:[UIFont systemFontOfSize:12]];
            [labelTime setTextAlignment:NSTextAlignmentLeft];

            labelTime;
        });
        [self addSubview:labelTimeGroup];
        
        
        UILabel * labelFlowGroup = ({
            self.labelFlow = [[UILabel alloc]initWithFrame:CGRectMake(iphone_size_scale(22), iphone_size_scale(20), frame.size.width, iphone_size_scale(30))];
            [self.labelFlow setFont:[UIFont boldSystemFontOfSize:20]];
            [self.labelFlow setTextAlignment:NSTextAlignmentLeft];
            
            self.labelFlow;
        });
        [self addSubview:labelFlowGroup];
        
        
        UILabel * labelPriceGroup = ({
            labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(iphone_size_scale(22),iphone_size_scale(40), frame.size.width, iphone_size_scale(20))];
            [labelPrice setFont:[UIFont systemFontOfSize:12]];
            [labelPrice setTextAlignment:NSTextAlignmentLeft];

            labelPrice;
        });
        [self addSubview:labelPriceGroup];
        
    }
    return self;
    
    
}

//绑定事件
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    _delegate = target;
    controlEvent = controlEvents;
    methodAction = action;
}


//处理触摸开始事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (controlEvent == UIControlEventTouchDown) {
        
        SuppressPerformSelectorLeakWarning([_delegate performSelector:methodAction withObject:self];);
    }
    
    if (colorHighlighted) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = colorHighlighted.CGColor;
    }
    [self setBackgroundColor:higColor];
}


//处理触摸结束事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (controlEvent == UIControlEventTouchUpInside) {
        
        SuppressPerformSelectorLeakWarning([_delegate performSelector:methodAction withObject:self];);
    }
    
    if (colorHighlighted) {
        self.layer.borderWidth = 0;
       // self.layer.borderColor = colorHighlighted.CGColor;
    }
    
    [self setBackgroundColor:norColor];
}

//设置背景颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forControlState:(UIControlState)State{
    switch (State) {
        case UIControlStateNormal:norColor = backgroundColor;
            break;
            
        case UIControlStateHighlighted:higColor = backgroundColor;
            break;
        default:
            break;
    }

}

-(void)setTimeTitle:(NSString *)string forControlEvents:(UIControlState)State{
    [labelTime setText:string];
    switch (State) {
        case UIControlStateNormal:[labelTime setTextColor:[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1.0]];
            break;
        case UIControlStateHighlighted:[labelTime setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            break;
        case UIControlStateSelected:[labelTime setTextColor:[UIColor whiteColor]];[self setBackgroundColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            break;
        default:
            break;
    }

}
-(void)setFlowTitle:(NSString *)string forControlEvents:(UIControlState)State{
    [self.labelFlow setText:string];
    switch (State) {
        case UIControlStateNormal:[self.labelFlow setTextColor:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0]];
            break;
        case UIControlStateHighlighted:[self.labelFlow setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            break;
        case UIControlStateSelected:[self.labelFlow setTextColor:[UIColor whiteColor]];[self setBackgroundColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            break;
        default:
            break;
    }
}

-(void)setPriceTitle:(NSString *)string forControlEvents:(UIControlState)State{
    [labelPrice setText:string];
    switch (State) {
        case UIControlStateNormal:[labelPrice setTextColor:[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1.0]];
            break;
        case UIControlStateHighlighted:[labelPrice setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            break;
        case UIControlStateSelected:[labelPrice setTextColor:[UIColor whiteColor]];[self setBackgroundColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            break;
        default:
            break;
    }
}

-(void)setEnable:(BOOL)control{
    [self setUserInteractionEnabled:control];

    [self.labelFlow setTextColor: control?[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0]:[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1.0]];
}


-(void)setViewBoardColor:(UIColor *)color forControlEvents:(UIControlState)State{
    switch (State) {
        case UIControlStateHighlighted:
            colorHighlighted = color;
            break;
            
        default:
            break;
    }
}


@end
