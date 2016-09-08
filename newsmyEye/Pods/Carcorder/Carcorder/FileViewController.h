//
//  FileViewController.h
//  Carcorder
//
//  Created by L on 15/10/10.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController<UIScrollViewDelegate>
{
     NSString *messageStr;
    UIButton *RButton;
    UIView *bgview;
    UIImageView *imgView;
    UILabel *nameStr;
    int b;
    NSArray* reversedArray;
    NSMutableArray *arrStr;
    NSString *imgStr;
    UIView *winview22;
    UIView *winview;
}
@property(nonatomic ,assign)NSInteger index;
@property(nonatomic ,retain)NSMutableArray *data;

- (id)initWithSourceData:(NSMutableArray *)data withIndex:(NSInteger)index;
@property (nonatomic,retain) UIScrollView *myscrollview; 
@end
