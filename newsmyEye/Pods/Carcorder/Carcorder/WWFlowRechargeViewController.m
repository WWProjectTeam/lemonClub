//
//  WWFlowRechargeViewController.m
//  Carcorder
//
//  Created by newsmy on 16/6/2.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWFlowRechargeViewController.h"
#import "WWFlowSelectButton.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WWPayResultView.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "HttpEngine.h"


@implementation WWFlowRechargeViewController{

    NSDictionary * dicServiceData;
    
    UIScrollView * scrollViewFlow;
    
    NSDictionary * dicPayInformation;
    
    BOOL boolCanOrder;
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
    if (_rechargeType == RechargeTypeUpdatePackage) {
        self.title = @"流量升级";
    }
    else
    {
        self.title=@"购买套餐";

    }
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    
    [self reloadData];
    

    
}


-(void)CreaterView{
    
    if (!scrollViewFlow) {
        if (_rechargeType == RechargeTypeUpdatePackage) {
            scrollViewFlow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-80-64)];
            [self.view addSubview:scrollViewFlow];
            
#pragma mark - footer
            UIView * viewFooter = ({
                UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_height-80, kScreen_width, 80)];
                [viewTemp setBackgroundColor:[UIColor whiteColor]];
                
                //描述label
                UILabel * labelTemp01  = [[UILabel alloc]init];
                [labelTemp01 setText:@"温馨提示:"];
                [labelTemp01 setFrame:CGRectMake(20, 8, kScreen_width-40, 30)];
                [labelTemp01 setTextAlignment:NSTextAlignmentLeft];
                [labelTemp01 setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
                [labelTemp01 setFont:[UIFont systemFontOfSize:14]];
                [viewTemp addSubview:labelTemp01];
                
                UILabel * labelTemp02 = [[UILabel alloc]init];
                [labelTemp02 setText:@"流量升级即时生效，次月自动取消，流量当月清零。结算日每月26日23时59分59秒"];
                [labelTemp02 setNumberOfLines:2];
                [labelTemp02 setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
                [labelTemp02 setFont:[UIFont systemFontOfSize:14]];
                [labelTemp02 setFrame:CGRectMake(20, 26, kScreen_width-40, 50)];
                [labelTemp02 setTextAlignment:NSTextAlignmentLeft];
                [viewTemp addSubview:labelTemp02];
                
                viewTemp;
            });
            
            [self.view addSubview:viewFooter];

        }
        else
        {
            scrollViewFlow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen_width, kScreen_height-90-64)];
            [self.view addSubview:scrollViewFlow];
            
#pragma mark - footer
            UIView * viewFooter = ({
                UIView * viewTemp = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_height-90, kScreen_width, 90)];
                [viewTemp setBackgroundColor:[UIColor whiteColor]];
                
                //描述label
                UILabel * labelTemp01  = [[UILabel alloc]init];
                [labelTemp01 setText:@"温馨提示:"];
                [labelTemp01 setFrame:CGRectMake(20, 8, kScreen_width-20, 20)];
                [labelTemp01 setTextAlignment:NSTextAlignmentLeft];
                [labelTemp01 setTextColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
                [labelTemp01 setFont:[UIFont systemFontOfSize:14]];
                [viewTemp addSubview:labelTemp01];
                
                UILabel * labelTemp02 = [[UILabel alloc]init];
                [labelTemp02 setText:@"当前套餐有效期最后一个月可订购下月套餐。\r\n套餐订购次月生效，流量当月清零不结转。结算日每月26日23时59分59秒"];
                [labelTemp02 setNumberOfLines:3];
                [labelTemp02 setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]];
                [labelTemp02 setFont:[UIFont systemFontOfSize:14]];
                [labelTemp02 setFrame:CGRectMake(20, 26, kScreen_width-40, 60)];
                [labelTemp02 setTextAlignment:NSTextAlignmentLeft];
                [viewTemp addSubview:labelTemp02];
                
                viewTemp;
            });
            
            [self.view addSubview:viewFooter];
        }
        
    }

#pragma mark - Body
    if (_rechargeType == RechargeTypeUpdatePackage) {
        [self createrUpdatePackage];
    }
    else
    {
        [self createrPurchasePackage];
    }
}

