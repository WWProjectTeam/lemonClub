//
//  WWPublishTableViewCell.m
//  newsmyEye
//
//  Created by push on 16/9/11.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWPublishTableViewCell.h"

@implementation WWPublishTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgHead = [[UIImageView alloc]init];
        [self.imgHead setContentMode:UIViewContentModeScaleAspectFill];
        self.imgHead.layer.cornerRadius = 20.f;
        self.imgHead.layer.masksToBounds = YES;
        [self addSubview:self.imgHead];
        
        self.labelUserNickName = [[UILabel alloc]init];
        [self.labelUserNickName setFont:font_nonr_size(14)];
        [self.labelUserNickName setTextColor:WWGreyText];
        [self.labelUserNickName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.labelUserNickName];

        
        self.btnTag = [[UIButton alloc]init];
        [self.btnTag setTitleColor:WWOrganText forState:UIControlStateNormal];
        self.btnTag.layer.cornerRadius = 3.f;
        self.btnTag.layer.borderColor = WWOrganText.CGColor;
        self.btnTag.layer.borderWidth = 1.f;
        [self.btnTag.titleLabel setFont:font_nonr_size(16)];
        [self addSubview:_btnTag];
        
        self.labelTime = [[UILabel alloc]init];
        [self.labelTime setFont:font_nonr_size(14)];
        [self.labelTime setTextAlignment:NSTextAlignmentRight];
        [self.labelTime setTextColor:WWLowGreyText];
        [self addSubview:self.labelTime];
        
        self.labelTitle = [[UILabel alloc]init];
        [self.labelTitle setFont:font_nonr_size(18)];
        [self.labelTitle setTextColor:WWTitleTextColor];
        [self.labelTitle setTextAlignment:NSTextAlignmentLeft];
        [self.labelTitle setNumberOfLines:0];
        [self addSubview:self.labelTitle];
        
        self.labelDesc = [[UILabel alloc]init];
        [self.labelDesc setFont:font_nonr_size(15)];
        [self.labelDesc setTextColor:WWGreyText];
        [self.labelDesc setTextAlignment:NSTextAlignmentLeft];
        [self.labelDesc setNumberOfLines:0];
        [self addSubview:self.labelDesc];
        
        self.imgContent = [[UIImageView alloc]init];
        [self.imgContent setContentMode:UIViewContentModeScaleAspectFill];
        self.imgContent.clipsToBounds = YES;
        [self addSubview:self.imgContent];
        
#pragma mark - 底部杂项
        
        //点赞
        imgLike = [[UIImageView alloc]init];
        [imgLike setImage:[UIImage imageNamed:@"zan"]];
        [self addSubview:imgLike];
        
        self.labelLike = [[UILabel alloc]init];
        [self.labelLike setTextAlignment:NSTextAlignmentLeft];
        [self.labelLike setFont:font_nonr_size(14)];
        [self.labelLike setTextColor:WWLowGreyText];
        [self addSubview:self.labelLike];
        
        //收藏
        imgCollect = [[UIImageView alloc]init];
        [imgCollect setImage:[UIImage imageNamed:@"like"]];
        [self addSubview:imgCollect];
        
        self.labelCollectNum = [[UILabel alloc]init];
        [self.labelCollectNum setTextAlignment:NSTextAlignmentLeft];
        [self.labelCollectNum setFont:font_nonr_size(14)];
        [self.labelCollectNum setTextColor:WWLowGreyText];
        [self addSubview:self.labelCollectNum];
        
        //评论
        imgCommit = [[UIImageView alloc]init];
        [imgCommit setImage:[UIImage imageNamed:@"leave-word"]];
        [self addSubview:imgCommit];
        
        self.labelCommentNum = [[UILabel alloc]init];
        [self.labelCommentNum setTextAlignment:NSTextAlignmentLeft];
        [self.labelCommentNum setFont:font_nonr_size(14)];
        [self.labelCommentNum setTextColor:WWLowGreyText];
        [self addSubview:self.labelCommentNum];
        
        //分享
        imgShare = [[UIImageView alloc]init];
        [imgShare setImage:[UIImage imageNamed:@"share"]];
        [self addSubview:imgShare];
        
        self.labelShareNum = [[UILabel alloc]init];
        [self.labelShareNum setTextAlignment:NSTextAlignmentLeft];
        [self.labelShareNum setFont:font_nonr_size(14)];
        [self.labelShareNum setTextColor:WWLowGreyText];
        [self addSubview:self.labelShareNum];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete1"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteCellData:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];
        
        self.line = [[UILabel alloc]init];
        self.line.backgroundColor = WWPageLineColor;
        [self addSubview:self.line];
        
    }
    return self;
}

