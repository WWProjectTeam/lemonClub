//
//  CarPathViewController.m
//  Carcorder
//轨迹
//  Created by L on 15/8/8.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "CarPathViewController.h"
#import <MAMapKit/MAMapKit.h>
//GPS坐标纠偏地球坐标转换为火星坐标
#import "WGS84TOGCJ02.h"
#import "GMDCircleLoader.h"
#import "EventDataInfo.h"
#import "UIView+Toast.h"

@interface CarPathViewController ()
{
    MAMapView *_mapView;
    NSMutableArray *annotations;
}

@property (nonatomic, retain)NSMutableArray *remarkArray;

@end

@implementation CarPathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"车辆轨迹";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    _mapView.showsUserLocation=YES;
    _mapView.userTrackingMode=MAUserTrackingModeFollow ;
    //[_mapView showAnnotations:_mapView.annotations animated:YES];
    [self.view addSubview:_mapView];

    annotations=[NSMutableArray new];
    [self addPoint];
    // Do any additional setup after loading the view.
    
    //构造多边形数据对象
//    CLLocationCoordinate2D coordinates[4];
//    coordinates[0].latitude = 39.810892;
//    coordinates[0].longitude = 116.233413;
//    
//    coordinates[1].latitude = 39.816600;
//    coordinates[1].longitude = 116.331842;
//    
//    coordinates[2].latitude = 39.762187;
//    coordinates[2].longitude = 116.357932;
//    
//    coordinates[3].latitude = 39.733653;
//    coordinates[3].longitude = 116.278255;
//    
//    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
//    
//    //在地图上添加折线对象
//    [_mapView addOverlay: polygon];
}

//多边形数据
//- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
//{
//    if ([overlay isKindOfClass:[MAPolygon class]])
//    {
//        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
//        
//        polygonView.lineWidth = 5.f;
//        polygonView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
//        polygonView.fillColor = [UIColor colorWithRed:0.77 green:0.88 blue:0.94 alpha:0.8];
//        polygonView.lineJoin = kCGLineJoinMiter;//连接类型
//        
//        return polygonView;
//    }
//    return nil;
//}

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
        
        //annotationView.image = [UIImage imageNamed:@"111"];
        //annotationView.centerOffset = CGPointMake(0, 0);
        //return annotationView;
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        annotationView.canShowCallout= YES;//设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;//设置标注动画显示，默认为NO
        annotationView.draggable = NO;//设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorGreen;
        return annotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 4.f;
        polylineView.strokeColor = [UIColor colorWithRed:0.406 green:0.592 blue:1.000 alpha:1.000];
        polylineView.lineJoin = kCGLineJoinRound;//连接类型
        polylineView.lineCap = kCGLineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}

-(void)addPoint
{
    long num = self.eventData.count;
    long lineNum=0;
            CLLocationCoordinate2D commonPolylineCoords[num];
            if (self.eventData.count > 0)
            {
                EventDataInfo *last=[self.eventData objectAtIndex:self.eventData.count-1];
                EventDataInfo *first=[self.eventData objectAtIndex:0];
                NSInteger duration=(last.Timestamp-first.Timestamp)/10;
                NSInteger startTime=first.Timestamp;
                for  ( int i = 0; i < self.eventData.count; i ++)
                {
                    EventDataInfo *data=[self.eventData objectAtIndex:i];
                    if(data.Timestamp>=startTime||i==self.eventData.count-1)
                    {
                        double wd =data.GPSPoint_lat;
                        double jd =data.GPSPoint_lon;
                        GPSSTR =  [WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(wd, jd)];
                        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                        pointAnnotation.coordinate = GPSSTR;
                        pointAnnotation.title =data.Timestamp_date;
                        pointAnnotation.subtitle = data.Timestamp_time;
                        
                        [annotations addObject:pointAnnotation];
                        
                        commonPolylineCoords[lineNum].latitude = GPSSTR.latitude;
                        commonPolylineCoords[lineNum].longitude =GPSSTR.longitude;
                        startTime=startTime+duration;
                        lineNum++;
                    }
                    
                }
                [_mapView addAnnotations:annotations];
                commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:lineNum];
                [_mapView addOverlay: commonPolyline];
                [_mapView showAnnotations:annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
                
                //CLLocationCoordinate2D coordinate;
                //coordinate.latitude = GPSSTR.latitude;//[addressDto.latitude doubleValue];
                //coordinate.longitude =  GPSSTR.longitude;//[addressDto.longitude doubleValue];
                //_mapView.centerCoordinate = coordinate;
                //_mapView.region = MACoordinateRegionMakeWithDistance(coordinate,6000 ,6000);
            }
            else
            {
                NSLog(@"无轨迹数据");
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"该设备暂无轨迹数据！" delegate:self   cancelButtonTitle:@"确定"   otherButtonTitles:nil];
                [view show];
            }

/*
-(void)addPoint
{
    long num = self.eventData.count;

    CLLocationCoordinate2D commonPolylineCoords[num];
    if (self.eventData.count > 0) {
        for (int i = 0; i < self.eventData.count; i++) {
            EventDataInfo *data=[self.eventData objectAtIndex:i];
            double wd =data.GPSPoint_lat;
            double jd =data.GPSPoint_lon;
            GPSSTR = [WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(wd, jd)];
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = GPSSTR;
            pointAnnotation.title =[NSString stringWithFormat:@"%@ %@",data.Timestamp_date,data.Timestamp_time];;
            //pointAnnotation.subtitle = data.Timestamp_time;
            [annotations addObject:pointAnnotation];
            
            commonPolylineCoords[i].latitude = GPSSTR.latitude;
            commonPolylineCoords[i].longitude =GPSSTR.longitude;
        }
        
        [_mapView addAnnotations:annotations];
        commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:num];
        [_mapView addOverlay:commonPolyline];
        [_mapView showAnnotations:annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
        
        //CLLocationCoordinate2D coordinate;
        //coordinate.latitude = GPSSTR.latitude;//[addressDto.latitude doubleValue];
        //coordinate.longitude =  GPSSTR.longitude;//[addressDto.longitude doubleValue];
        //_mapView.centerCoordinate = coordinate;
        //_mapView.region = MACoordinateRegionMakeWithDistance(coordinate,6000 ,6000);
    }
    else
    {
        //NSLog(@"无轨迹数据");
        //UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"该设备暂无轨迹数据!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[view show];
        
        [self.view makeToast:@"该设备暂无轨迹数据!" duration:1.0 position:nil];
    }
     */
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
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
