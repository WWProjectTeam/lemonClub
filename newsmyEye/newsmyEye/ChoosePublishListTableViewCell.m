//
//  ChoosePublishListTableViewCell.m
//  newsmyEye
//
//  Created by songs on 16/9/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "ChoosePublishListTableViewCell.h"

@implementation ChoosePublishListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelTitle = [[UILabel alloc]init];
        self.labelTitle.textColor = RGBCOLOR(50, 50, 50);
        self.labelTitle.font = font_nonr_size(15);
        [self addSubview:self.labelTitle];
        
        self.selectImage = [[UIImageView alloc]init];
        self.selectImage.image = [UIImage imageNamed:@"yes"];
        [self addSubview:self.selectImage];
        self.selectImage.hidden = YES;
        
        self.cellLine = [[UILabel alloc]init];
        self.cellLine.backgroundColor = WWPageLineColor;
        [self addSubview:self.cellLine];
        
    }
    return self;
}

- (void)reloadPublishListData:(NSDictionary *)dic{
    self.labelTitle.text = [dic objectForKey:@"name"];
    if ([[dic objectForKey:@"is_select"] integerValue] == 1) {
        self.selectImage.hidden = YES;
        self.labelTitle.textColor = RGBCOLOR(50, 50, 50);
    }else{
        self.selectImage.hidden = NO;
        self.labelTitle.textColor = RGBCOLOR(237, 200, 30);
    }
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-17);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
    }];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