#pragma mark - 当前套餐
-(void)createrPurchasePackage{
    NSMutableArray * arrayTemp = [NSMutableArray arrayWithArray:dicServiceData[@"ratePlans"]];
    
    //查找并去除当前套餐节点
    NSInteger Y_height = 0;
    
    for (int i = 0; i<arrayTemp.count; i++) {
        
        NSDictionary * dicTemp = arrayTemp[i];
        
        /**
         *  判断并取出当前套餐
         */
        if ([StringAppend(dicTemp[@"showType"]) isEqualToString:@"0"]||[StringAppend(dicTemp[@"showType"]) isEqualToString:@"3"]) {
            //创建小节点
            UILabel * labelNodes = ({
                UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreen_width, 30)];
                [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
                [labelTemp setText:@"当前套餐"];
                [labelTemp setFont:[UIFont systemFontOfSize:14]];
                
                labelTemp;
            });
            
            [scrollViewFlow addSubview:labelNodes];
            

            
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelNodes.frame), iphone_size_scale(93), iphone_size_scale(70))];
            
            [flowView setFlowTitle:[NSString stringWithFormat:@"%@/月",dicTemp[@"monthlyData"]] forControlEvents:UIControlStateSelected];
            [flowView.labelFlow setFont:[UIFont systemFontOfSize:iphone_size_scale(16)]];
            
            
            //检索出已经订购的下月套餐
            NSString * strShowType = StringAppend(dicTemp[@"showType"]);
            
            
            if ([strShowType isEqualToString:@"3"]) {
                [flowView setPriceTitle:@"已选下月套餐" forControlEvents:UIControlStateSelected];
            }
            else
            {
                [flowView setPriceTitle:[NSString stringWithFormat:@"%@元",dicTemp[@"expense"]] forControlEvents:UIControlStateSelected];
            }

            [scrollViewFlow addSubview:flowView];
            
            //获得当前节点的类型--服务器保证数据顺序
            NSString * strTypeTemp = StringAppend(dicTemp[@"type"]);
            //单月
            if ([strTypeTemp isEqualToString:@"0"]) {
                [flowView setTimeTitle:@"单月套餐" forControlEvents:UIControlStateSelected];
            }
            
            //半年
            else if ([strTypeTemp isEqualToString:@"1"]){
                [flowView setTimeTitle:@"半年套餐" forControlEvents:UIControlStateSelected];
            }
            
            //一年
            else if ([strTypeTemp isEqualToString:@"2"]){
                
                [flowView setTimeTitle:@"一年套餐" forControlEvents:UIControlStateSelected];
            }

            if (boolCanOrder) {
                //创建当前流量按钮
                UIButton * btnemp = [[UIButton alloc]init];
                [btnemp setTitle:@"继续购买此套餐" forState:UIControlStateNormal];
                [btnemp setBackgroundColor:[UIColor whiteColor]];
                [btnemp setTitleColor:RGBCOLOR(79, 210, 194) forState:UIControlStateNormal];
                [btnemp setFrame:CGRectMake(CGRectGetMaxX(flowView.frame)+10, CGRectGetMaxY(labelNodes.frame) + iphone_size_scale(30), iphone_size_scale(110), 40)];
                btnemp.layer.cornerRadius = 3;
                [btnemp.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [btnemp setTag:[dicTemp[@"id"] intValue]];
                
                [btnemp addTarget:self action:@selector(buyOtherPackage:) forControlEvents:UIControlEventTouchUpInside];
                
                [scrollViewFlow addSubview:btnemp];
            }

            
            
            //创建完毕后移除当前节点
            [arrayTemp removeObjectAtIndex:i];
            
            
            //创建继续哦、购买当前套餐按钮
            
            
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
    }
    
    
    //遍历并拆分出不同的时间节点数据
    
    NSMutableArray * arrayMonth = [[NSMutableArray alloc]init];
    NSMutableArray * arrayHalfYear = [[NSMutableArray alloc]init];
    NSMutableArray * arrayYear = [[NSMutableArray alloc]init];
    
    //脏数据列表
    NSMutableArray * arrayOther = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< arrayTemp.count; i++) {
        NSDictionary * dicTemp = arrayTemp[i];

        //获得当前节点的类型--服务器保证数据顺序
        NSString * strTypeTemp = StringAppend(dicTemp[@"type"]);
        
        //单月
        if ([strTypeTemp isEqualToString:@"0"]) {
            [arrayMonth addObject:dicTemp];
        }
        
        //半年
        else if ([strTypeTemp isEqualToString:@"1"]){
            [arrayHalfYear addObject:dicTemp];
        }
        
        //一年
        else if ([strTypeTemp isEqualToString:@"2"]){
            
            [arrayYear addObject:dicTemp];
        }
        
        //脏数据
        else
        {
            [arrayOther addObject:dicTemp];
        }
    }
    
