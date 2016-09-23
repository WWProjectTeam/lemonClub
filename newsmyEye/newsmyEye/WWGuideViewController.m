//
//  WWGuideViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWGuideViewController.h"
#import "WWLoginViewController.h"


@interface WWGuideViewController ()<UIScrollViewDelegate>{
    UIScrollView *guideScrollview;
    UILabel *labelOne;
    UILabel *labelTwo;
    UILabel *labelThree;
    UIView  *selectBackView;
}

@end

@implementation WWGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    guideScrollview = [[UIScrollView alloc]init];
    guideScrollview.backgroundColor = [UIColor whiteColor];
    guideScrollview.contentSize = CGSizeMake(MainView_Width*3, 0);
    guideScrollview.pagingEnabled = YES;
    guideScrollview.bounces = NO;
    guideScrollview.delegate = self;
    [self.view addSubview:guideScrollview];
    [guideScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self.view);
    }];
    
    UIView *lastView = nil;
    for (int i =0; i< 3; i++) {
        UIView *view = [[UIView alloc]init];
        [guideScrollview addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MainView_Width);
            make.height.mas_equalTo(MainView_Height);
            make.top.mas_equalTo(0);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else{
                make.left.mas_equalTo(0);
            }
        }];
        UIImageView *guideImage = [[UIImageView alloc]init];
        guideImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mid-img%d",i+1]];
        [view addSubview:guideImage];
        [guideImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            if (i==0) {
                make.top.mas_equalTo(75);
            }else if (i==1){
                make.top.mas_equalTo(106);
            }else{
                make.top.mas_equalTo(135);
            }
        }];
        UIImageView *contentImg = [[UIImageView alloc]init];
        contentImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"word-bottom%d",i+1]];
        [view addSubview:contentImg];
        [contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(guideImage.mas_centerX);
            make.bottom.equalTo(view.mas_bottom).offset(-100);
        }];
        
        lastView = view;
    }
    
    selectBackView = [[UIView alloc]init];
    selectBackView.backgroundColor = btn_organ;
    selectBackView.layer.masksToBounds = YES;
    selectBackView.layer.cornerRadius = 15;
    [self.view addSubview:selectBackView];
    
    labelOne = [[UILabel alloc]init];
    labelOne.text = @"1";
    labelOne.textColor = [UIColor whiteColor];
    labelOne.font = font_nonr_size(17);
    [self.view addSubview:labelOne];
    
    labelTwo = [[UILabel alloc]init];
    labelTwo.text = @"2";
    labelTwo.textColor = btn_organ;
    labelTwo.font = font_nonr_size(17);
    [self.view addSubview:labelTwo];
    
    labelThree = [[UILabel alloc]init];
    labelThree.text = @"3";
    labelThree.textColor = btn_organ;
    labelThree.font = font_nonr_size(17);
    [self.view addSubview:labelThree];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登陆柠檬社" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.backgroundColor = btn_organ;
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginButton.mas_top).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.7);
    }];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginButton.mas_top).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1);
    }];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginButton.mas_top).offset(-15);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.3);
    }];
    [selectBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelOne);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.7);
        make.height.width.mas_equalTo(30);
    }];
}

- (void)loginButtonClick:(UIButton *)sender{
    [UIView animateWithDuration:1 animations:^{
        self.view.alpha=0.8;//让scrollview 渐变消失
    }completion:^(BOOL finished) {
        AppDelegate* appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        WWLoginViewController * login = [[WWLoginViewController alloc]init];
        
        //导航条创建
        appDelegate.navtionViewControl = [[UINavigationController alloc]initWithRootViewController:login];
        appDelegate.window.rootViewController = appDelegate.navtionViewControl;
    } ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = guideScrollview.contentOffset.x;
    if (x == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [selectBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(labelOne);
                make.height.width.mas_equalTo(30);
                make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.7);
            }];
            labelOne.textColor = [UIColor whiteColor];
            labelTwo.textColor =btn_organ;
            labelThree.textColor =btn_organ;
        }];
    }else if(x == MainView_Width*2){
        [UIView animateWithDuration:0.3 animations:^{
            [selectBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(labelOne);
                make.height.width.mas_equalTo(30);
                make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.3);
            }];
            labelOne.textColor = btn_organ;
            labelTwo.textColor = btn_organ;
            labelThree.textColor =[UIColor whiteColor];
        }];
    }else if(x == MainView_Width){
        [UIView animateWithDuration:0.3 animations:^{
            [selectBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(labelOne);
                make.height.width.mas_equalTo(30);
                make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1);
            }];
            labelOne.textColor = btn_organ;
            labelTwo.textColor =[UIColor whiteColor];
            labelThree.textColor =btn_organ;
        }];
    }
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
