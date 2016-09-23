//
//  WWMyUserTagListViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/23.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWMyUserTagListViewController.h"

@interface WWMyUserTagListViewController ()

@end

@implementation WWMyUserTagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"我的标签";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self creatUI];
}

- (void)creatUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择您的阅读基因";
    titleLabel.textColor = WWPlaceTextColor;
    titleLabel.font = font_nonr_size(12);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(74);
    }];
    
    UILabel *titleLine = [[UILabel alloc]init];
    titleLabel.backgroundColor = WWPageLineColor;
    [self.view addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    UIScrollView *tagListBackScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:tagListBackScrollView];
    [tagListBackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.top.equalTo(titleLine.mas_bottom).offset(15);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    NSArray *tagArray = @[@" 萌宠 ",@" 我中意的歌词 ",@"最美的逆行",@"get这个冷笑话",@"一次心灵的旅程",@"都肉联盟",@"反抗669联盟",@"魔镜魔镜谁是这个世界上最美丽的女人",@"我最喜欢的表情包"];
    UIButton *lastButton = nil;
    CGFloat rowWidth = 0;
    CGFloat heightYY = 0;
    for (int i = 0; i< tagArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:tagArray[i] forState:UIControlStateNormal];
        [button setTitleColor:btn_organ forState:UIControlStateNormal];
        button.titleLabel.font = font_nonr_size(15);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = btn_organ.CGColor;
        button.layer.borderWidth = 0.5;
        [tagListBackScrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            if (button) {
                
            }
        }];
        
        lastButton = button;
    }
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
