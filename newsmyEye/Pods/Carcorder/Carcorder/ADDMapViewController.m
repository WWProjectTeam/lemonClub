//
//  ADDMapViewController.m
//  Carcorder
//电子围栏地址选择
//  Created by L on 15/8/10.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "ADDMapViewController.h"
#import "WGS84TOGCJ02.h"//坐标纠偏
#import <AMapSearchKit/AMapSearchObj.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface ADDMapViewController ()<AMapSearchDelegate,MAMapViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}

@end

@implementation ADDMapViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子围栏位置选择";
    
    num22 = @"0";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    //
    [self.view addSubview:_mapView];
//    _mapView.pausesLocationUpdatesAutomatically = NO;
    
     pointAnnotation = [[MAPointAnnotation alloc] init];
    
//    _mapView.showsUserLocation = NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    NSString *redoo = @"1000";
    num = [redoo  doubleValue];
    if (num>0 && num<=3500) {
        [_mapView setZoomLevel:12.0 animated:NO];
    }
    if (num>3500 && num<6501) {
        [_mapView setZoomLevel:11.5 animated:NO];

    }if (num>6500 && num<10001) {
        [_mapView setZoomLevel:11 animated:NO];
    }
    //    [_mapView showAnnotations:_mapView.overlays animated:YES];
    
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    UITapGestureRecognizer *Lpress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressClick:)];
    Lpress.delegate = self;
    [_mapView addGestureRecognizer:Lpress];
    
    UIButton *LButton = [[UIButton alloc]init];
//    LButton.frame = CGRectMake(20, 40, 18, 18);
    LButton.frame = CGRectMake(0, 0, 19, 34);
//    [LButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [LButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [LButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:LButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    // Do any additional setup after loading the view.
    
    //右边确定电子围栏范围按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn.frame = CGRectMake(0, 0, 35, 35);
    
    [rightBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    circle = [[MACircle alloc]init];
    
    // get center coordinate
//    CGPoint point = CGPointMake(_mapView.width / 2, _mapView.height / 2);
//    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:point toCoordinateFromView:_mapView];
//    wdStr222 =[@(touchMapCoordinate.latitude) stringValue];
//    jdStr222 = [@(touchMapCoordinate.longitude) stringValue];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)LongPressClick:(UILongPressGestureRecognizer *)gestureRecognizer
{
//        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
//        {
//            return;
//        }
    //清除之前建立的圆形标注
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
//    touchMapCoordinate =  [WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(touchMapCoordinate.latitude,touchMapCoordinate.longitude)];
//    pointAnnotation.coordinate = touchMapCoordinate;
//    [_mapView addAnnotation:pointAnnotation];

    pointAnnotation.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:pointAnnotation];
    
    //构造圆
   circle = [MACircle circleWithCenterCoordinate:touchMapCoordinate radius:num];
    //在地图上添加圆
    [_mapView addOverlay: circle];
    
    wdStr222 =[@(touchMapCoordinate.latitude) stringValue];
    jdStr222 = [@(touchMapCoordinate.longitude) stringValue];
    
    NSInteger numone = num;
    if (numone>0 && numone <=3500) {
//        [_mapView setZoomLevel:12.0 animated:NO];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude =  touchMapCoordinate.latitude;//[addressDto.latitude doubleValue];
        coordinate.longitude =  touchMapCoordinate.longitude;//[addressDto.longitude doubleValue];
        _mapView.centerCoordinate = coordinate;
        _mapView.region = MACoordinateRegionMakeWithDistance(coordinate,11500 ,11500);
    }else if (numone>3500 && numone <6501) {
//        [_mapView setZoomLevel:12.0 animated:NO];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude =  touchMapCoordinate.latitude;//[addressDto.latitude doubleValue];
        coordinate.longitude =  touchMapCoordinate.longitude;//[addressDto.longitude doubleValue];
        _mapView.centerCoordinate = coordinate;
        _mapView.region = MACoordinateRegionMakeWithDistance(coordinate,13500 ,15000);
    }else if(numone>6500 && numone <10001) {
//        [_mapView setZoomLevel:11.0 animated:NO];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude =  touchMapCoordinate.latitude;//[addressDto.latitude doubleValue];
        coordinate.longitude =  touchMapCoordinate.longitude;//[addressDto.longitude doubleValue];
        _mapView.centerCoordinate = coordinate;
        _mapView.region = MACoordinateRegionMakeWithDistance(coordinate,25000 ,25000);
    }

    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    //    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

- (void)sendBtnClick:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] setValue:wdStr222 forKey:@"wdStr222"];
    [[NSUserDefaults standardUserDefaults] setValue:jdStr222 forKey:@"jdStr222"];
    [self.navigationController popViewControllerAnimated:YES];
}


//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *ReGeocode = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        
            NSString  *mapAddress = response.regeocode.formattedAddress;
        [[NSUserDefaults standardUserDefaults] setObject:mapAddress forKey:@"mapAddress"];
        NSLog(@"ReGeo: %@", ReGeocode);
    }
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
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
    
    
}





- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 5.f;
        circleView.strokeColor = [UIColor colorWithRed:1.000 green:0.412 blue:0.389 alpha:1.000];
        circleView.fillColor = [UIColor colorWithRed:0.984 green:0.988 blue:1.000 alpha:0.3];
        //        circleView.lineDash = YES;
//        circleView.lineDashPattern = YES;
        return circleView;
    }
    return nil;
}


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
//        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
//        pre.image = [UIImage imageNamed:@"location.png"];
//        pre.lineWidth = 3;
//        pre.lineDashPattern = @[@6, @3];
//        
//        [_mapView updateUserLocationRepresentation:pre];
        
        //view.calloutOffset = CGPointMake(0, 0);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
//    NSString *wd = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
//    NSString *jd = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
//    [[NSUserDefaults standardUserDefaults] setObject:wd forKey:@"wdStr"];
//    [[NSUserDefaults standardUserDefaults] setObject:jd forKey:@"jdStr"];
    
    if(updatingLocation )
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        NSString *num33 = @"0";
        if ([num22 isEqual:num33]) {
            NSString *redoo =@"1000";
            double num = [redoo  doubleValue];
            //构造圆
            circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) radius:num];
            
            //在地图上添加圆
            [_mapView addOverlay: circle];
            
            
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            
            regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            regeo.requireExtension = NO;
            [_search AMapReGoecodeSearch:regeo];
            
            num22 = @"1";

        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
       
}


- (void)didReceiveMemoryWarning {
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
