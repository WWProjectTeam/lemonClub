//
//  TimeVideoViewController.h
//  Carcorder
//
//  Created by L on 15/9/7.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P2PListener.h"
#import "BLMultiColorLoader.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface TimeVideoViewController : UIViewController<P2PListener>
{
    UIButton *btn5;
    UIImageView *bgImg;
    UIImageView *bgImg1;
    UIImageView *gu;
    UIView *Viedo;
//    UIView *view22;
//    UIImageView *photograph11;
//    UIImageView *photograph22;
//    UIImageView *photograph33;
//    UIImageView *photograph;
//    UIImageView *photograph2;
//    UIImageView *photograph3;
    NSTimer * myTimer;
    NSTimer * myTimer1;
    NSTimer * myTimer2;
     NSTimer * myTimer3;
    NSString *backStr;
//    UIButton *btn33;
//    UIButton *btn11;
//    UIButton *btn22;
////    UIButton *btn2;
//    
//    UIButton *btn3;
////    UIButton *btn11;
//     UIButton *btn1;
//    UIButton *btn2;
    UITapGestureRecognizer *tap;
}

@property (strong, nonatomic) UIView* waitDialog;
-(void)showWaitDialog;
//结束风火轮的方法
-(void)dismissDialog;
@property (weak, nonatomic) IBOutlet BLMultiColorLoader *multiColorLoader;
@end
