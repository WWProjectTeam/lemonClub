//
//  DevManagerController.m
//  Carcorder
//
//  Created by YF on 16/3/4.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "DevManagerController.h"
#import "DevBtnCollectionViewCell.h"
#import "TrackViewController.h"
#import "FenceViewController.h"
#import "AlarmViewController.h"
#import "InfoViewController.h"
#import "FlowViewController.h"
#import "SpecificationController.h"
#import "HttpEngine.h"
#import "FenceInfo.h"
#import "TimeVideoViewController.h"
#import "VideoPlayer.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "WWFlowDetialViewController.h"
#define VIDBTN_WIDTH 50

#define VIDBTN_HEIGHT 50

@interface DevManagerController ()

@end

@implementation DevManagerController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    
//    if (_collectionView!=nil)
//    {
//        [_collectionView reloadData];
//    }
    
    NSString *deviceName=[USER valueForKey:@"uniqId"];
    
    NSString *imgPath=[USER valueForKey:deviceName];
    
    if(imgPath!=nil)
    {
        [self.vidImgView setImage:[UIImage imageWithContentsOfFile:imgPath]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    NSString *titleStr=[USER valueForKey:@"device"];
    
    self.title=titleStr;
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] init];
    
    backBarItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backBarItem;
    
    
    self.vidImgView=[[UIImageView alloc] init];
    
    self.vidImgView.backgroundColor=[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
    
    self.vidImgView.userInteractionEnabled=YES;
    
    self.vidImgView.frame=CGRectMake(0, 64, kScreen_width, kScreen_width*9/16);
    
    [self.view addSubview:self.vidImgView];
    
    
    self.vidBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.vidBtn.frame=CGRectMake((self.vidImgView.frame.size.width-VIDBTN_WIDTH)/2, (self.vidImgView.frame.size.height-VIDBTN_HEIGHT)/2, VIDBTN_WIDTH, VIDBTN_HEIGHT);
    
    [self.vidBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    
    [self.vidBtn addTarget:self action:@selector(vidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.vidImgView addSubview:self.vidBtn];
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+self.vidImgView.frame.size.height, kScreen_width, kScreen_height-self.vidImgView.frame.size.height-64) collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    _collectionView.delegate=self;
    
    _collectionView.dataSource=self;
    
    //_collectionView.scrollEnabled=NO;
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[DevBtnCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

}

-(void)vidBtnClick
{
    TimeVideoViewController *carpach = [[TimeVideoViewController alloc]init];
    [self.navigationController pushViewController:carpach animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DevBtnCollectionViewCell *cell=(DevBtnCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backgroundColor=[UIColor whiteColor];
    
    NSArray *labNameArr=@[@"足迹",@"消息",@"电子围栏",@"报警",@"流量",@"说明书",@"解除绑定",@"",@""];
    
    cell.imgLab.text=labNameArr[indexPath.item];
    
    NSArray *imgArr=@[@"足迹-n",@"消息-n",@"电子围栏-n",@"报警-n",@"流量-n",@"说明书",@"接触绑定-n",@"",@""];
    
    /*每点击一次,改变背景颜色,上一个能够复原,但是不会自动取消*/
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.7];
    
    cell.imgView.image=[UIImage imageNamed:imgArr[indexPath.item]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item)
    {
        case 0:
        {
            TrackViewController *trackVC=[[TrackViewController alloc] init];
            
            [self.navigationController pushViewController:trackVC animated:YES];
            
            [_collectionView reloadData];
        }
            break;
        case 1:
        {
            InfoViewController *infoVC=[[InfoViewController alloc] init];
            
            [self.navigationController pushViewController:infoVC animated:YES];
            
            [_collectionView reloadData];
        }
            break;
        case 2:
        {
            FenceViewController *fenceVC=[[FenceViewController alloc] init];
            
            [self.navigationController pushViewController:fenceVC animated:YES];
            
            [_collectionView reloadData];
        }
            break;
        case 3:
        {
            AlarmViewController *alarmVC=[[AlarmViewController alloc] init];
            alarmVC.strDeviceId = self.title;
            [self.navigationController pushViewController:alarmVC animated:YES];
            
            [_collectionView reloadData];
        }
            break;
        case 4:
        {
            WWFlowDetialViewController * tempVC = [[WWFlowDetialViewController alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
            
            
//            FlowViewController *flowVC=[[FlowViewController alloc] init];
//            
//            [self.navigationController pushViewController:flowVC animated:YES];
            
            [_collectionView reloadData];
        }
            break;
        case 5:
        {
            SpecificationController *specificationVC=[[SpecificationController alloc] init];
            
            [self.navigationController pushViewController:specificationVC animated:YES];
            
            [_collectionView reloadData];
        }
            break;
        case 6:
        {
            NSString *cancelBtn=NSLocalizedString(@"取消", nil);
            
            NSString *otherBtn=NSLocalizedString(@"确定", nil);
            
            NSString *message=NSLocalizedString(@"你确定要解除绑定?", nil);
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            /*
             NSMutableAttributedString *messageStr=[[NSMutableAttributedString alloc] initWithString:message];
             
             [messageStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 9)];
             
             [alert setValue:messageStr forKey:@"attributedMessage"];
             */
            
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelBtn style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [_collectionView reloadData];
                
            }];
            
            UIAlertAction *removeAction=[UIAlertAction actionWithTitle:otherBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                if ([self isConnectionAvailable])
                {
                    QueryTimeInfo *timeInfo=[[QueryTimeInfo alloc] init];
                    
                    timeInfo.accountID=[USER valueForKey:@"userName"];
                    
                    timeInfo.IMEI=[USER valueForKey:@"IMEI"];
                    
                    [HttpEngine unblindDevice:timeInfo and:^(NSMutableArray *array) {
                        NSString *deviceName=[USER valueForKey:@"uniqId"];
                        
                        [USER setValue:nil forKey:deviceName];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                    
                }
                
                [_collectionView reloadData];
            }];
            
            [alert addAction:cancelAction];
            
            [alert addAction:removeAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [_collectionView reloadData];
        }
            break;
        case 7:
        {
            [_collectionView reloadData];

        }
            break;
            
        case 8:
        {
            [_collectionView reloadData];

        }
            break;
            
        default:
            break;
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

//设置元素的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_collectionView.frame.size.width-2)/3, (_collectionView.frame.size.height-2)/3);
}

//元素列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

//元素行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

//上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
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