- (void)publishData:(WWHomePageModel *)model is_Type:(BOOL)type{
    
    if (type == YES) {      // 发布
        self.imgHead.hidden = YES;
        self.labelUserNickName.hidden = YES;
        self.labelTime.hidden = NO;
        [self.btnTag mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
        }];
        
    }else {         // 收藏
        self.imgHead.hidden = NO;
        self.labelUserNickName.hidden = NO;
        self.labelTime.hidden = YES;
        
        [self.imgHead setImage:[UIImage imageNamed:model.strUserHead]];
        [self.labelUserNickName setText:model.strUserNickName];
        
        [self.btnTag mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.imgHead.mas_centerY);
        }];
    }
    
    [self.btnTag setTitle:[NSString stringWithFormat:@" %@ ",model.strTag] forState:UIControlStateNormal];
    [self.labelTitle setText:model.strTitle];
    
    //判断是否有描述
    if (model.strDesc) {
        [self.labelDesc setHidden:NO];
        [self.labelDesc setText:model.strDesc];
        
        //判断是否有图片
        if (model.strImageContent) {
            [self.imgContent setImage:[UIImage imageNamed:model.strImageContent]];
            [self.imgContent setHidden:NO];
        }
        else
        {
            [self.imgContent setHidden:YES];
            
            [self.labelShareNum mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.labelDesc.mas_bottomMargin).offset(15);
            }];
        }
    }
    else
    {
        [self.labelDesc setHidden:YES];
        
        [self.imgContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottomMargin).offset(15);
        }];
        
        //判断是否有图片
        if (model.strImageContent) {
            [self.imgContent setHidden:NO];
            [self.imgContent setImage:[UIImage imageNamed:model.strImageContent]];
        }
        else
        {
            [self.imgContent setHidden:YES];
            
            [self.labelShareNum mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.labelTitle.mas_bottomMargin).offset(15);
            }];
        }
    }
    
    self.labelTime.text = model.strTime;
    self.labelLike.text= model.strFavtionNum;
    self.labelShareNum.text = model.strShareNum;
    self.labelCommentNum.text = model.strCommitNum;
    self.labelCollectNum.text = model.strCollectNum;

    
    [self layoutSubviews];
}

- (void)layoutSubviews{
    
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    [self.labelUserNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgHead.mas_right).offset(10);
        make.top.bottom.equalTo(self.imgHead);
        make.width.equalTo(@150);
    }];
    
    [self.btnTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@(MainView_Width-160));
    }];
    
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.btnTag.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.btnTag.mas_bottom).offset(25);
        make.height.greaterThanOrEqualTo(@0);
        
    }];
    [self.labelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.greaterThanOrEqualTo(@20);
        make.top.equalTo(self.labelTitle.mas_bottomMargin).offset(15);
    }];
    [self.imgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.lessThanOrEqualTo(@300);
        make.top.equalTo(self.labelDesc.mas_bottomMargin).offset(15);
    }];
    
    [self.labelShareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.imgContent.mas_bottomMargin).offset(15);
        make.height.equalTo(@20);
    }];
    [imgShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelShareNum.mas_right).offset(5);
        make.width.height.equalTo(@13);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
    }];
    
    [self.labelCommentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgShare.mas_right).offset(17);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
        make.height.equalTo(@20);
    }];
    [imgCommit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelCommentNum.mas_right).offset(5);
        make.width.height.equalTo(@13);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
    }];
    
    [self.labelCollectNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgCommit.mas_right).offset(17);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
        make.height.equalTo(@20);
    }];
    [imgCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelCollectNum.mas_right).offset(5);
        make.width.height.equalTo(@13);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
    }];
    
    [self.labelLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgCollect.mas_right).offset(17);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
        make.height.equalTo(@20);
    }];
    [imgLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelLike.mas_right).offset(5);
        make.width.height.equalTo(@13);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.labelShareNum.mas_centerY);
    }];

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelShareNum.mas_bottomMargin).offset(15);
        make.width.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

//在表格cell中 计算出高度
-(CGFloat)rowHeight
{
    
    [self layoutIfNeeded];
    //3.  视图的最大 Y 值
    CGFloat h= CGRectGetMaxY(self.line.frame);
    
    return h;//最大的高度+10
}

- (void)deleteCellData:(UIButton *)sender{
    self.deleteCell();
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
