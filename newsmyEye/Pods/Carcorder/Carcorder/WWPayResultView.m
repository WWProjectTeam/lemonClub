//
//  WWPayResultView.m
//  Carcorder
//
//  Created by newsmy on 16/6/6.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWPayResultView.h"
#import "WWFlowRechargeViewController.h"
@implementation WWPayResultView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"交易详情";
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    
    /**
     *  初始化界面
     */
    [self CreaterView];
    
    /**
     *  控制返回逻辑
     */
    
    
    //得到当前视图控制器中的所有控制器
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    
    for (int i = 0;i<array.count ; i++) {
        
        UIViewController *controller = array[i];
        
        if ([controller isKindOfClass:[WWFlowRechargeViewController class]]) {
            
            [array removeObjectAtIndex:i];
        }
        
    }
    //把删除后的控制器数组再次赋值
    [self.navigationController setViewControllers:[array copy] animated:YES];
}

-(void)CreaterView{
    //顶部logo
    UIImageView * imageLogo = [[UIImageView alloc]init];
    [imageLogo setImage:[UIImage imageNamed:@"支付成功"]];
    [imageLogo setFrame:CGRectMake((kScreen_width-56)/2, 84,56, 56)];
    [self.view addSubview:imageLogo];
    
    UILabel * labelPaySuccess = [[UILabel alloc]init];
    [labelPaySuccess setText:@"支付成功"];
    [labelPaySuccess setTextColor:RGBCOLOR(79, 210, 194)];
    [labelPaySuccess setFont:[UIFont boldSystemFontOfSize:30]];
    [labelPaySuccess setFrame:CGRectMake(0, CGRectGetMaxY(imageLogo.frame), kScreen_width, 50)];
    [labelPaySuccess setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelPaySuccess];
    
#pragma mark - body
    //body
    //当前套餐
    UIView * viewSIMCard = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(labelPaySuccess.frame)+20, kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"SIM卡"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        UILabel * labelValue = [[UILabel alloc]init];
        [labelValue setText:_strSimCard];
        [labelValue setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelValue setFont:[UIFont systemFontOfSize:16]];
        [labelValue setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelValue setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelValue];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });

    [self.view addSubview:viewSIMCard];
    
    
    
    UIView * viewPackageType = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewSIMCard.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"套餐类型"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        UILabel * labelValue = [[UILabel alloc]init];
        [labelValue setText:_strPackageType];
        [labelValue setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelValue setFont:[UIFont systemFontOfSize:16]];
        [labelValue setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelValue setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelValue];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [self.view addSubview:viewPackageType];
    
    UIView * viewPrice = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewPackageType.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"支付金额"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        UILabel * labelValue = [[UILabel alloc]init];
        [labelValue setText:_strPrice];
        [labelValue setTextColor:RGBCOLOR(79, 210, 194)];
        [labelValue setFont:[UIFont systemFontOfSize:16]];
        [labelValue setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelValue setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelValue];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [self.view addSubview:viewPrice];
    
    
    UIView * viewPayType = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewPrice.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"支付类型"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        UILabel * labelValue = [[UILabel alloc]init];
        [labelValue setText:_strPayType];
        [labelValue setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelValue setFont:[UIFont systemFontOfSize:16]];
        [labelValue setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelValue setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelValue];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [self.view addSubview:viewPayType];
    
    
    UILabel * labelTIP = [[UILabel alloc]init];
    [labelTIP setText:@"提示:可能需要5分钟到账"];
    [labelTIP setTextColor:RGBCOLOR(105, 105, 105)];
    [labelTIP setFont:[UIFont systemFontOfSize:14]];
    [labelTIP setFrame:CGRectMake(10, CGRectGetMaxY(viewPayType.frame)+20, kScreen_width-40, 30)];
    [labelTIP setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:labelTIP];
}


@end
