//
//  DevListViewController.m
//  Carcorder
//
//  Created by YF on 16/3/17.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "DevListViewController.h"
#import "DomeCell.h"
#import "WLBarcodeViewController.h"
#import "ScanCodeViewController.h"
#import "DevManagerController.h"
#import "HttpEngine.h"
#import "FenceInfo.h"
#import "Reachability.h"
#import "UIScanCodeViewController.h"

@interface DevListViewController ()

@end

@implementation DevListViewController
{
    UIImageView *add_device;
    NSMutableArray *deviceListArr;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    deviceListArr=nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:hud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
    hud.delegate = self;
    hud.labelText = @"正在加载";
    
    AccountInfo *accountInfo=[[AccountInfo alloc] init];
    
    accountInfo.accountID=[USER valueForKey:@"userName"];
    
    [HttpEngine accountQueryDeviceList:accountInfo and:^(NSMutableArray *array) {
        [hud hide:YES];
        deviceListArr=array;
        if(array.count>0)
        {
            [add_device removeFromSuperview];
            [self.tableView reloadData];
        }else{
            [self.tableView addSubview:add_device];
            [self.tableView reloadData];
        }
        
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.navigationItem.title=@"我的设备";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};
    
    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tj"] style:UIBarButtonItemStylePlain target:self action:@selector(barCodeBtnClick)];
    
    self.navigationItem.rightBarButtonItem=rightBtnItem;
    
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=leftBtnItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kScreen_width, kScreen_height-10) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.tableView.bounces=NO;
    self.tableView.showsVerticalScrollIndicator=YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    add_device=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_device"]];
    add_device.frame=CGRectMake(0, 0, kScreen_width, kScreen_width);
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

-(void)barCodeBtnClick
{
    UIScanCodeViewController *scanview = [[UIScanCodeViewController alloc]init];
    [self.navigationController pushViewController:scanview animated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return deviceListArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DomeCell getHeight] + 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //注意重用
    static NSString *cellId = @"cell";
    DomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[DomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    FenceInfo *info=deviceListArr[indexPath.section];
    cell.carImg.hidden=YES;
    cell.picImg.image=nil;
    cell.devNameLab.text=info.Device_id;
    
    NSString *imgPath=[USER valueForKey:info.Uniq_id];
    
    NSLog(@"device : %@ , img path : %@", info.Uniq_id, imgPath);
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if(imgPath!=nil && [fileManager fileExistsAtPath:imgPath]) 
    {
        [cell.picImg setImage:[UIImage imageWithContentsOfFile:imgPath]];
        
        cell.carImg.hidden=YES;
    } else {
        cell.carImg.hidden=NO;

    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FenceInfo *info=deviceListArr[indexPath.section];

    [USER setObject:info.Device_id  forKey:@"device"];
    [USER setObject:info.Uniq_id forKey:@"uniqId"];
    [USER setObject:info.IMEI forKey:@"IMEI"];
    [USER synchronize];
    
    DevManagerController *manageVC=[[DevManagerController alloc] init];
    
    [self.navigationController pushViewController:manageVC animated:YES];
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
