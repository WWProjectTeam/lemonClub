//
//  WWFlowDetialViewController.m
//  Carcorder
//
//  Created by newsmy on 16/6/3.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWFlowDetialViewController.h"
#import "WWFlowRechargeViewController.h"
@implementation WWFlowDetialViewController{
    UILabel * labelPresentPackage;
    UILabel * labelMaturities;
    UILabel * labelSIMCard;
    UIButton * btnBuyPackage;

    
    UILabel * labelTotalFlow;
    UILabel * labelUsedFlow;
    UILabel * labelSurplusFlow;

    UILabel * labelTotalFlowDesc;
    
    UIButton * btnUpdateFlow;
    
    UIView * viewUpdateFlow;
    UIView * ViewUsedFlow;
    UIView * viewSurplusFlow;
    UIView * viewTotalFlow;
    
    UIView * viewBuyPacketage;
    UILabel * labelBuyPacketage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    
    [self reloadData];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"流量";
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    
    /**
     *  初始化界面
     */
    [self createrView];
    
  //  [self reloadData];
}

-(void)reloadData{
    if ([self isConnectionAvailable])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view addSubview:hud];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
        hud.delegate = self;
        hud.labelText = @"正在查询,请稍后";
        FenceInfo *info=[[FenceInfo alloc] init];
        
        info.AccountID=[USER valueForKey:@"userName"];
        
       // info.IMEI = @"35156502900041";
        info.IMEI=[USER valueForKey:@"IMEI"];
        
        [HttpEngine queryFlowInfo:info and:^(NSDictionary *dic) {
            [hud hide:YES afterDelay:0];
            if([dic isKindOfClass:[NSDictionary class]])
            {
                
                
                
                NSString * expirationDate = dic[@"expirationDate"];
                NSString * totalTraffic = dic[@"totalTraffic"];
                NSString * current_month_totalTraffic = dic[@"current_month_totalTraffic"];

                NSString * trafficUsed = dic[@"trafficUsed"];
                NSString * trafficRemaining = dic[@"trafficRemaining"];
                
                NSString * simcardType = dic[@"simcardType"];
                
                //判断SIM卡的类型0-湖南 1-深圳
                if ([StringAppend(simcardType)isEqualToString:@"0"]) {
                    [labelTotalFlowDesc setText:@"总流量"];
                }
                
                
                [labelMaturities setText:expirationDate];
                
                if (totalTraffic) {
                    [labelTotalFlow setText:totalTraffic];
                }
                else
                {
                    [labelTotalFlow setText:current_month_totalTraffic];
                }
                [labelUsedFlow setText:trafficUsed];
                [labelSurplusFlow setText:trafficRemaining];
                [labelSIMCard setText:dic[@"iccid"]];
                [labelPresentPackage setText:dic[@"currentRatePlan"]];
                
                //判断是否需要隐藏流量升级
                NSString * strCanUpgradeTraffic = StringAppend(dic[@"canUpgradeTraffic"]);
                
                //0-不能升级  1-能升级
                if ([strCanUpgradeTraffic isEqualToString:@"0"]) {
                    [viewUpdateFlow setHidden:YES];
                }
                
                //判断是否过期 1-过期 0-没过期
                NSString * strOverdue = StringAppend(dic[@"overdue"]);
                
                if ([strOverdue isEqualToString:@"1"]) {
                    [labelMaturities setText:@"已过期"];
                }
                
                //判断是否需要隐藏购买套餐
                NSString * strCanPurchasePackage = StringAppend(dic[@"canPurchasePackage"]);
                
                if ([strCanPurchasePackage isEqualToString:@"0"]) {
                    [viewBuyPacketage setHidden:YES];
                    
                    //重设frame
                    [viewTotalFlow setFrame:CGRectMake(0, CGRectGetMaxY(viewBuyPacketage.frame)-30, kScreen_width, 50)];
                    [ViewUsedFlow setFrame:CGRectMake(0, CGRectGetMaxY(viewTotalFlow.frame), kScreen_width, 50)];
                    [viewSurplusFlow setFrame:CGRectMake(0, CGRectGetMaxY(ViewUsedFlow.frame), kScreen_width, 50)];
                    [viewUpdateFlow setFrame:CGRectMake(0, CGRectGetMaxY(viewSurplusFlow.frame), kScreen_width, 50)];

                }
                
                /*
                //判断是否需要置灰购买套餐
                NSString * strCanPurchasePackage = StringAppend(dic[@"canPurchasePackage"]);

                
                if ([strCanPurchasePackage isEqualToString:@"0"]) {
                    [viewBuyPacketage setUserInteractionEnabled:NO];
                    [labelBuyPacketage setTextColor:RGBCOLOR(164, 164, 164)];
                }
                
                */
            }else{
                if([dic isKindOfClass:[NSString class]])
                {
                    [self.view makeToast:(NSString*)dic duration:1.0 position:CSToastPositionCenter];
                    
                    if ([(NSString *)dic isEqualToString:@"当前设备没有sim卡！"]) {
                        
                        //如果没有卡，延时1S返回上级
                        
                        double delayInSeconds = 1.0;
                        
                        __block WWFlowDetialViewController* bself = self;
                        
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            
                            [bself.navigationController popViewControllerAnimated:YES];
                            
                        });
                        
                    }
                }
                
            }
            
        }];
    }
}


