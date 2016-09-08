//
//  FenceMapViewController.m
//  Carcorder
//
//  Created by EthanZhang on 16/1/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "FenceMapViewController.h"
#import "WGS84TOGCJ02.h"//坐标纠偏
#import <AMapSearchKit/AMapSearchKit.h>
#import "FenceInfoView.h"
#import "UIView+Toast.h"

@interface FenceMapViewController ()<AMapSearchDelegate,MAMapViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    NSString *address;
    NSString *radio;
    FenceInfoView *fenceInfoView;
    CLLocationCoordinate2D touchMapCoordinate;
    CGRect fenFrame;
}
@end

@implementation FenceMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"电子围栏位置选择";
    
    num22 = @"0";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    //地图跟着位置移动
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    //_mapView.userTrackingMode = MAUserTrackingModeFollow;
    //_mapView.pausesLocationUpdatesAutomatically = NO;
    //[_mapView showAnnotations:_mapView.overlays animated:YES];
    [self.view addSubview:_mapView];

    pointAnnotation = [[MAPointAnnotation alloc] init];
    radio = @"1000";
    num = [radio  doubleValue];
    if (num>0 && num<=3500)
    {
        [_mapView setZoomLevel:12.0 animated:NO];
    }
    if (num>3500 && num<6501)
    {
        [_mapView setZoomLevel:11.5 animated:NO];
    }
    if (num>6500 && num<10001)
    {
        [_mapView setZoomLevel:11 animated:NO];
    }
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc]  init];
    _search.delegate = self;
    
    UITapGestureRecognizer *TapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapMapClick:)];
    TapRecognizer.delegate = self;
    TapRecognizer.numberOfTapsRequired=1;
    TapRecognizer.numberOfTouchesRequired=1;
    [_mapView addGestureRecognizer:TapRecognizer];
    // Do any additional setup after loading the view.
    
    //右边确定电子围栏范围按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    //rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    circle = [[MACircle alloc]init];
    
    fenceInfoView=[FenceInfoView getInstance];
    NSLog(@"originnewself.view height:%f",self.view.bounds.size.height);
    fenceInfoView.frame=CGRectMake(0, CGRectGetHeight(self.view.bounds)-150, CGRectGetWidth(self.view.bounds), 150);
    fenFrame=fenceInfoView.frame;
    fenceInfoView.radio.delegate=self;
    fenceInfoView.alpha=0.7;
    [fenceInfoView.radio setText:radio];
    [fenceInfoView.address setText:address];
    [fenceInfoView.radioSlider addTarget:self action:@selector(sliderValueChanged:)  forControlEvents:UIControlEventValueChanged];
    fenceInfoView.radioSlider.continuous=YES;
    [self.view addSubview:fenceInfoView];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [fenceInfoView addGestureRecognizer:tap];
    
    // get center coordinate
//        CGPoint point = CGPointMake(_mapView.width / 2, _mapView.height / 2);
//        CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:point toCoordinateFromView:_mapView];
//        wdStr222 =[@(touchMapCoordinate.latitude) stringValue];
//        jdStr222 = [@(touchMapCoordinate.longitude) stringValue];
}

//- (void)view:(UIView *)view addGestureRecognizer:(NSInteger)type
//    delegate:(id <UIGestureRecognizerDelegate>)delegate
//{
//    UILongPressGestureRecognizer *recognizer1 = nil;
//    UILongPressGestureRecognizer *recognizer2 = nil;
//    UIPanGestureRecognizer *recognizer3 = nil;
//    UIPanGestureRecognizer *recognizer4 = nil;
//    UIPinchGestureRecognizer *recognizer5 = nil;
//    UIPinchGestureRecognizer *recognizer6 = nil;
//    UISwipeGestureRecognizer *recognizer7 = nil;
//    UISwipeGestureRecognizer *recognizer8 = nil;
//    UITapGestureRecognizer *recognizer9 = nil;
//    UITapGestureRecognizer *recognizer10 = nil;
//    SEL touchBegin =@selector(touchesBegan:withEvent:);
//    SEL touchEnd=@selector(touchesEnded:withEvent:);
//    
//            recognizer1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:touchBegin];
//            recognizer2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:touchEnd];
//    
//    
//            recognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:touchBegin];
//            recognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:touchEnd];
//    
//    
//            recognizer5 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:touchBegin];
//            recognizer6 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:touchEnd];
//
//            recognizer7 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:touchBegin];
//            recognizer8 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:touchEnd];
//    
//            recognizer9= [[UITapGestureRecognizer alloc] initWithTarget:self action:touchBegin];
//            recognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:touchEnd];
//
//   recognizer1.delegate = delegate;
//   recognizer1.numberOfTapsRequired=1;
//   recognizer1.numberOfTouchesRequired=1;
//   recognizer2.delegate = delegate;
//   recognizer2.numberOfTapsRequired=1;
//   recognizer2.numberOfTouchesRequired=1;
//   recognizer3.delegate = delegate;
//   recognizer4.delegate = delegate;
//   recognizer5.delegate = delegate;
//   recognizer6.delegate = delegate;
//   recognizer7.delegate = delegate;
//   recognizer7.numberOfTouchesRequired=1;
//   recognizer8.delegate = delegate;
//   recognizer8.numberOfTouchesRequired=1;
//   recognizer9.delegate = delegate;
//   recognizer9.numberOfTapsRequired=1;
//   recognizer9.numberOfTouchesRequired=1;
//   recognizer10.delegate = delegate;
//   recognizer10.numberOfTapsRequired=1;
//   recognizer10.numberOfTouchesRequired=1;
//
//   [view addGestureRecognizer:recognizer1];
//   [view addGestureRecognizer:recognizer2];
//   [view addGestureRecognizer:recognizer3];
//   [view addGestureRecognizer:recognizer4];
//   [view addGestureRecognizer:recognizer5];
//   [view addGestureRecognizer:recognizer6];
//   [view addGestureRecognizer:recognizer7];
//   [view addGestureRecognizer:recognizer8];
//   [view addGestureRecognizer:recognizer9];
//   [view addGestureRecognizer:recognizer10];
//}

