//
//  AlarmViewController.m
//  Carcorder
//
//  Created by YF on 16/1/19.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmCell.h"

@interface AlarmViewController ()
{
    NSMutableArray *mesinfo;
    
    UIImageView *dialogImg;
    
    UILabel *alarmDateLab;
    
    NSInteger deleateTag;
}
@end

@implementation AlarmViewController
@synthesize strDeviceId = _strDeviceId;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    
    // mesinfo = [NSMutableArray new];
 
//    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleateClick)];
//    self.navigationItem.rightBarButtonItem=rightBtnItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"报警";
    NSString *userNameStr=[USER valueForKey:@"userName"];
    NSString *key=[NSString stringWithFormat:@"%@mesList",userNameStr];
    
    
    NSMutableArray * arrayTemp = [NSMutableArray arrayWithArray:[USER objectForKey:key]];
    
    mesinfo = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < arrayTemp.count; i++) {
        NSDictionary * dicTemp = arrayTemp[i];
        
        NSString *content=[dicTemp valueForKey:@"content"];
        
        NSDictionary *dicContent= [self dictionaryWithJsonString:content];
        
        NSString *device = [dicContent valueForKey:@"deviceId"];
    
        if ([device isEqualToString:self.strDeviceId]) {
            [mesinfo addObject:dicTemp];
        }
    }

    
    UIImageView *headerImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
    
    headerImg.image=[UIImage imageNamed:@"设备-n"];
    
    [self.headerView addSubview:headerImg];
    
    UILabel *devNameLab=[[UILabel alloc] initWithFrame:CGRectMake(55, 5, kScreen_width-55, 35)];
    
    devNameLab.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"device"];
    
    devNameLab.textColor=[UIColor darkGrayColor];
    
    devNameLab.font=[UIFont systemFontOfSize:18.0];
    
    [self.headerView addSubview:devNameLab];
    
    
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _table.bounces=NO;

    _table.showsVerticalScrollIndicator=YES;
    
    [_table registerClass:[AlarmCell class] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"mesinfo=====%lu",(unsigned long)mesinfo.count);

   return mesinfo.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _table.frame.size.width, 15)];
    
    header.backgroundColor=[UIColor clearColor];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _table.frame.size.width, 25)];
    
    footer.backgroundColor=[UIColor clearColor];
    
    return footer;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _table.frame.size.width, 45)];
    
    headerView.backgroundColor=[UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1.0];
    
    UIImageView *headerImg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
    
    headerImg.image=[UIImage imageNamed:@"设备-n"];
    
    [headerView addSubview:headerImg];
    
    UILabel *devNameLab=[[UILabel alloc] initWithFrame:CGRectMake(55, 5, kScreen_width-55, 35)];
    
    devNameLab.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"device"];
    
    devNameLab.textColor=[UIColor darkGrayColor];
    
    devNameLab.font=[UIFont systemFontOfSize:18.0];
    
    [headerView addSubview:devNameLab];
    
    return headerView;
}
*/
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return alarmDateLab.frame.size.height+dialogImg.frame.size.height+20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSArray * views= [cell.contentView subviews];
    for (NSInteger i=0; i<views.count; i++)
    {
        UIView *view=[views objectAtIndex:i];
        [view removeFromSuperview];
    }
    
    cell.contentView.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
     NSDictionary *apsDic=mesinfo[indexPath.row];
    
    NSLog(@"apsDic======%@",apsDic);
    NSString *contentStr=apsDic[@"content"];
    NSData *contentData=[contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *contentDic=[NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"contentDic=======%@",contentDic);
//    if ([contentDic[@"deviceId"] isEqualToString:[USER objectForKey:@"device"]])
//    {
        NSDictionary *infoDic=apsDic[@"extras"];
        NSString *timeStr=infoDic[@"time"];
        NSString *timeStr1=[timeStr stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
        NSString *timeStr2=[timeStr1 stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
        NSString *timeStr3=[timeStr2 stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@"日 "];
        NSString *timeStr4=[timeStr3 stringByReplacingCharactersInRange:NSMakeRange(17, 3) withString:@""];
    
        alarmDateLab=[[UILabel alloc] init];
        alarmDateLab.backgroundColor=[UIColor lightGrayColor];
        alarmDateLab.text=timeStr4;
        alarmDateLab.textAlignment=NSTextAlignmentCenter;
        alarmDateLab.textColor=[UIColor whiteColor];
        alarmDateLab.font=[UIFont systemFontOfSize:14.0];
        CGSize size0=[alarmDateLab sizeThatFits:CGSizeMake(MAXFLOAT, 25)];
        alarmDateLab.frame=CGRectMake((kScreen_width-size0.width)/2, 10, size0.width+10, 25);
        [cell.contentView addSubview:alarmDateLab];
        
        UILabel *alarmInfoLab=[[UILabel alloc] init];
        alarmInfoLab.font=[UIFont systemFontOfSize:16.0];
        int event=[contentDic[@"event"] intValue];
        NSString *streetAddress=contentDic[@"streetAddress"];
        if (event==101)
        {
            alarmInfoLab.text=@"车辆发生震动";
            NSLog(@"-----");
            
        }
        else if (event==102)
        {
            alarmInfoLab.text=[NSString stringWithFormat:@"进入电子围栏区域:%@",streetAddress];
            NSLog(@">>>>>");
        }
        else
        {
            alarmInfoLab.text=[NSString stringWithFormat:@"离开电子围栏区域:%@",streetAddress];
            NSLog(@"=====");
        }

        CGSize size=[alarmInfoLab.text boundingRectWithSize:CGSizeMake(kScreen_width-40, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
        
        dialogImg=[[UIImageView alloc] init];
        UIImage *img=[UIImage imageNamed:@"对话框-左"];
        UIImage *newImg=[img stretchableImageWithLeftCapWidth:22 topCapHeight:15];
        dialogImg.image=newImg;
        dialogImg.frame=CGRectMake(5, 45, size.width+30, size.height+15);
        //dialogImg.backgroundColor=[UIColor redColor];
        [cell.contentView addSubview:dialogImg];
        
        alarmInfoLab.frame=CGRectMake(18, 0, dialogImg.frame.size.width-30, dialogImg.frame.size.height);
        //alarmInfoLab.backgroundColor=[UIColor greenColor];
        alarmInfoLab.numberOfLines=3;
        alarmInfoLab.textAlignment=NSTextAlignmentCenter;
        [dialogImg addSubview:alarmInfoLab];
    
    
    
     UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    
     longPressGr.minimumPressDuration = 1.0;
    
     [alarmInfoLab addGestureRecognizer:longPressGr];
    
    dialogImg.userInteractionEnabled = YES;
    alarmInfoLab.userInteractionEnabled = YES;
     alarmInfoLab.tag = 100+indexPath.row;
    
//    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        UIAlertView * alertTemp = [[UIAlertView alloc]initWithTitle:@"" message:@"您要删除本条报警信息吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertTemp setTag:(sender.view.tag -100)];
        
        [alertTemp show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // 取消
        
    }if (buttonIndex == 1) {    // 确定
        [mesinfo removeObjectAtIndex:alertView.tag];
        NSString *userNameStr=[USER valueForKey:@"userName"];
        NSString *key=[NSString stringWithFormat:@"%@mesList",userNameStr];
        [USER setObject:mesinfo forKey:key];
        [_table reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    return dic;
}

@end
