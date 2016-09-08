//
//  TrackViewController.m
//  Carcorder
//
//  Created by YF on 16/1/13.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "TrackViewController.h"
#import "LandViewController.h"
#import "CarPathViewController.h"
#import "CustomTrackCell.h"
#import "HttpEngine.h"
#import "AccountInfo.h"
#import "QueryTimeInfo.h"
#import "DataResultInfo.h"
#import "DeviceListInfo.h"
#import "EventDataInfo.h"
#import "CarPathViewController.h"
#import "Reachability.h"
#import "UIListViewCell.h"
#import "UIListView.h"

//屏幕尺寸 ScreenRect
#define ScreenRect [UIScreen mainScreen].applicationFrame
#define ScreenRectHeight [UIScreen mainScreen].applicationFrame.size.height
#define ScreenRectWidth [UIScreen mainScreen].applicationFrame.size.width

//track event interval 30 minutes 30 * 60
#define TRACK_INTERVAL 1800

#define PROPAGEDATACOUNT 7

@interface TrackViewController ()<UIListViewDelegate, UIListViewDataSource>
{
    UIButton *tempButton;
    
    HZQDatePickerView *_pikerView;
    
    BOOL mark[2];
    
    QueryTimeInfo *timeInfo;
    
    NSMutableDictionary *tracks;
    
    NSArray * dateOfTracks;
    
    NSInteger indexRow;
}

@property (nonatomic, retain) UIListView *listView;

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation TrackViewController

#pragma mark -
#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _pageCount = 0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    
    UIListViewCell *cell= (UIListViewCell*)[_listView cellForRowAtIndex:0];
    if (tempButton==nil)
    {
        cell.textButton.backgroundColor=[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0];
        tempButton=cell.textButton;
        [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"我的足迹";
    
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=leftBtnItem;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(queryClick)];

    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    _table.rowHeight=50;

    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _table.showsVerticalScrollIndicator=NO;
    
    [_table registerNib:[UINib nibWithNibName:@"CustomTrackCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    
    _listView = [[UIListView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width+40, kButtonViewFrame)];
    _listView.backgroundColor = [UIColor whiteColor];
    [_listView setShowsVerticalScrollIndicator:NO];
    [_listView setShowHorizontalScrollIndicator:NO];
    _listView.listViewDelegate = self;
    _listView.dataSource = self;
    [self.buttonView addSubview:_listView];
    self.pageCount = 1;
    [_listView reloadData];
    
    
    timeInfo=[[QueryTimeInfo alloc] init];
    
    timeInfo.startDate=[[self getCustomDateWithHour:[NSDate date] and:0 and:0 and:0] timeIntervalSince1970];
    
    timeInfo.endDate=[[self getCustomDateWithHour:[NSDate date] and:23 and:59 and:59] timeIntervalSince1970];
    
    dateOfTracks=[NSMutableArray new];
    
    
    NSDate *currentDate=[NSDate date];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *nowDateStr=[formatter stringFromDate:currentDate];
    [USER setObject: [NSString stringWithFormat:@"%d",timeInfo.startDate] forKey:@"timeStart"];

    self.startLabel.text=nowDateStr;
    
    self.endLabel.text=nowDateStr;
    
    self.endTimeBtn.enabled=NO;

    self.endLabel.textColor=[UIColor lightGrayColor];
    
    
    AccountInfo *accountInfo=[[AccountInfo alloc] init];
    
    accountInfo.accountID=[USER valueForKey:@"userName"];
    
    accountInfo.psw=[USER valueForKey:@"pswName"];
    
    accountInfo.deviceID=[USER valueForKey:@"device"];
    
    
    BOOL isConnection=[self isConnectionAvailable];
    
    if (isConnection)
    {
        NSLog(@"view did load");
        [self requestTracksData:accountInfo];
    }
}

//获取当天时间段
- (NSDate *)getCustomDateWithHour:(NSDate*) currentDate and:(NSInteger)hour and:(NSInteger)minute and:(NSInteger)second
{
    //获取当前时间
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | kCFCalendarUnitSecond;
   
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    [resultComps setSecond:second];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate * result = [resultCalendar dateFromComponents:resultComps];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: result];
    return [result  dateByAddingTimeInterval: interval];
    
//    return [resultCalendar dateFromComponents:resultComps];
}

-(void)requestTracksData:(AccountInfo *)accountInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:hud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
    hud.delegate = self;
    hud.labelText = @"正在查询,请稍后";
   
    NSLog(@"query tracks , start time : %d, stop time : %d", timeInfo.startDate, timeInfo.endDate);
    [HttpEngine queryDeviceTrail:accountInfo time:timeInfo and:^(NSDictionary *responseDic) {
     
        [hud hide:YES afterDelay:1.0];
        
        NSDictionary *jsonDic=responseDic;
    
        // TODO : check response result ...
        DataResultInfo *resultInfo=[DataResultInfo queryDeviceTrailWithDic:jsonDic];
        
        DeviceListInfo *deviceInfo=[DeviceListInfo deviceListWithDic:resultInfo.DeviceListArr[0]];
        
        NSMutableArray *eventListArr=deviceInfo.EventDataArr;
        
        // begin modified by zhangyibo on 20160118 for calculate track ...
        
        //所有的轨迹,存在字典中
        tracks = [[NSMutableDictionary alloc] init];
        
        for (int i=0; i<eventListArr.count; i++)
        {
            //轨迹点
            EventDataInfo *eventInfo=[EventDataInfo eventDataWithDic:eventListArr[i]];
            
            //是用将"/"去掉,用""代替"/"
            //NSString *eventDate = [eventInfo.Timestamp_date stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
            NSString *eventDate = eventInfo.Timestamp_date;
            
            //每天内的轨迹
            NSMutableArray *tracksOfDate = [tracks objectForKey:eventDate];
            
            if (tracksOfDate == nil)
            {
                tracksOfDate = [NSMutableArray array];
                
                [tracks setObject:tracksOfDate forKey:eventDate];
            }
            
            //每段轨迹
            NSMutableArray *track = [tracksOfDate lastObject];
            
            if (track == nil)
            {
                track = [NSMutableArray  array];
                
                [tracksOfDate addObject:track];
            }
            
            EventDataInfo *lastEvent = [track lastObject];
            
            if (lastEvent == nil)
            {
                [track addObject:eventInfo];
            }
            else
            {
                if (eventInfo.Timestamp - lastEvent.Timestamp < TRACK_INTERVAL)
                {
                    [track addObject:eventInfo];
                    
                }
                else
                {
                    track = [NSMutableArray array];
                    
                    [track addObject:eventInfo];
                    
                    [tracksOfDate addObject:track];
                }
            }
        }
        // end modified by zhangyibo on 20160118 for calculate track ...
        
        if (tracks.count > 0)
        {
            NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
            
            NSArray *sortedDes=[NSArray arrayWithObjects:descriptor,nil];
            
            dateOfTracks = [[tracks allKeys] sortedArrayUsingDescriptors:sortedDes];
        }
        else
        {
            dateOfTracks=[NSArray new];
            
            [self performSelector:@selector(sleep) withObject:nil afterDelay:1.0];
        }
        
        [_table reloadData];
    }];
}