#pragma makr - 创建单月套餐类型节点
    UILabel * labelMonthNodes = ({
        UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, Y_height, kScreen_width, 30)];
        [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
        [labelTemp setText:@"单月套餐"];
        
        [labelTemp setFont:[UIFont systemFontOfSize:14]];
        
        labelTemp;
    });
    [scrollViewFlow addSubview:labelMonthNodes];

    
    //数据拆分完毕后开始创建界面
    for (int i = 0; i<arrayMonth.count; i++) {
        NSDictionary * dicTemp = arrayMonth[i];
        
        //检索出已经订购的下月套餐
        NSString * strShowType = StringAppend(dicTemp[@"showType"]);
        
        
        if ([strShowType isEqualToString:@"2"]) {
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelMonthNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
            
            
            [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateHighlighted];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateHighlighted];
            [flowView setPriceTitle:@"已选下月套餐" forControlEvents:UIControlStateHighlighted];
            
            [scrollViewFlow addSubview:flowView];
            
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
        else
        {
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelMonthNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
            
            
            [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateNormal];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateNormal];
            [flowView setPriceTitle:[NSString stringWithFormat:@"%@元",dicTemp[@"expense"]] forControlEvents:UIControlStateNormal];
            [flowView setViewBoardColor:RGBCOLOR(79, 210, 194) forControlEvents:UIControlStateHighlighted];
            [flowView setTag:[dicTemp[@"id"] intValue]];
            [flowView setGroupID:1];
            [flowView addTarget:self action:@selector(buyPackage:) forControlEvents:UIControlEventTouchUpInside];
            if (!boolCanOrder) {
                [flowView setEnable:boolCanOrder];
            }
            [flowView setStrTitle:StringAppend(dicTemp[@"monthlyData"])];

            [scrollViewFlow addSubview:flowView];
         
            Y_height = CGRectGetMaxY(flowView.frame);
        }
        
        
    }
    
    
 
    
#pragma makr - 创建半年套餐类型节点
    UILabel * labelHalfNodes = ({
        UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, Y_height, kScreen_width, 30)];
        [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
        [labelTemp setText:@"半年套餐"];
        
        [labelTemp setFont:[UIFont systemFontOfSize:14]];
        
        labelTemp;
    });
    [scrollViewFlow addSubview:labelHalfNodes];
    
    
    //数据拆分完毕后开始创建界面
    for (int i = 0; i<arrayHalfYear.count; i++) {
        NSDictionary * dicTemp = arrayHalfYear[i];
        
        //检索出已经订购的下月套餐
        NSString * strShowType = StringAppend(dicTemp[@"showType"]);
        
        
        if ([strShowType isEqualToString:@"2"]) {
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelHalfNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
            
            
            [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateHighlighted];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateHighlighted];
            [flowView setPriceTitle:@"已选下月套餐" forControlEvents:UIControlStateHighlighted];
            
            [scrollViewFlow addSubview:flowView];
            
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
        else
        {
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelHalfNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
            
            
            [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateNormal];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateNormal];
            [flowView setPriceTitle:[NSString stringWithFormat:@"%@元",dicTemp[@"expense"]] forControlEvents:UIControlStateNormal];
            [flowView setViewBoardColor:RGBCOLOR(79, 210, 194) forControlEvents:UIControlStateHighlighted];
            [flowView setTag:[dicTemp[@"id"] intValue]];
            [flowView setGroupID:2];
            [flowView addTarget:self action:@selector(buyPackage:) forControlEvents:UIControlEventTouchUpInside];
            [scrollViewFlow addSubview:flowView];
            [flowView setStrTitle:StringAppend(dicTemp[@"monthlyData"])];

            if (!boolCanOrder) {
                [flowView setEnable:boolCanOrder];
            }
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
        
        
    }

    
    
