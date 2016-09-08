//
//  LocationPuchController.m
//  Carcorder
//位置推送
//  Created by L on 15/8/8.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "LocationPuchController.h"
#import "WGS84TOGCJ02.h"//坐标纠偏
#import "Message.h"
#import "UIView+Toast.h"
#import "URLHeader.h"

@interface LocationPuchController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}

@end

@implementation LocationPuchController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"位置推送";
    num22 = @"0";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    //double UU = _mapView.userLocation.coordinate.latitude;
    _mapView.userInteractionEnabled=YES;
    [_mapView setZoomLevel:16.1 animated:YES];
 
    //点击屏幕,添加大头针
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapMapViewClick:)];
    tapRecognizer.delegate = self;
    [_mapView addGestureRecognizer:tapRecognizer];
    //[self cloudPlaceAroundSearch];
    
    //Do any additional setup after loading the view.
    pointAnnotation = [[MAPointAnnotation alloc] init];

    //初始化检索对象
    //_search = [[AMapSearchAPI alloc] initWithSearchKey:@"faf096f4f5ff91bb136ea1bda2e92ccb" Delegate:self];
    _search = [[AMapSearchAPI alloc]  init];
    _search.delegate=self;

    AdderssView = [[UIView alloc] init];
    AdderssView.frame = CGRectMake(0, kScreen_height-70, kScreen_width, 70);
    //AdderssView.clipsToBounds=YES;
    //AdderssView.layer.cornerRadius=5.0;
    AdderssView.backgroundColor = [UIColor blackColor];
    AdderssView.alpha = 0.6;
    [_mapView addSubview:AdderssView];
    
    AddressLab = [[UILabel alloc] init];

    //右边发送地址按钮按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 35);
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)sendBtnClick:(UIButton *)btn
{
    NSString *Idstr = [USER objectForKey:@"Idstr"];
    NSString *userId = [USER objectForKey:@"userName"];
    //NSString *messageStr = mapAddressPush;
    NSString *timeHHStr = @"";
    NSString *imeiNum=[USER objectForKey:@"IMEI"];
    NSString *timeStr = [timeHHStr stringByAppendingFormat:@"{\"poi\":\"%@\",\"longtitude\":\"%@\",\"latitude\":\"%@\"}" ,mapAddressPush,jdStr22,wdStr22];
    //NSString *seeion =[USER objectForKey:@"session_id"];
//    NSString *dbStr = @"设备在线！";
//    NSString *isNO1 = [USER objectForKey:@"isON1"];
//    if ([dbStr isEqual:isNO1]) {
//    NSString *urlStr = [NSString stringWithFormat:@"%@device_id=%@&command=send_message&account_id=%@&message_type=32&message=%@&imei_number=%@",localhost2,Idstr,userId,timeStr,imeiNum];
    NSString *urlStr = [NSString stringWithFormat:@"%@?imei_number=%@&command=send_location&account_id=%@&message=%@",
                        k_SendMsg_URL,imeiNum,userId,timeStr];
    NSString *urlstring = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSLog(@"%@",url);
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSNumber *backVau = dic[@"result_code"];
    NSNumber *backVau = dic[@"result"];
    NSLog(@"result = %d", (int)backVau.integerValue);
    
    NSString *longStr = [backVau stringValue];
    NSString *vuaStr = @"0";
    if ([longStr isEqualToString:vuaStr] || true)
    {
        if (mapAddressPush != nil) {
            Message *mes=[[Message alloc]init];
            mes.content=mapAddressPush;
            mes.device=[USER valueForKey:@"device"];
            mes.point_or_text=1;
            NSDate *currentDate=[NSDate date];
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        
            [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            NSString *dateStr=[formatter stringFromDate:currentDate];
            mes.time=dateStr;
            SqlLiteHelp *sql=[[SqlLiteHelp alloc] init];
            [sql addMessage:mes];
        }
        
        //UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"位置推送成功!" delegate:self   cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[view show];
        [self.view makeToast:@"位置推送成功!" duration:1.0 position:nil];
        
        [self performSelector:@selector(delayPushBack) withObject:nil afterDelay:1.0f];
    }
    else
    {
        //UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"位置推送失败!" delegate:self   cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[view show];
        
        [self.view makeToast:@"位置推送失败!" duration:1.0 position:nil];
    }
//    }else{
        //UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"设备不在线,位置发送失败!" delegate:self   cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[view show];
        
//        [self.view makeToast:@"设备不在线,位置发送失败!" duration:1.0 position:nil];
//    }
}

-(void)delayPushBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    //NSString *wd = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
    //NSString *jd = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
    //[[NSUserDefaults standardUserDefaults] setObject:wd forKey:@"wdStr"];
    //[[NSUserDefaults standardUserDefaults] setObject:jd forKey:@"jdStr"];

    if(updatingLocation )
    {
        //取出当前位置的坐标
        NSString *num33 = @"0";
        if ([num22 isEqual:num33])
        {
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        pointAnnotation.coordinate = userLocation.coordinate;
        [_mapView addAnnotation:pointAnnotation];
            
        jdStr22 = [@(userLocation.coordinate.longitude) stringValue];
        wdStr22 =  [@(userLocation.coordinate.latitude) stringValue];
        
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        //regeoRequest.searchType = AMapSearchType_ReGeocode;
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        //regeoRequest.radius = 10000;
        regeoRequest.requireExtension = YES;
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeoRequest];
            num22 = @"1";
        }
    }
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *ReGeocode = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        
        mapAddressPush = response.regeocode.formattedAddress;
        //[[NSUserDefaults standardUserDefaults] setObject:mapAddressPush forKey:@"mapAddressPush"];
        [self.view addSubview:AdderssView];
        
        AddressLab.text = mapAddressPush;
        AddressLab.textColor = [UIColor whiteColor];
        AddressLab.numberOfLines = 0;
        AddressLab.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [AddressLab sizeThatFits:CGSizeMake(AddressLab.frame.size.width-20, MAXFLOAT)];
        AddressLab.frame =CGRectMake(10, (AdderssView.frame.size.height-size.height)/2, AdderssView.width-20, size.height);
        AddressLab.font = [UIFont systemFontOfSize:17.0];
        AddressLab.textAlignment=NSTextAlignmentCenter;
        [AdderssView addSubview:AddressLab];
        NSLog(@"ReGeo: %@", ReGeocode);
    }
}

-(void)TapMapViewClick:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    //{
    //    return;
    //}
    
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    //touchMapCoordinate = [WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(touchMapCoordinate.latitude,touchMapCoordinate.longitude)];
    pointAnnotation.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:pointAnnotation];
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    //regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    //[self creatAnnotion:touchMapCoordinate];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= NO;//设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;//设置标注动画显示，默认为NO
        annotationView.draggable = NO;//设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorGreen;
        return annotationView;
    }
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    //放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor clearColor];
        pre.strokeColor = [UIColor clearColor];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        [_mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
