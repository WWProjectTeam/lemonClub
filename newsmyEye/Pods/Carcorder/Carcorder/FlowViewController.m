//
//  FlowViewController.m
//  Carcorder
//
//  Created by YF on 16/1/19.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "FlowViewController.h"
#import "HttpEngine.h"
#import "FenceInfo.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "WWFlowRechargeViewController.h"
#import "WMPageController.h"

#define YDIMG(__name) [UIImage imageNamed:__name]

@interface FlowViewController ()
{
    NSDictionary *flowInfoDic;
}
@end

@implementation FlowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"流量";
    [self createrView];

    [self flowQuery:nil];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
}



-(void)createrView{
    [self.view setUserInteractionEnabled:YES];
    [self.tableView setUserInteractionEnabled:YES];
    
    UIButton * btnFlowReChange = [[UIButton alloc]initWithFrame:CGRectMake(10, 220, kScreen_width-20, 50)];
    [btnFlowReChange setTitle:@"流量充值" forState:UIControlStateNormal];
    [btnFlowReChange addTarget:self action:@selector(flowReChange) forControlEvents:UIControlEventTouchUpInside];
    
    [btnFlowReChange setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [btnFlowReChange setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:53/255.0 green:191/255.0 blue:174/255.0 alpha:1.0]] forState:UIControlStateHighlighted];

    [self.view addSubview:btnFlowReChange];
}


-(void)flowReChange{
    WMPageController *pageController = [self p_defaultController];

    
   // WWFlowRechargeViewController * tempVC = [[WWFlowRechargeViewController alloc]init];
    [self.navigationController pushViewController:pageController animated:YES];
}
- (WMPageController *)p_defaultController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    Class vcClass = [WWFlowRechargeViewController class];
    NSString * strTitle1 = @"流量升级";
    NSString * strTitle2 = @"套餐变更";
    
    [viewControllers addObject:vcClass];
    [viewControllers addObject:vcClass];

    [titles addObject:strTitle1];
    [titles addObject:strTitle2];

    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.menuItemWidth = kScreen_width/2;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.titleSizeSelected = 18;
    pageVC.titleSizeNormal = 18;
    pageVC.titleColorSelected = [UIColor colorWithRed:79/255.0 green:210/255.0 blue:194/255.0 alpha:1.0];
    pageVC.titleColorNormal = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0];
    pageVC.menuHeight = 50;
    pageVC.menuBGColor = [UIColor whiteColor];
    pageVC.titleFontName = @"Helvetica-Bold";
    return pageVC;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(BOOL)isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
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
            //NSLog(@"3G");
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


- (IBAction)flowQuery:(id)sender
{
    if ([self isConnectionAvailable])
    {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view addSubview:hud];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
            hud.delegate = self;
            hud.labelText = @"正在查询,请稍后";
            FenceInfo *info=[[FenceInfo alloc] init];
            
            info.AccountID=[USER valueForKey:@"userName"];
            
            info.IMEI=[USER valueForKey:@"IMEI"];
        
            [HttpEngine queryFlowInfo:info and:^(NSDictionary *dic) {
                
                [hud hide:YES afterDelay:1.0];
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    flowInfoDic=dic;
                    [self.tableView reloadData];
                }else{
                    if([dic isKindOfClass:[NSString class]])
                    {
                        [self.view makeToast:(NSString*)dic duration:1.0 position:CSToastPositionCenter];
                    }
                    
                }
                
            }];
    }
}

-(void)showAlert:(NSString *)timeMessage
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:timeMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:alert repeats:YES];
    
    [alert show];
}

-(void)timerMethod:(NSTimer *)timer
{
    UIAlertView *alert=(UIAlertView *)[timer userInfo];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    alert=NULL;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    }
    if(indexPath.row==0)
    {
        cell.textLabel.text = @"到期时间";
        cell.detailTextLabel.text = flowInfoDic[@"expirationDate"];
    }else if(indexPath.row==1)
    {
        cell.textLabel.text = @"总流量";
        NSString *totalFlow=[[flowInfoDic[@"totalTraffic"] componentsSeparatedByString:@"M"] firstObject];
        
        if (totalFlow.length>0)
        {
            float total=[totalFlow floatValue];
            
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fMB",total];
        }

    }else if(indexPath.row==2)
    {
        cell.textLabel.text = @"已使用流量";
        NSString *userFlow=[[flowInfoDic[@"trafficUsed"] componentsSeparatedByString:@"M"] firstObject];
        
                        if (userFlow.length>0)
                        {
                            float user=[userFlow floatValue];
        
                            cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fMB",user];
                        }

    }else{
         cell.textLabel.text = @"剩余流量";
        NSString *remainFlow=[[flowInfoDic[@"trafficRemaining"] componentsSeparatedByString:@"M"] firstObject];
                        if (remainFlow.length>0)
                        {
                            float remain=[remainFlow floatValue];
                             cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fMB",remain];
                        }
    }
      return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
