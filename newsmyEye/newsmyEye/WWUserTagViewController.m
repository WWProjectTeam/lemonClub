//
//  WWUserTagViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/6.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWUserTagViewController.h"
#import "ZYQSphereView.h"
#import "WWMyUserTagListViewController.h"

@interface WWUserTagViewController (){
    ZYQSphereView *sphereView;
    NSTimer *timer;
}

@end

@implementation WWUserTagViewController

-(void)viewWillAppear:(BOOL)animated{
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self creatUI];
}

- (void)creatUI{
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"back-img3"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    //返回按钮
    UIButton * goBack = [[UIButton alloc]init];
    [goBack setImage:[UIImage imageNamed:@"back-whirte"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBack];
    
    [goBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.top.equalTo(@28);
        make.width.equalTo(@15);
        make.height.equalTo(@26);
    }];
    
    // 标题
    UILabel  *tagLabel = [[UILabel alloc]init];
    tagLabel.text = @"我的标签";
    tagLabel.font = font_nonr_size(19);
    tagLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(goBack.mas_centerY);
    }];

    
#pragma mark ---- 
    
    sphereView = [[ZYQSphereView alloc] init];
    sphereView.center=CGPointMake(self.view.center.x, self.view.center.y-30);
    sphereView.isPanTimerStart=YES;
    [self.view addSubview:sphereView];
    [sphereView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(75, 10, 80, 10));
    }];

    // 添加标签
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
        backView.backgroundColor = [UIColor clearColor];
        
        UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake((backView.width-15)/2, 0, 15, 15)];
        subV.backgroundColor = btn_organ;
        subV.layer.masksToBounds=YES;
        subV.layer.cornerRadius=7.5;
        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:subV];
        
        UILabel *tabLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, subV.bottom+15, backView.width, 15)];
        tabLabel.text = @"我的标签";
        tabLabel.textColor = RGBCOLOR(237, 200, 30);
        tabLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:tabLabel];
        
        [views addObject:backView];
        
    }
    [sphereView timerStart];
    [sphereView setItems:views];
    
    
    //调整标签
    UIButton *adjustButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [adjustButton setTitle:@"调整我的标签" forState:UIControlStateNormal];
    [adjustButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    adjustButton.backgroundColor  = [UIColor clearColor];
    adjustButton.layer.cornerRadius = 5;
    adjustButton.layer.masksToBounds = YES;
    adjustButton.layer.borderColor = [UIColor whiteColor].CGColor;
    adjustButton.layer.borderWidth = 1.0f;
    [adjustButton addTarget:self action:@selector(adjustClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adjustButton];
    [adjustButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sphereView.mas_bottom);
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
}

- (void)adjustClick:(UIButton *)sender{
    WWMyUserTagListViewController *userTagListVC = [[WWMyUserTagListViewController alloc]init];
    [self.navigationController pushViewController:userTagListVC animated:YES];
}

-(void)subVClick:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    
    BOOL isStart=[sphereView isTimerStart];
    
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [sphereView timerStart];
            }
        }];
    }];
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