-(void)sleep
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:hud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
    hud.delegate = self;
    hud.labelText = @"暂无轨迹";
    [hud hide:YES afterDelay:0.5];
}

- (IBAction)timeDate:(id)sender
{
    UIButton *button=(UIButton *)sender;
    
    switch (button.tag)
    {
        case 10:
        {
            [self setupDateView:DateTypeOfStart];
        }
            break;
        case 11:
        {
            //[self setupDateView:DateTypeOfEnd];
        }
            break;
            
        default:
            break;
    }
}

-(void)setupDateView:(DateType)type
{
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    
    _pikerView.frame = CGRectMake(0, 0, ScreenRectWidth, ScreenRectHeight + 20);
    
    [_pikerView setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.4]];

    _pikerView.delegate = self;
    
    _pikerView.type = type;
    
    if(type==DateTypeOfStart)
    {
           //NSDate *currentDate=[NSDate dateWithTimeIntervalSince1970:[[self getCustomDateWithHour:0 and:0 and:0] timeIntervalSince1970]];
           NSDate *currentDate=[NSDate date];
        
          [_pikerView.datePickerView setMaximumDate:currentDate];
    }
    
    if (type==DateTypeOfEnd)
    {
        NSString *dateStr=[USER valueForKey:@"timeStart"];

        int end=[dateStr intValue];
        
        NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:end];
        
        NSTimeInterval time=7*24*60*60;
        
        NSDate *intervelTime=[endDate dateByAddingTimeInterval:+time];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        [_pikerView.datePickerView setMinimumDate:endDate];
        
        [_pikerView.datePickerView setMaximumDate:intervelTime];
    }
    
     [self.view addSubview:_pikerView];
}

