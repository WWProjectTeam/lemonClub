//
//  WWHomePageTableViewCell.m
//  newsmyEye
//
//  Created by ww on 16/8/17.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWHomePageTableViewCell.h"

@implementation WWHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgHead = [[UIImageView alloc]init];
        [self.imgHead setContentMode:UIViewContentModeScaleAspectFill];
        self.imgHead.layer.cornerRadius = 20.f;
        self.imgHead.layer.masksToBounds = YES;
        
        [self addSubview:self.imgHead];
        
        [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.width.height.equalTo(@40);
        }];
        
        self.labelUserNickName = [[UILabel alloc]init];
        [self.labelUserNickName setFont:font_nonr_size(14)];
        [self.labelUserNickName setTextColor:WWGreyText];
        [self.labelUserNickName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.labelUserNickName];
        
        [self.labelUserNickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgHead.mas_right).offset(10);
            make.top.bottom.equalTo(self.imgHead);
            make.width.equalTo(@150);
        }];
        
        self.btnTag = [[UIButton alloc]init];
        [self.btnTag setTitleColor:WWOrganText forState:UIControlStateNormal];
        self.btnTag.layer.cornerRadius = 3.f;
        self.btnTag.layer.borderColor = WWOrganText.CGColor;
        self.btnTag.layer.borderWidth = 1.f;
        [self.btnTag.titleLabel setFont:font_nonr_size(16)];

        [self addSubview:_btnTag];
        
        [self.btnTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.imgHead.mas_top).offset(5);
            make.bottom.equalTo(self.imgHead.mas_bottom).offset(-5);
            make.width.lessThanOrEqualTo(@(MainView_Width-160));
            
        }];
        
        self.labelTitle = [[UILabel alloc]init];
        [self.labelTitle setFont:font_nonr_size(18)];
        [self.labelTitle setTextColor:WWTitleTextColor];
        [self.labelTitle setTextAlignment:NSTextAlignmentLeft];
        [self.labelTitle setNumberOfLines:0];
        [self addSubview:self.labelTitle];
        
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.imgHead.mas_bottom).offset(15);
            make.height.greaterThanOrEqualTo(@0);

        }];
        
        self.labelDesc = [[UILabel alloc]init];
        [self.labelDesc setFont:font_nonr_size(15)];
        [self.labelDesc setTextColor:WWGreyText];
        [self.labelDesc setTextAlignment:NSTextAlignmentLeft];
        [self.labelDesc setNumberOfLines:0];
        [self addSubview:self.labelDesc];
        
        [self.labelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.greaterThanOrEqualTo(@20);
            make.top.equalTo(self.labelTitle.mas_bottomMargin).offset(15);
        }];
        
        self.imgContent = [[UIImageView alloc]init];
        [self.imgContent setContentMode:UIViewContentModeScaleAspectFill];
        self.imgContent.clipsToBounds = YES;
        
        [self addSubview:self.imgContent];
        [self.imgContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.lessThanOrEqualTo(@300);
            make.top.equalTo(self.labelDesc.mas_bottomMargin).offset(20);
        }];
        
