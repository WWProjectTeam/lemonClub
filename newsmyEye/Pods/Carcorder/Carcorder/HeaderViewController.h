//
//  HeaderViewController.h
//  Carcorder
//
//  Created by YF on 16/1/15.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *_collection;
}
@end