-(void)touchAction:(id)gesture
{
    [fenceInfoView endEditing:YES];
}

//-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    [fenceInfoView setHidden:YES];
//    
//}
//-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [fenceInfoView setHidden:NO];
//}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //CGRect frame = textField.frame;
    NSLog(@"newself.view height:%f",self.view.bounds.size.height);
    NSLog(@"feninfoview-y:%f",fenceInfoView.frame.origin.y);
    int offset = fenceInfoView.frame.origin.y -216;//键盘高度216
    
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        fenceInfoView.frame = CGRectMake(0.0f, offset, CGRectGetWidth(self.view.bounds), 150);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length==4)
    {
        if([textField.text isEqualToString:@"1000"]&&[string isEqualToString:@"0"])
        {
            return YES;
        }
        else if([string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if(textField.text.length==5)
    {
        if([string isEqualToString:@""])
        {
            return YES;
        }
        return NO;
    }

    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    fenceInfoView.frame=fenFrame;
    int value=[textField.text intValue];
     [_mapView removeOverlays:_mapView.overlays];
    
    if (value>=1000)
    {
       fenceInfoView.radioSlider.value=value;
       circle = [MACircle circleWithCenterCoordinate:touchMapCoordinate radius:value];
    }
    else
    {
        //return;
        value=0;
        fenceInfoView.radioSlider.value=value;
        circle = [MACircle circleWithCenterCoordinate:touchMapCoordinate radius:value];
        [self.view makeToast:@"围栏半径错误，请输入1000--10000" duration:1.0 position:CSToastPositionCenter];
    }
    //在地图上添加圆
    [_mapView addOverlay:circle];
    
    num=value;
}

- (void)sliderValueChanged:(id)sender
{
    UISlider* control = (UISlider*)sender;
    if(control == fenceInfoView.radioSlider)
    {
        int value = control.value;
        [fenceInfoView.radio setText:[NSString stringWithFormat:@"%d",value+1000]];
        [_mapView removeOverlays:_mapView.overlays];
        circle = [MACircle circleWithCenterCoordinate:touchMapCoordinate radius:value+1000];
        //在地图上添加圆
        [_mapView addOverlay:circle];
        
        num=value+1000;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)TapMapClick:(UITapGestureRecognizer *)gestureRecognizer
{
    //清除之前建立的圆形标注
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    pointAnnotation.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:pointAnnotation];
    
    //构造圆
    circle = [MACircle circleWithCenterCoordinate:touchMapCoordinate radius:num];
    //在地图上添加圆
    [_mapView addOverlay:circle];
    
    wdStr222 =[@(touchMapCoordinate.latitude) stringValue];
    jdStr222 = [@(touchMapCoordinate.longitude) stringValue];
    
    NSInteger numone = num;
    if (numone>0 && numone <=3500)
    {
        //[_mapView setZoomLevel:12.0 animated:NO];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = touchMapCoordinate.latitude;
        //[addressDto.latitude doubleValue];
        coordinate.longitude = touchMapCoordinate.longitude;
        //[addressDto.longitude doubleValue];
        _mapView.centerCoordinate = coordinate;
        _mapView.region = MACoordinateRegionMakeWithDistance(coordinate,11500 ,11500);
    }
    else if (numone>3500 && numone <6501)
    {
        //[_mapView setZoomLevel:12.0 animated:NO];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = touchMapCoordinate.latitude;
        //[addressDto.latitude doubleValue];
        coordinate.longitude = touchMapCoordinate.longitude;
        //[addressDto.longitude doubleValue];
        _mapView.centerCoordinate = coordinate;
        _mapView.region = MACoordinateRegionMakeWithDistance(coordinate,13500 ,15000);
    }
    else if(numone>6500 && numone <10001)
    {
        //[_mapView setZoomLevel:11.0 animated:NO];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = touchMapCoordinate.latitude;
        //[addressDto.latitude doubleValue];
        coordinate.longitude = touchMapCoordinate.longitude;
        //[addressDto.longitude doubleValue];
        _mapView.centerCoordinate = coordinate;
        _mapView.region = MACoordinateRegionMakeWithDistance(coordinate,25000 ,25000);
    }
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    //regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch:regeoRequest];
}

- (void)sendBtnClick:(UIButton *)btn
{
    [fenceInfoView endEditing:YES];
    
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userName"];
    //NSString *userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    NSString *uqId = [defaults objectForKey:@"IMEI"];
    //NSString *uqId=[[NSUserDefaults standardUserDefaults] valueForKey:@"IMEI"];
    NSString *fenceAddress = fenceInfoView.address.text;
    
    NSString *radial =fenceInfoView.radio.text;
    
    NSString *wdStr = wdStr222;
    
    NSString *jdStr = jdStr222;
    
    NSString *zid = locationString;
    NSInteger numR = [radial intValue] ;
    
    if (numR<1000 || numR >10000)
    {
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"半径参数不能大于10000或小于1!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        //[alert show];
        
        [self.view makeToast:@"围栏半径错误，请输入1000--10000" duration:1.0 position:CSToastPositionCenter];
        
        return;
        
    }
    else
    {
        // 第一步,创建URL
        NSString *strurl = k_Device_URL;
        NSURL *url = [NSURL URLWithString:strurl];
        
        // 第二步,创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"]; // 设置请求方式为POST，默认为GET
        NSString *str = [NSString stringWithFormat:@"account_id=%@&z_id=%@&imei_number=%@&z_radial=%@&z_latitude=%@&z_longitude=%@&z_streetAddress=%@&command=z_create",userId,zid,uqId,radial,wdStr,jdStr,fenceAddress]; // 设置参数
        NSLog(@"--->>>%@  %@  %@  %@  %@  %@",userId,uqId,radial,wdStr,jdStr,fenceAddress);
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        // 第三步,连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"str1------======= %@",str1);
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
        NSString *result = [[dict valueForKey:@"flag"] stringValue];
        NSString *pd = @"1";
        if ([result isEqualToString:pd])
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:zid forKey:@"zid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            /*
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电子围栏添加成功!" delegate:nil cancelButtonTitle:@"确定"   otherButtonTitles:nil];
            [alert show];
            */
            
            [self.view makeToast:@"电子围栏添加成功!" duration:1.0 position:CSToastPositionCenter];
        }
        else
        {
            /*
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"电子围栏添加失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            */
             
            [self.view makeToast:@"不能添加重复的电子围栏!" duration:1.0 position:CSToastPositionCenter];
        }

    }

    [self performSelector:@selector(backSleep) withObject:nil afterDelay:1.0];
}

-(void)backSleep
{
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
        //CGSize titleSize = [mapAddress boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        [fenceInfoView.address setText:mapAddress];
        [fenceInfoView.address sizeToFit];
        NSLog(@"ReGeo: %@", ReGeocode);
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= NO;//设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;//设置标注动画显示，默认为NO
        annotationView.draggable = YES;//设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorGreen;
        return annotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 3.f;
        circleView.strokeColor = [UIColor colorWithRed:100/255.0 green:190/255.0 blue:160/255.0 alpha:1.0];
        circleView.fillColor = [UIColor colorWithRed:70/255.0 green:245/255.0 blue:250/255.0 alpha:0.7];
        //circleView.strokeColor = [UIColor colorWithRed:1.000 green:0.412 blue:0.389 alpha:1.000];
        //circleView.fillColor = [UIColor colorWithRed:0.984 green:0.988 blue:1.000 alpha:0.3];
        //circleView.lineDash = YES;
        //circleView.lineDashPattern = YES;
        
        return circleView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    //放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation )
    {
        //取出当前位置的坐标
        //NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        NSString *num33 = @"0";
        if ([num22 isEqual:num33])
        {
            double tempnum = [fenceInfoView.radio.text  doubleValue];
            //构造圆
            circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) radius:tempnum];
            touchMapCoordinate=CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) ;
            
            wdStr222 =[@(touchMapCoordinate.latitude) stringValue];
            jdStr222 = [@(touchMapCoordinate.longitude) stringValue];
            //在地图上添加圆
            [_mapView addOverlay:circle];
            
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
