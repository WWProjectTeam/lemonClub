//
//  MessageTableViewCell.h
//  newsmyEye
//
//  Created by push on 16/9/18.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageTableViewCell : UITableViewCell

@property (strong) UIImageView      *messageImg;
@property (strong) UILabel          *messageName;
@property (strong) UILabel          *messageTime;
@property (strong) UIButton         *deleteButton;
@property (strong) UILabel          *messageContent;
@property (strong) UIImageView      *commentImg;
@property (strong) UILabel          *commentTitle;
@property (strong) UILabel          *commentName;
@property (strong) UILabel          *commentContent;

- (void)messageCellData:(MessageModel *)model;

-(CGFloat)rowHeight;

@end
