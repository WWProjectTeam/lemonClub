//
//  WWHomePageTableViewCell.h
//  newsmyEye
//
//  Created by ww on 16/8/17.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWHomePageTableViewCell : UITableViewCell
@property (strong) UIImageView * imgHead;
@property (strong) UILabel * labelUserNickName;
@property (strong) UILabel * labelTitle;
@property (strong) UILabel * labelDesc;
@property (strong) UIImageView * imgContent;
@property (strong) UILabel * labelShareNum;
@property (strong) UILabel * labelCommentNum;
@property (strong) UILabel * labelCollectNum;
@property (strong) UILabel * labelLike;
@property (strong) UIButton * btnTag;
@property (strong) UILabel * labelTime;

-(CGFloat)rowHeight;

@end