-(void)getSelectDate:(NSString *)pickerDate type:(DateType)type
{
    NSLog(@"%d ----- %@", type, pickerDate);
    
    switch (type)
    {
        case DateTypeOfStart:
        {
            timeInfo.startDate= [[self getCustomDateWithHour:[_pikerView.datePickerView date] and:0 and:0 and:0] timeIntervalSince1970];
            NSString *timeStartDate=[NSString stringWithFormat:@"%d",timeInfo.startDate];

            [USER setObject:timeStartDate forKey:@"timeStart"];
            
            [USER synchronize];
            
            self.startLabel.text=pickerDate;
            
            if (indexRow!=0)
            {
                NSLog(@"indexRow----->>>>> %ld",(long)indexRow);
                
                int end=[timeStartDate intValue];
                
                NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:end];
                
                NSTimeInterval time=indexRow*24*60*60;
                
                NSDate *intervelTime=[endDate dateByAddingTimeInterval:+time];
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-dd"];
                
                self.endLabel.text=[formatter stringFromDate:intervelTime];
                
                timeInfo.endDate=[intervelTime timeIntervalSince1970];
            }
            else
            {
                self.endLabel.text=pickerDate;
                
                //timeInfo.endDate=[[_pikerView.datePickerView date] timeIntervalSince1970];
            	timeInfo.endDate= [[self getCustomDateWithHour:[_pikerView.datePickerView date] and:23 and:59 and:59] timeIntervalSince1970];
            }
        }
            break;
            
        case DateTypeOfEnd:
        {
            timeInfo.endDate=[[_pikerView.datePickerView date] timeIntervalSince1970] + 24 * 60 * 60 -1;
            
            //[self.endTimeBtn setTitle:pickerDate forState:UIControlStateNormal];

            self.endLabel.text=pickerDate;
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

-(void)queryClick
{
    NSLog(@"query click");
    
    AccountInfo *accountInfo=[[AccountInfo alloc] init];

    accountInfo.accountID=[USER valueForKey:@"userName"];
    
    accountInfo.psw=[USER valueForKey:@"pswName"];
    
    accountInfo.deviceID=[USER valueForKey:@"device"];
    
    BOOL isConnection=[self isConnectionAvailable];
    
    if (isConnection)
    {
        [self requestTracksData:accountInfo];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"dateOfTracks.count====%lu",(unsigned long)dateOfTracks.count);
    
    return dateOfTracks.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *infoDate=[dateOfTracks objectAtIndex:section];
    
    NSMutableArray *tracksOfDate=[tracks objectForKey:infoDate];
    
    if (mark[section]==YES)
    {
        return tracksOfDate.count;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _table.frame.size.width, _table.frame.size.height)];

    footerView.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] init];
    
    headerView.frame=CGRectMake(0, 0, _table.frame.size.width, _table.frame.size.height);

    headerView.backgroundColor=[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0];
    
    UIImageView *arrowImg=[[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20, 15)];
    
    arrowImg.image=[[UIImage imageNamed:@"箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [headerView addSubview:arrowImg];
    
    if (mark[section]==YES)
    {
        arrowImg.transform=CGAffineTransformMakeRotation(M_PI_2);
    }
    else
    {
        arrowImg.transform=CGAffineTransformIdentity;
    }
    
    UILabel *dayTitleLab=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, headerView.frame.size.width-70, 45)];

    NSString *dateStr=[dateOfTracks[section] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    dayTitleLab.text = dateStr;
    
    dayTitleLab.textColor=[UIColor whiteColor];
    
    dayTitleLab.font=[UIFont boldSystemFontOfSize:18.0];
     
    [headerView addSubview:dayTitleLab];
    
    
    NSMutableArray *tracksOfDate=[tracks valueForKey:dateOfTracks[section]];
    
    UILabel *countLab=[[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-35, 5, 35, 35)];
    
    NSUInteger count=tracksOfDate.count;
    
    NSString *countStr=[NSString stringWithFormat:@"%lu",(unsigned long)count];
    
    countLab.text=countStr;
    
    countLab.textAlignment=NSTextAlignmentCenter;
    
    countLab.textColor=[UIColor whiteColor];
    
    countLab.font=[UIFont systemFontOfSize:15.0];
    
    [headerView addSubview:countLab];
    
    
    UIButton *headerBtn=[UIButton buttonWithType: UIButtonTypeCustom];
    
    headerBtn.frame=CGRectMake(0, 0, headerView.frame.size.width, 45);
    
    headerBtn.tag=section;
    
    [headerBtn addTarget:self action:@selector(sectionHeaderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:headerBtn];
    
    return headerView;
}

-(void)sectionHeaderBtnClick:(UIButton *)button
{
    mark[button.tag]=!mark[button.tag];
    
    NSMutableIndexSet *indexSet=[NSMutableIndexSet indexSet];
    
    [indexSet addIndex:button.tag];

    /*UITableViewRowAnimationFade
     UITableViewRowAnimationRight
     UITableViewRowAnimationLeft
     UITableViewRowAnimationTop
     UITableViewRowAnimationBottom
     UITableViewRowAnimationNone
     UITableViewRowAnimationMiddle
     UITableViewRowAnimationAutomatic
     */
    
    [_table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTrackCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *tracksOfDate=[tracks valueForKey:dateOfTracks[indexPath.section]];
    
    NSMutableArray *events=tracksOfDate[indexPath.row];
    
    EventDataInfo *firstEvent=[events firstObject];
    
    if (events.count>1)
    {
        EventDataInfo *lastEvent=[events lastObject];
        
        cell.tracksLab.text=[NSString stringWithFormat:@"%@ - %@",firstEvent.Timestamp_time,lastEvent.Timestamp_time];
    }
    else
    {
        cell.tracksLab.text=firstEvent.Timestamp_time;

    }
    
    cell.tracksLab.textColor=[UIColor darkGrayColor];
    
    cell.tracksLab.textAlignment=NSTextAlignmentCenter;
    
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.1]];

    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarPathViewController *carPathVC=[[CarPathViewController alloc] init];
    NSMutableArray *tracksOfDate=[tracks valueForKey:dateOfTracks[indexPath.section]];
    
    NSMutableArray *events=tracksOfDate[indexPath.row];
    carPathVC.eventData=events;
    
    [self.navigationController pushViewController:carPathVC animated:YES];
}