#pragma mark - 底部杂项
        self.labelTime = [[UILabel alloc]init];
        [self.labelTime setFont:font_nonr_size(14)];
        [self.labelTime setTextAlignment:NSTextAlignmentLeft];
        [self.labelTime setTextColor:WWLowGreyText];
        [self addSubview:self.labelTime];
        
        [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.imgContent.mas_bottomMargin).offset(15);
            make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        
        //点赞
        UIImageView * imgLike = [[UIImageView alloc]init];
        [imgLike setImage:[UIImage imageNamed:@"zan"]];
        [self addSubview:imgLike];
        [imgLike mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.height.equalTo(@13);
            make.centerY.equalTo(self.labelTime.mas_centerY);
        }];
        
        self.labelLike = [[UILabel alloc]init];
        [self.labelLike setTextAlignment:NSTextAlignmentRight];
        [self.labelLike setFont:font_nonr_size(14)];
        [self.labelLike setTextColor:WWLowGreyText];
        [self addSubview:self.labelLike];
        
        [self.labelLike mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgLike.mas_left).offset(-5);
            make.centerY.equalTo(self.labelTime.mas_centerY);
            make.width.greaterThanOrEqualTo(@40);
            make.height.equalTo(@20);
        }];
        
        
        //收藏
        UIImageView * imgCollect = [[UIImageView alloc]init];
        [imgCollect setImage:[UIImage imageNamed:@"like"]];
        [self addSubview:imgCollect];
        [imgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgLike.mas_right).offset(-60);
            make.width.height.equalTo(@13);
            make.centerY.equalTo(self.labelTime.mas_centerY);
        }];
        
        self.labelCollectNum = [[UILabel alloc]init];
        [self.labelCollectNum setTextAlignment:NSTextAlignmentRight];
        [self.labelCollectNum setFont:font_nonr_size(14)];
        [self.labelCollectNum setTextColor:WWLowGreyText];
        [self addSubview:self.labelCollectNum];
        
        [self.labelCollectNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgCollect.mas_left).offset(-5);
            make.centerY.equalTo(self.labelTime.mas_centerY);
            make.width.greaterThanOrEqualTo(@40);
            make.height.equalTo(@20);
        }];
        
        //评论
        UIImageView * imgCommit = [[UIImageView alloc]init];
        [imgCommit setImage:[UIImage imageNamed:@"leave-word"]];
        [self addSubview:imgCommit];
        [imgCommit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgCollect.mas_right).offset(-60);
            make.width.height.equalTo(@13);
            make.centerY.equalTo(self.labelTime.mas_centerY);
        }];
        
        self.labelCommentNum = [[UILabel alloc]init];
        [self.labelCommentNum setTextAlignment:NSTextAlignmentRight];
        [self.labelCommentNum setFont:font_nonr_size(14)];
        [self.labelCommentNum setTextColor:WWLowGreyText];
        [self addSubview:self.labelCommentNum];
        
        [self.labelCommentNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgCommit.mas_left).offset(-5);
            make.centerY.equalTo(self.labelTime.mas_centerY);
            make.width.greaterThanOrEqualTo(@40);
            make.height.equalTo(@20);
        }];
        
        
        //分享
        UIImageView * imgShare = [[UIImageView alloc]init];
        [imgShare setImage:[UIImage imageNamed:@"share"]];
        [self addSubview:imgShare];
        [imgShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgCommit.mas_right).offset(-60);
            make.width.height.equalTo(@13);
            make.centerY.equalTo(self.labelTime.mas_centerY);
        }];
        
        self.labelShareNum = [[UILabel alloc]init];
        [self.labelShareNum setTextAlignment:NSTextAlignmentRight];
        [self.labelShareNum setFont:font_nonr_size(14)];
        [self.labelShareNum setTextColor:WWLowGreyText];
        [self addSubview:self.labelShareNum];
        
        [self.labelShareNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imgShare.mas_left).offset(-5);
            make.centerY.equalTo(self.labelTime.mas_centerY);
            make.width.greaterThanOrEqualTo(@40);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}


//在表格cell中 计算出高度

-(CGFloat)rowHeight

{
    
    
//    __weak __typeof(&*self)weakSelf =self;
//    
//    //设置标签的高度
//    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker*make) {
//        
//        // weakSelf.contentLabelH  这个会调用下面的懒加载方法
//        
//        make.height.mas_equalTo(weakSelf.labelTime.mas_bottom);
//        
//    }];
    
    [self layoutIfNeeded];
    
    //3.  视图的最大 Y 值
    
    CGFloat h= CGRectGetMaxY(self.labelTime.frame);
    
    return h+10;//最大的高度+10
}
    @end