#pragma makr - 创建一年套餐类型节点
    UILabel * labelYearNodes = ({
        UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, Y_height, kScreen_width, 30)];
        [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
        [labelTemp setText:@"一年套餐"];
        
        [labelTemp setFont:[UIFont systemFontOfSize:14]];
        
        labelTemp;
    });
    [scrollViewFlow addSubview:labelYearNodes];
    
    
    //数据拆分完毕后开始创建界面
    for (int i = 0; i<arrayYear.count; i++) {
        NSDictionary * dicTemp = arrayYear[i];
        
        //检索出已经订购的下月套餐
        NSString * strShowType = StringAppend(dicTemp[@"showType"]);
        
        
        if ([strShowType isEqualToString:@"2"]) {
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelYearNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
            
            
            [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateHighlighted];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateHighlighted];
            [flowView setPriceTitle:@"已选下月套餐" forControlEvents:UIControlStateHighlighted];
            
            [scrollViewFlow addSubview:flowView];
            
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
        else
        {
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelYearNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
            
            
            [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateNormal];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateNormal];
            [flowView setPriceTitle:[NSString stringWithFormat:@"%@元",dicTemp[@"expense"]] forControlEvents:UIControlStateNormal];
            [flowView setViewBoardColor:RGBCOLOR(79, 210, 194) forControlEvents:UIControlStateHighlighted];
            [flowView setTag:[dicTemp[@"id"] intValue]];
            [flowView setGroupID:3];
            [flowView addTarget:self action:@selector(buyPackage:) forControlEvents:UIControlEventTouchUpInside];
            [flowView setStrTitle:StringAppend(dicTemp[@"monthlyData"])];

            
            [scrollViewFlow addSubview:flowView];
            
            if (!boolCanOrder) {
                [flowView setEnable:boolCanOrder];
            }
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
        
        
    }
    
    
#pragma makr - 创建脏数据类型节点

    if (arrayOther.count>0) {
        UILabel * labelOtherNodes = ({
            UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, Y_height, kScreen_width, 30)];
            [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
            [labelTemp setText:@"其他套餐"];
            
            [labelTemp setFont:[UIFont systemFontOfSize:14]];
            
            labelTemp;
        });
        [scrollViewFlow addSubview:labelOtherNodes];
        
        
        //数据拆分完毕后开始创建界面
        for (int i = 0; i<arrayOther.count; i++) {
            NSDictionary * dicTemp = arrayOther[i];
            
            //检索出已经订购的下月套餐
            NSString * strShowType = StringAppend(dicTemp[@"showType"]);
            
            
            if ([strShowType isEqualToString:@"2"]) {
                WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelOtherNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
                
                
                [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateHighlighted];
                [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateHighlighted];
                [flowView setPriceTitle:@"已选下月套餐" forControlEvents:UIControlStateHighlighted];
                
                [scrollViewFlow addSubview:flowView];
                
                
                Y_height = CGRectGetMaxY(flowView.frame);
            }
            else
            {
                WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+i%3*iphone_size_scale(103), CGRectGetMaxY(labelOtherNodes.frame) + i/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
                
                
                [flowView setTimeTitle:@"每月" forControlEvents:UIControlStateNormal];
                [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateNormal];
                [flowView setPriceTitle:[NSString stringWithFormat:@"%@元",dicTemp[@"expense"]] forControlEvents:UIControlStateNormal];
                [flowView setViewBoardColor:RGBCOLOR(79, 210, 194) forControlEvents:UIControlStateHighlighted];
                
                [scrollViewFlow addSubview:flowView];
                
                if (!boolCanOrder) {
                    [flowView setEnable:boolCanOrder];
                }
                
                Y_height = CGRectGetMaxY(flowView.frame);
            }
            
            
        }
        

    }
    [scrollViewFlow setContentSize:CGSizeMake(kScreen_width, Y_height)];
}