#pragma mark -
#pragma mark - UIListViewDelegate
- (UIListViewScrollDirection)scrollDirectonOfListView:(UIListView *)listView
{
    return UIListViewScrollDirectionHorizontal;
}

#pragma mark - scroll type
- (UIListViewScrollType)scrollTypeOfListView:(UIListView *)listView
{
    return UIListViewScrollTypeSwing;
}

//- (BOOL)isBlockingScrollForListView:(UIListView *)listView
//{
//    return YES;
//}
//
//- (BOOL)doesAlignByMostVisiblePartRowForListView:(UIListView *)listView
//{
//    return YES;
//}

- (BOOL)isPagingScrollForListView:(UIListView *)listView
{
    return YES;
}

#pragma mark - cell size
- (CGFloat)widthForRowInlistView:(UIListView *)listView
{
    return (kScreen_width+60)/7;
}

- (CGFloat)heightForRowInListView:(UIListView *)listView
{
    return kButtonViewFrame;
}

#pragma mark -
#pragma mark - UIListViewDataSource
- (NSInteger)numberOfRowsInListView:(UIListView *)listView
{
    return self.pageCount *PROPAGEDATACOUNT;
}

- (UIListViewCell *)listView:(UIListView *)listVIew cellForRowAtIndex:(NSInteger)index
{
    UIListViewCell *cell = [[UIListViewCell alloc] init];
    
    [cell.textButton setTitle:[NSString stringWithFormat:@"%li",(long)index+1] forState:UIControlStateNormal];

    return cell;
}

#pragma mark - select cell
- (void)listView:(UIListView *)listView didSelectRowAtIndex:(NSInteger)index
{
    NSLog(@"selected: %li", (long)index+1);
    
    UIListViewCell *cell= (UIListViewCell*)[listView cellForRowAtIndex:index];
    
    indexRow=index;
    
    if(tempButton!=nil)
    {
        tempButton.backgroundColor=[UIColor whiteColor];
        [tempButton setTitleColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    cell.textButton.backgroundColor=[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0];
    tempButton=cell.textButton;
    [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    

    NSString *dateStr=[USER valueForKey:@"timeStart"];
    
    int end=[dateStr intValue];
    
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:end];
    
    NSTimeInterval time=(index)*24*60*60;
    
    NSDate *intervelTime=[endDate dateByAddingTimeInterval:+time];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];

    self.endLabel.text=[formatter stringFromDate:intervelTime];
    
    timeInfo.endDate=[intervelTime timeIntervalSince1970]+ 24 * 60 * 60 -1;
    
}

- (void)listView:(UIListView *)listView didHiddenRowAtIndex:(NSInteger)index
{
    //NSLog(@"hidden: %li", (long)index);

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