-(BOOL)isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    
    if (!isExistenceNetwork)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"网络不可用,请检查网络连接", nil);
        hud.minSize = CGSizeMake(100.0f, 50.0f);
        [hud hide:YES afterDelay:3.0];
        return NO;
    }
    
    return isExistenceNetwork;
}


-(void)createrView{
#pragma mark - 界面Body 第一节
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height-70)];
    [self.view addSubview:scrollView];
    
    //当前套餐
    UIView * viewSIMCard = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, 50)];
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
        labelSIMCard = [[UILabel alloc]init];
        // [labelPresentPackage setText:@"半年包-当天300M"];
        [labelSIMCard setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelSIMCard setFont:[UIFont systemFontOfSize:16]];
        [labelSIMCard setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelSIMCard setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelSIMCard];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [scrollView addSubview:viewSIMCard];
    
    //当前套餐
    UIView * viewPresentPackage = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewSIMCard.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"当前套餐"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        labelPresentPackage = [[UILabel alloc]init];
       // [labelPresentPackage setText:@"半年包-当天300M"];
        [labelPresentPackage setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelPresentPackage setFont:[UIFont systemFontOfSize:16]];
        [labelPresentPackage setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelPresentPackage setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelPresentPackage];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [scrollView addSubview:viewPresentPackage];

    
    
    //到期时间
    UIView * ViewMaturities = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(viewPresentPackage.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"到期时间"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        labelMaturities = [[UILabel alloc]init];
        //[labelMaturities setText:@"2016-11-19 13:55:49"];
        [labelMaturities setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelMaturities setFont:[UIFont systemFontOfSize:16]];
        [labelMaturities setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelMaturities setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelMaturities];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [scrollView addSubview:ViewMaturities];
    
    
    
    //购买套餐
    viewBuyPacketage = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ViewMaturities.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        labelBuyPacketage  = [[UILabel alloc]init];
        [labelBuyPacketage setText:@"购买套餐"];
        [labelBuyPacketage setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelBuyPacketage setTextAlignment:NSTextAlignmentLeft];
        [labelBuyPacketage setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
        [labelBuyPacketage setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelBuyPacketage];
     
        //右侧标记
        UIImageView * iamgeTemp = [[UIImageView alloc]init];
        [iamgeTemp setImage:[UIImage imageNamed:@"充值1_03"]];
        [iamgeTemp setFrame:CGRectMake(kScreen_width-20-10, 15, 20, 20)];
        [viewTemp addSubview:iamgeTemp];
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        
        UITapGestureRecognizer * gesTemp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyPackage)];
        [viewTemp addGestureRecognizer:gesTemp];
        viewTemp;
    });
    
    [scrollView addSubview:viewBuyPacketage];
    
    
