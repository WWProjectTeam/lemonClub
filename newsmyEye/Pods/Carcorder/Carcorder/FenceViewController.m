//
//  FenceViewController.m
//  Carcorder
//
//  Created by YF on 16/1/19.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "FenceViewController.h"
#import "CustomFenceTableViewCell.h"
#import "HttpEngine.h"
#import "FenceInfo.h"
#import "FenceMapViewController.h"
#import "Reachability.h"

@interface FenceViewController ()
{
    NSMutableArray *fenceInfoArr;
}
@end

@implementation FenceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    
    BOOL isConnection=[self isConnectionAvailable];
    
    if (isConnection)
    {
        QueryTimeInfo *info=[[QueryTimeInfo alloc] init];
        
        info.accountID=[USER valueForKey:@"userName"];
        
        info.IMEI=[USER valueForKey:@"IMEI"];
        
        [HttpEngine queryDevicefenceList:info and:^(NSMutableArray *array) {
            
            fenceInfoArr=[NSMutableArray arrayWithArray:array];
            
            [_table reloadData];
            
        }];
    }
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"电子围栏";
     
    UIBarButtonItem *backBtnItem=[[UIBarButtonItem alloc] init];
    
    backBtnItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backBtnItem;
    

    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tj"] style:UIBarButtonItemStylePlain target:self action:@selector(addFenceBtnClick)];
    
    self.navigationItem.rightBarButtonItem=rightBtnItem;
    
    _table.rowHeight=80;
    
    _table.bounces=NO;

    _table.showsVerticalScrollIndicator=NO;
    
    [_table registerNib:[UINib nibWithNibName:@"CustomFenceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(void)addFenceBtnClick
{
    FenceMapViewController *fenMap=[[FenceMapViewController alloc] init];
    [self.navigationController pushViewController:fenMap animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fenceInfoArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomFenceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FenceInfo *fenceInfo=fenceInfoArr[indexPath.row];
    
    cell.fenceAddressLab.numberOfLines=0;
    
    cell.fenceAddressLab.lineBreakMode= NSLineBreakByTruncatingTail;
    
    cell.fenceAddressLab.text=fenceInfo.Z_streetAddress;
    
    cell.fenceAddressLab.font=[UIFont systemFontOfSize:17.0];
    
    cell.fenceRadiusLab.text=[NSString stringWithFormat:@"%d米",fenceInfo.Z_radial];
    
    cell.fenceRadiusLab.font=[UIFont systemFontOfSize:16.0];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        if ([self isConnectionAvailable])
        {
            //先删--数据源也要相应删除一项
            FenceInfo *info=fenceInfoArr[indexPath.row];
            
            NSString *zid=info.Z_id;
            
            [fenceInfoArr removeObjectAtIndex:indexPath.row];
            
            NSString *userID=[USER objectForKey:@"userName"];
            
            NSString *imei=[USER objectForKey:@"IMEI"];
            
            NSString *urlStr = k_Device_URL;
            
            NSURL *url=[[NSURL alloc] initWithString:urlStr];
            
            NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            
            [request setHTTPMethod:@"POST"];
            
            NSString *parameterStr=[NSString stringWithFormat:@"account_id=%@&imei_number=%@&z_id=%@&command=d_del_z",userID,imei,zid];
            
            NSData *data=[parameterStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:data];
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];
    
    //设置收藏按钮
    /*
     UITableViewRowAction *collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
     
     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收藏" message:@"收藏成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
     
     [alertView show];
     
     }];
     
     collectRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     */
    
    //设置置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [fenceInfoArr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        
    }];
    
    topRowAction.backgroundColor = [UIColor colorWithRed:91/255.0 green:158/255.0 blue:237/255.0 alpha:1.0];
    
    return @[deleteRowAction,topRowAction];
}

//以下方法是单独定义删除按钮,并实现删除(删除数据源,数据库,cell)功能的操作,可与上面定义多个操作按钮二者根据实际需要任选其一使用
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}

/*
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([self isConnectionAvailable])
        {
            //先删--数据源也要相应删除一项
            FenceInfo *info=fenceInfoArr[indexPath.row];
            
            NSString *zid=info.Z_id;
            
            [fenceInfoArr removeObjectAtIndex:indexPath.row];
            
            NSString *userID=[USER objectForKey:@"userName"];
            
            NSString *imei=[USER objectForKey:@"IMEI"];
            
            NSString *urlStr = k_Device_URL;
            
            NSURL *url=[[NSURL alloc] initWithString:urlStr];
            
            NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            
            [request setHTTPMethod:@"POST"];
            
            NSString *parameterStr=[NSString stringWithFormat:@"account_id=%@&imei_number=%@&z_id=%@&command=d_del_z",userID,imei,zid];
            
            NSData *data=[parameterStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:data];
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            
            //NSData *receivedData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            //NSString *str=[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
            
            //NSLog(@"str===============%@",str);
 
            //NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
            
            //NSString *result=[[dic valueForKey:@"flag"] stringValue];
 
             //if ([result isEqualToString:@"1"])
             //{
                 //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"电子围栏删除成功" delegate:nil
                 //cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 
                 //[alert show];
             //}
             //else
             //{
                 //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"电子围栏删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 
                 //[alert show];
             //}
             
            //后删--单元格
            //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
*/


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