#pragma mark - 当前流量
-(void)createrUpdatePackage{
    NSMutableArray * arrayTemp = [NSMutableArray arrayWithArray:dicServiceData[@"ratePlans"]];
    
    //查找并去除当前流量节点
    NSInteger Y_height = 0;

    for (int i = 0; i<arrayTemp.count; i++) {
        
        NSDictionary * dicTemp = arrayTemp[i];
        
        /**
         *  判断并取出当前套餐
         */
        if ([StringAppend(dicTemp[@"showType"]) isEqualToString:@"0"]) {
            //创建小节点
            UILabel * labelNodes = ({
                UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreen_width, 30)];
                [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
                [labelTemp setText:@"当前流量包"];
                [labelTemp setFont:[UIFont systemFontOfSize:14]];
                
                labelTemp;
            });
            
            [scrollViewFlow addSubview:labelNodes];
            
            //创建当前流量按钮
            
            WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelNodes.frame), iphone_size_scale(93), iphone_size_scale(70))];
            [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateSelected];
            
            [scrollViewFlow addSubview:flowView];
            
            //创建完毕后移除当前节点
            [arrayTemp removeObjectAtIndex:i];
            
            Y_height = CGRectGetMaxY(flowView.frame);
        }
    }
    
    [scrollViewFlow setContentSize:CGSizeMake(kScreen_width, Y_height)];
    /**
     *  创建普通节点
     */
    
    if (arrayTemp.count<1) {
        return;
    }
    //创建小节点
    UILabel * labelNodes = ({
        UILabel * labelTemp = [[UILabel alloc]initWithFrame:CGRectMake(10, Y_height, kScreen_width, 30)];
        [labelTemp setTextColor:[UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0]];
        [labelTemp setText:@"流量升级"];
        [labelTemp setFont:[UIFont systemFontOfSize:14]];
        
        labelTemp;
    });
    
    [scrollViewFlow addSubview:labelNodes];
    
    for (int j = 0; j< arrayTemp.count; j++) {
        NSDictionary * dicTemp = arrayTemp[j];
        //创建当前流量按钮
        
        WWFlowSelectButton * flowView = [[WWFlowSelectButton alloc]initWithFrame:CGRectMake(10+j%3*iphone_size_scale(103), CGRectGetMaxY(labelNodes.frame) + j/3*iphone_size_scale(80), iphone_size_scale(93), iphone_size_scale(70))];
        
        [flowView setFlowTitle:dicTemp[@"monthlyData"] forControlEvents:UIControlStateNormal];
        [flowView setPriceTitle:[NSString stringWithFormat:@"升级费%@元",dicTemp[@"expense"]] forControlEvents:UIControlStateNormal];
        [flowView setViewBoardColor:RGBCOLOR(79, 210, 194) forControlEvents:UIControlStateHighlighted];
        [flowView addTarget:self action:@selector(updateFlowPayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [flowView setStrTitle:StringAppend(dicTemp[@"monthlyData"])];
        [flowView setTag:[dicTemp[@"id"] intValue]];
        
        [scrollViewFlow addSubview:flowView];
        [scrollViewFlow setContentSize:CGSizeMake(kScreen_width, CGRectGetMaxY(flowView.frame)+10)];

    }

}

#pragma mark - 支付
-(void)updateFlowPayAction:(WWFlowSelectButton *)sender{
    NSString * strDesc = [NSString stringWithFormat:@"您确认将本月流量升级为%@吗？",sender.strTitle];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"流量升级" message:strDesc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setTag:sender.tag];
    [alertView show];
}


-(void)buyOtherPackage:(UIButton *)sender{
    NSString * strDesc = [NSString stringWithFormat:@"您确认购买当前套餐吗？"];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"套餐购买" message:strDesc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setTag:sender.tag];
    [alertView show];
}

-(void)buyPackage:(WWFlowSelectButton *)sender{
    NSString * strDesc = [NSString stringWithFormat:@"您确认购买%@吗？",sender.strTitle];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"套餐购买" message:strDesc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setTag:sender.tag];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self loadPayFormationWithRatePlan:[NSString stringWithFormat:@"%ld",(long)alertView.tag]];
        
    }

}

