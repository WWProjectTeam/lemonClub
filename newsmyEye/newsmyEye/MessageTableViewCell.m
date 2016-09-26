//
//  MessageTableViewCell.m
//  newsmyEye
//
//  Created by push on 16/9/18.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageImg = [[UIImageView alloc]init];
        self.messageImg.layer.cornerRadius = 20;
        self.messageImg.layer.masksToBounds = YES;
        [self addSubview:self.messageImg];
        
        self.messageName = [[UILabel alloc]init];
        self.messageName.textColor = RGBCOLOR(50, 50, 50);
        self.messageName.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.messageName];
        
        self.messageTime = [[UILabel alloc]init];
        self.messageTime.textColor = RGBCOLOR(153, 153, 153);
        self.messageTime.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.messageTime];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete1"] forState:UIControlStateNormal];
        [self addSubview:self.deleteButton];
        
        self.messageContent = [[UILabel alloc]init];
        self.messageContent.textColor = RGBCOLOR(50, 50, 50);
        self.messageContent.font = [UIFont systemFontOfSize:13];
        [self.messageContent setNumberOfLines:0];
        [self addSubview:self.messageContent];
        
        self.commentImg = [[UIImageView alloc]init];
        self.commentImg.layer.cornerRadius = 3;
        self.commentImg.layer.masksToBounds = YES;
        [self addSubview:self.commentImg];
        
        self.commentTitle = [[UILabel alloc] init];
        self.commentTitle.textColor= RGBCOLOR(50, 50, 50);
        self.commentTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview: self.commentTitle];
        
        self.commentName = [[UILabel alloc]init];
        self.commentName.textColor = RGBCOLOR(237, 200, 30);
        self.commentName.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.commentName];
        
        self.commentContent = [[UILabel alloc]init];
        self.commentContent.textColor = RGBCOLOR(153, 153, 153);
        self.commentContent.font = [UIFont systemFontOfSize:13];
        self.commentContent.textAlignment = NSTextAlignmentLeft;
        [self.commentContent setNumberOfLines:0];
        [self addSubview:self.commentContent];
    }
    return self;
}

- (void)messageCellData:(MessageModel *)model{
    
    self.messageImg.image = [UIImage imageNamed:@""];
    self.messageName.text= model.messageNameStr;
    self.messageTime.text= model.messageTimeStr;
    self.messageContent.text = model.messageContentStr;
    self.commentImg.image = [UIImage imageNamed:@""];
    self.commentTitle.text = model.commentTitleStr;
    self.commentName.text = model.commentNameStr;
    self.commentContent.text= model.commentContentStr;
    //模拟没有数据
    NSString *noData = @"1";
    NSString *noCommentData = @"1";
    if (noCommentData == nil) {
        self.commentImg.hidden = YES;
        self.commentTitle.hidden = YES;
        self.commentContent.hidden= YES;
        self.commentName.hidden = YES;
    }else{
        if (noData == nil) {
            self.commentContent.hidden= YES;
            self.commentName.hidden = YES;
        }
    }
    
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [self.messageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
    }];
    [self.messageName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageImg.mas_right).offset(10);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.messageImg.mas_top).offset(8);
    }];
    [self.messageTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageName);
        make.top.equalTo(self.messageName.mas_bottom).offset(8);
    }];
    [self.messageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.messageImg.mas_bottom).offset(15);
    }];
    [self.commentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.equalTo(self.messageContent.mas_bottom).offset(15);
        make.width.height.mas_equalTo(64);
    }];
    [self.commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentImg.mas_right).offset(15);
        make.centerY.equalTo(self.commentImg.mas_centerY);
    }];
    [self.commentName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.equalTo(self.commentImg.mas_bottom).offset(15);
    }];
    [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentName.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.commentName);
    }];
}

//在表格cell中 计算出高度
-(CGFloat)rowHeight
{
    [self layoutIfNeeded];
    //3.  视图的最大 Y 值
    CGFloat h;
    //模拟没有数据
    NSString *noData = @"1";
    NSString *noCommentData = @"1";
    if (noCommentData == nil) {
        h = CGRectGetMaxY(self.messageContent.frame);
    }else{
        if (noData == nil) {
            h = CGRectGetMaxY(self.commentImg.frame);
        }else{
            h = CGRectGetMaxY(self.commentContent.frame);
        }
    }
    
    return h+15;//最大的高度+15
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