#pragma mark - 界面Body 第二节
    //当前套餐
    viewTotalFlow = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewBuyPacketage.frame)+20, kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        labelTotalFlowDesc  = [[UILabel alloc]init];
        [labelTotalFlowDesc setText:@"本月总流量"];
        [labelTotalFlowDesc setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTotalFlowDesc setTextAlignment:NSTextAlignmentLeft];
        [labelTotalFlowDesc setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTotalFlowDesc setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTotalFlowDesc];
        
        //显示值
        labelTotalFlow = [[UILabel alloc]init];
     //   [labelTotalFlow setText:@"100M"];
        [labelTotalFlow setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelTotalFlow setFont:[UIFont systemFontOfSize:16]];
        [labelTotalFlow setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelTotalFlow setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelTotalFlow];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [scrollView addSubview:viewTotalFlow];
    
    
    
    //已使用流量
    ViewUsedFlow = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewTotalFlow.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"已使用流量"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        labelUsedFlow = [[UILabel alloc]init];
      //  [labelUsedFlow setText:@"100MB"];
        [labelUsedFlow setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelUsedFlow setFont:[UIFont systemFontOfSize:16]];
        [labelUsedFlow setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelUsedFlow setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelUsedFlow];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [scrollView addSubview:ViewUsedFlow];
    
    //剩余流量
    viewSurplusFlow = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ViewUsedFlow.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"剩余流量"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:30/255.0 green:31/255.0 blue:32/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //显示值
        labelSurplusFlow = [[UILabel alloc]init];
     //   [labelSurplusFlow setText:@"100MB"];
        [labelSurplusFlow setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelSurplusFlow setFont:[UIFont systemFontOfSize:16]];
        [labelSurplusFlow setFrame:CGRectMake(0, 0, kScreen_width-10, 50)];
        [labelSurplusFlow setTextAlignment:NSTextAlignmentRight];
        [viewTemp addSubview:labelSurplusFlow];
        
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        viewTemp;
    });
    
    [scrollView addSubview:viewSurplusFlow];
    
    //流量升级
    viewUpdateFlow = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(viewSurplusFlow.frame), kScreen_width, 50)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述问题
        UILabel * labelTemp  = [[UILabel alloc]init];
        [labelTemp setText:@"流量升级"];
        [labelTemp setFrame:CGRectMake(10, 0, kScreen_width-10, 50)];
        [labelTemp setTextAlignment:NSTextAlignmentLeft];
        [labelTemp setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
        [labelTemp setFont:[UIFont systemFontOfSize:16]];
        [viewTemp addSubview:labelTemp];
        
        //右侧标记
        UIImageView * iamgeTemp = [[UIImageView alloc]init];
        [iamgeTemp setImage:[UIImage imageNamed:@"充值1_03"]];
        [iamgeTemp setFrame:CGRectMake(kScreen_width-20-10, 15, 20, 20)];
        [viewTemp addSubview:iamgeTemp];
        
        //底部线条
        UIImageView * imageLine = [[UIImageView alloc]init];
        [imageLine setBackgroundColor:[UIColor colorWithRed:184/255.0 green:185/255.0 blue:186/255.0 alpha:1.0]];
        [imageLine setFrame:CGRectMake(0, 49.5, kScreen_width, 0.5)];
        [viewTemp addSubview:imageLine];
        
        [viewTemp setUserInteractionEnabled:YES];
        UITapGestureRecognizer * gesTemp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateFlow)];
        [viewTemp addGestureRecognizer:gesTemp];
        
        viewTemp;
    });
    
    [scrollView addSubview:viewUpdateFlow];
    
    [scrollView setContentSize:CGSizeMake(kScreen_width, CGRectGetMaxY(viewUpdateFlow.frame))];
    
    
#pragma mark - footer 
    UIView * viewFooter = ({
        UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_height-70, kScreen_width, 70)];
        [viewTemp setBackgroundColor:[UIColor whiteColor]];
        
        //描述label
        UILabel * labelTemp01  = [[UILabel alloc]init];
        [labelTemp01 setText:@"温馨提示:"];
        [labelTemp01 setFrame:CGRectMake(20, 8, kScreen_width-20, 30)];
        [labelTemp01 setTextAlignment:NSTextAlignmentLeft];
        [labelTemp01 setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
        [labelTemp01 setFont:[UIFont systemFontOfSize:14]];
        [viewTemp addSubview:labelTemp01];
        
        UILabel * labelTemp02 = [[UILabel alloc]init];
        [labelTemp02 setText:@"结算日每月26日23时59分59秒"];
        [labelTemp02 setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
        [labelTemp02 setFont:[UIFont systemFontOfSize:14]];
        [labelTemp02 setFrame:CGRectMake(20, 32, kScreen_width-10, 30)];
        [labelTemp02 setTextAlignment:NSTextAlignmentLeft];
        [viewTemp addSubview:labelTemp02];
        

        
        viewTemp;
    });
    
    [self.view addSubview:viewFooter];
    
}



#pragma mark - 购买和升级
-(void)buyPackage{
    WWFlowRechargeViewController * flow = [[WWFlowRechargeViewController alloc]init];
    flow.rechargeType = RechargeTypepurchasePackage;
    
    [self.navigationController pushViewController:flow animated:YES];
}


-(void)updateFlow{
    WWFlowRechargeViewController * flow = [[WWFlowRechargeViewController alloc]init];
    flow.rechargeType = RechargeTypeUpdatePackage;

    [self.navigationController pushViewController:flow animated:YES];
}
@end