//请求支付配置信息
-(void)loadPayFormationWithRatePlan:(NSString *)strRatePlan{
    if ([self isConnectionAvailable])
    {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view addSubview:hud];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
            hud.delegate = self;
            hud.labelText = @"正在查询,请稍后";
            FenceInfo *info=[[FenceInfo alloc] init];
            
            info.AccountID=[USER valueForKey:@"userName"];
            
          //  info.IMEI = @"35156502900041";
           info.IMEI=[USER valueForKey:@"IMEI"];
        
        NSString * strType;
        if (_rechargeType == RechargeTypeUpdatePackage) {
            strType = @"0";
        }
        else
        {
            strType = @"1";
        }
        
            
            [HttpEngine getPayConfigMsgRatePlan:strRatePlan operType:strType imeiNumber:info.IMEI and:^(NSDictionary *dic) {
                [hud hide:YES];
                
                // [hud hide:YES afterDelay:1.0];
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    
                    if ([StringAppend(dic[@"result"])  isEqualToString:@"1001"]) {
                        [self.view makeToast:@"查询失败!" duration:1.0 position:CSToastPositionCenter];
                        return ;
                    }
                    NSDictionary * dicPayConfig = dic[@"data"][@"alipayRequest"];
                    dicPayInformation = dicPayConfig;


                    
                    [self aliPayWithConfig:dicPayConfig];
                }else{
                    if([dic isKindOfClass:[NSString class]])
                    {
                        [self.view makeToast:(NSString*)dic duration:1.0 position:CSToastPositionCenter];
                    }
                    
                }
                
            }];
            
        }
}

#pragma mark - 支付宝初始化
-(void)aliPayWithConfig:(NSDictionary *)dicPayConfig{
    //获得支付必要信息
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = dicPayConfig[@"seller_id"];
    NSString *seller = dicPayConfig[@"seller_id"];
    NSString *privateKey =dicPayConfig[@"sign"];
    
    
//    NSString *partner =@"2016060700099410";
//    NSString *seller = @"2016060700099410";
//    NSString *privateKey =@"MIICWwIBAAKBgQDDFc+nc1ZmKecy/mJ30PoXvbWDR6hX4Dqg7cZia6JKNB1tsAslKeqQtD5XAuoOj4HdpOhRsfTLvW/XWgHpp0zJvjhr42wExPQHstrLT5cvq9/dXle05AOyPtl85MLkGgBGo8K/PkLZ8Z7KODe1DvsMyhtobxjTaS+8bFIL/PWxbwIDAQABAoGAHK/HYkM2kD1XLwtzJVVIgVc3Kr/NxGZHmMR+KJjVO34gWbHKYcOhJ3gptpfKHSwDF7mZI/I8If2QRaWJpHcidkIhdnTOil26DWPyZhTliBsx11Q8kQOCYEHTbiVDz9Adfk2EN5pGclZBjOTuRbeZUOnuLIGXE7lxuJ4LiO7yVKECQQDx4E9GK8NOThYOfXB5a/tWAk5crpxo9+nGyIrTBPAMQdxwF020cfdy7Q32REqtc8tBHQ0SJHxImB3nBv+C/bzxAkEAznoLmyA9vMRNxFqJy14MY9b07nvgZsRibiOzYrzV57jg3T4FpdA7HwoOwOWqI3/2uTtj1+ev+JMaBjShCaXUXwJAK4JrIDdNGa/oPdEIw37OJmmhyQBL+IHoFq8Kce0odTv/uFYozzXVCmJkKZGdUVhMDrl4GXRguvpKHr3ehqS4MQJAFksPHbypbcw0KVMtNYv+AnmfEHDHldD2X7XzFGIXJmHLxZeAvJpzB7LqTOF/MT4LwYwsB4+4bDpVwP3FtWj2OQJAXpCUFJ7jYSlq3NhP7lk+CJ5WtaWjvqYRguAv/1Tq0Sa9x2E54f7kqmhv1Fq2H3cbESgUHXBKwub7j9ux0JKLFQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = StringAppend(dicPayConfig[@"trade_no"]); //订单ID（由商家自行制定）
    order.productName =dicPayConfig[@"subject"]; //商品标题
    order.productDescription = dicPayConfig[@"body"]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[dicPayConfig[@"total_amount"] floatValue]]; //商品价格
    
    //   order.amount = @"0.01";
    order.notifyURL =  dicPayConfig[@"notify_url"]; //回调URL
    
    order.service = dicPayConfig[@"service"];
    order.paymentType = @"1";
    order.inputCharset = dicPayConfig[@"charset"];
    order.itBPay = dicPayConfig[@"timeout_express"];
    order.showUrl = dicPayConfig[@"show_url"];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"NewsmyCorderPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSString * resultStatus = resultDic[@"resultStatus"];
            
            if ([resultStatus isEqualToString:@"9000"]) {
                NSLog(@"支付成功!");
                //先进入测试界面
                WWPayResultView * tempVC = [[WWPayResultView alloc]init];
                tempVC.strPrice = [NSString stringWithFormat:@"%.2f",[dicPayInformation[@"total_amount"] floatValue]];
                tempVC.strPayType = @"支付宝";
                tempVC.strSimCard = [USER valueForKey:@"IMEI"];
                tempVC.strPackageType = dicPayInformation[@"body"];
                
                [self.navigationController pushViewController:tempVC animated:YES];
            }
            else
            {
                NSLog(@"支付失败!");

             //   [payResultView showWithStatu:OrderPayResultFail];
            }
            
            NSLog(@"reslut = %@",resultDic);
        }];
    }
    
    
}


