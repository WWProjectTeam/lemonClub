//
//  WWPublishViewController.h
//  newsmyEye
//
//  Created by push on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPublishViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,strong)        UITextView          *titleTextView;
@property (nonatomic,strong)        UILabel             *titlePlaceholder;
@property (nonatomic,strong)        UILabel             *titleNum;

@property (nonatomic,strong)        UITextView          *contentTextView;
@property (nonatomic,strong)        UILabel             *contentPlaceholder;

@end
