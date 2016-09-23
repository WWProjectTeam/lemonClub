//
//  MessageModel.h
//  newsmyEye
//
//  Created by push on 16/9/19.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (strong) NSString          *messageImgStr;
@property (strong) NSString          *messageNameStr;
@property (strong) NSString          *messageTimeStr;
@property (strong) NSString          *deleteButtonStr;
@property (strong) NSString          *messageContentStr;
@property (strong) NSString          *commentImgStr;
@property (strong) NSString          *commentTitleStr;
@property (strong) NSString          *commentNameStr;
@property (strong) NSString          *commentContentStr;
@property (assign,nonatomic) float height;

@end