//获得数据
-(void)reloadData{
    if ([self isConnectionAvailable])
    {
        //根据不同的类型进行不同的操作
        //升级
        if (_rechargeType == RechargeTypeUpdatePackage) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view addSubview:hud];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
            hud.delegate = self;
            hud.labelText = @"正在查询,请稍后";
            FenceInfo *info=[[FenceInfo alloc] init];
            
            info.AccountID=[USER valueForKey:@"userName"];
            
           // info.IMEI = @"35156502900041";
           info.IMEI=[USER valueForKey:@"IMEI"];
            
            [HttpEngine getUpdatePackageListInfo:info and:^(NSDictionary *dic) {
                [hud hide:YES];

               // [hud hide:YES afterDelay:1.0];
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    dicServiceData = dic;
                    
                    if ([StringAppend(dic[@"result"])  isEqualToString:@"1001"]) {
                        [self.view makeToast:@"查询失败!" duration:1.0 position:CSToastPositionCenter];
                        return ;
                    }
                    
                    dicServiceData = dic[@"data"];
                    [self CreaterView];
                }else{
                    if([dic isKindOfClass:[NSString class]])
                    {
                        [self.view makeToast:(NSString*)dic duration:1.0 position:CSToastPositionCenter];
                    }
                    
                }
                
            }];

        }
        
        //购买套餐
        else if (_rechargeType == RechargeTypepurchasePackage){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view addSubview:hud];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
            hud.delegate = self;
            hud.labelText = @"正在查询,请稍后";
            FenceInfo *info=[[FenceInfo alloc] init];
            
            info.AccountID=[USER valueForKey:@"userName"];
            
            
           // info.IMEI = @"35156502900041";

           info.IMEI=[USER valueForKey:@"IMEI"];
            
            [HttpEngine getpurchasePackageListInfo:info and:^(NSDictionary *dic) {
                [hud hide:YES];

                //[hud hide:YES afterDelay:1.0];
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    if ([StringAppend(dic[@"result"])  isEqualToString:@"1001"]) {
                        [self.view makeToast:@"查询失败!" duration:1.0 position:CSToastPositionCenter];
                        return ;
                    }
                    
                    dicServiceData = dic[@"data"];
                    
                    if ([StringAppend(dicServiceData[@"canOrder"]) isEqualToString:@"1"]) {
                        boolCanOrder = YES;
                    }
                    [self CreaterView];
                    
                }else{
                    if([dic isKindOfClass:[NSString class]])
                    {
                        [self.view makeToast:(NSString*)dic duration:1.0 position:CSToastPositionCenter];
                    }
                    
                }
                
            }];
        }
        
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

@end
