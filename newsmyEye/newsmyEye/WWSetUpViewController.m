/*
 *      清除缓存我用SDImageView的自动缓存机制
        应用评分需要添加id就ok
        意见反馈没有找到UI   自己随意写的  UI有问题找我重新改下
        分享暂时没有加
 */


//
//  WWSetUpViewController.m
//  newsmyEye
//
//  Created by push on 16/9/20.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWSetUpViewController.h"
#import "WWFeedbackViewController.h"

@interface WWSetUpViewController ()<UIAlertViewDelegate>

@end

@implementation WWSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"设置";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    /////////
    NSArray *titleArr = @[@"推送提醒",@"清除缓存",@"应用评分",@"意见反馈",@"分享APP"];
    
    UIView *lastView = nil;
    for (int i=0; i<5; i++) {
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.equalTo(self.view.mas_width);
            make.height.mas_equalTo(44);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.mas_equalTo(64);
            }
        }];
        // 标题
        UILabel *title = [[UILabel alloc]init];
        title.text = titleArr[i];
        title.textColor = RGBCOLOR(50, 50, 50);
        title.font = [UIFont systemFontOfSize:15];
        [backView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.centerY.equalTo(backView.mas_centerY);
        }];
        
        // 右侧图标
        if (i>0) {
            UIImageView *rightArrow = [[UIImageView alloc]init];
            rightArrow.image = [UIImage imageNamed: @"right2"];
            [backView addSubview:rightArrow];
            [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView.mas_centerY);
                make.right.equalTo(backView.mas_right).offset(-17);
            }];
        }else{
            UISwitch *notifiSwitch = [[UISwitch alloc]init];
            [notifiSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:notifiSwitch];
            [notifiSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView.mas_centerY);
                make.right.equalTo(backView.mas_right).offset(-17);
            }];
        }
        
        UILabel *bottomLine = [[UILabel alloc]init];
        bottomLine.backgroundColor = RGBCOLOR(214, 215, 219);
        [backView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.right.equalTo(self.view.mas_right).offset(-17);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(backView.mas_bottom).offset(-0.5);
        }];
        
        if (i>0) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 2000+i;
            [backView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.width.height.equalTo(backView);
            }];
        }
        
        lastView = backView;
    }
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    exitButton.backgroundColor = btn_organ;
    exitButton.layer.cornerRadius = 5;
    exitButton.layer.masksToBounds = YES;
    [exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.height.mas_equalTo(44);
        make.top.equalTo(lastView.mas_bottom).offset(40);
    }];
    
}

// 退出登录
- (void)exitButtonClick:(UIButton *)sender{
    
}

// 状态选择
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 2001) {       //清除缓存
        
        NSString *clearCacheName = [self clearCacheNumberToCalculateFormGetsize];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清除缓存" message: clearCacheName delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];
        
    }else if (sender.tag == 2002){      // 应用评分
        
        NSString *url = [NSString stringWithFormat:@""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }else if (sender.tag == 2003){      // 意见反馈
        
        WWFeedbackViewController *feedbackVC = [[WWFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
        
    }else if (sender.tag == 2004){      // 分享app
        
    }
}

// 打开关闭通知
- (void)switchClick:(UISwitch *)switcho{
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
    }
}

///缓存计算转换
-(NSString *)clearCacheNumberToCalculateFormGetsize{
    float getsize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = getsize/1024.0/1024.0 >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",getsize/1024.0/1024.0] : [NSString stringWithFormat:@"清理缓存(%.2fK)",getsize/1024.0];
    return clearCacheName;
}
// 返回拜拜
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
