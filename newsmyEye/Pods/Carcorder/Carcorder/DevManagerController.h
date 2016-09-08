//
//  DevManagerController.h
//  Carcorder
//
//  Created by YF on 16/3/4.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevManagerController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    UICollectionView *_collectionView;
    
}

@property(nonatomic,retain)UIImageView *vidImgView;

@property(nonatomic,retain)UIButton *vidBtn;

@end
