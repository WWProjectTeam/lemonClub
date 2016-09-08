//
//  Media.h
//  Carcorder
//
//  Created by YF on 16/3/2.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface Media : NSObject
@property(strong,nonatomic)UIImage *media;
@property(strong,nonatomic)NSString *dateAndTime;
@property(strong,nonatomic)NSString *mediaType;
@property(strong,nonatomic)NSURL *mediaURL;
@property(strong) ALAsset * alasset;
@end
