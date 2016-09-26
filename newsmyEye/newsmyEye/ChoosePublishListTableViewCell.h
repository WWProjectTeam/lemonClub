//
//  ChoosePublishListTableViewCell.h
//  newsmyEye
//
//  Created by songs on 16/9/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePublishListTableViewCell : UITableViewCell

@property (strong) UILabel    *labelTitle;
@property (strong) UIImageView    *selectImage;
@property (strong) UILabel    *cellLine;

- (void)reloadPublishListData:(NSDictionary *)dic;

@end
