//
//  WWPublishTableViewCell.h
//  newsmyEye
//
//  Created by push on 16/9/11.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWHomePageModel.h"

@interface WWPublishTableViewCell : UITableViewCell{
    UIImageView * imgLike;
    UIImageView * imgCollect;
    UIImageView * imgCommit;
    UIImageView * imgShare;
}

@property (strong) void (^deleteCell)();

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
@property (strong) UIButton * deleteButton;

@property (strong) UILabel *line;

- (void)publishData:(WWHomePageModel *)model is_Type:(BOOL)type;

-(CGFloat)rowHeight;

@end
