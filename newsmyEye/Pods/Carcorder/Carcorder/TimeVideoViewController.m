//
//  TimeVideoViewController.m
//  Carcorder
//
//  Created by L on 15/9/7.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "TimeVideoViewController.h"
#import "AAPLEAGLLayer.h"
#import "CamObj.h"
#import "UIView+Toast.h"
#import "UIViewExt.h"
#import <CoreMotion/CoreMotion.h>
#import "CamObj.h"
#import "FileViewController.h"
#import "HttpEngine.h"

#define VIEW_BACKGROUND ([UIColor colorWithRed:0.648 green:0.648 blue:0.648 alpha:1.000])
#define degreeTOradians(x) (M_PI * (x)/180)

@interface TimeVideoViewController ()
{
    AAPLEAGLLayer * m_glLayer;
    CamObj * m_CamObj;
    UIButton * m_TakePictureButton;
    UIButton * m_TakeRecordButton;
    UIButton * m_switchVideo;
    
    BOOL m_ViewAppear;
    BOOL m_TakenDeviceImage;
    BOOL m_P2PConnected;
    UIView * m_ConnectImageView;
    BOOL isRecording;
    BOOL connetcSuccess;
    UIImageView * connectImageView;
    UILabel *recordTime;
    NSTimer *recordTimer;
    NSInteger second;
    NSInteger minute;
    NSInteger hour;
    UIImageView *circlePoint;
    UIView * timeView;
    UIView* layout;
    
    BOOL recordControl;
}

@property (strong) CMMotionManager* motionManager;

@end

@implementation TimeVideoViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"view will appear!");
    [super viewWillAppear:YES];
    
    connetcSuccess = NO;
    self.tabBarController.tabBar.hidden=YES;
    isRecording=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backP2P)
                                                 name:@"ApplicationWillResignActive"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"view will disappear!");
    [super viewWillDisappear:YES];
   
//    [m_CamObj stopAll];
    [self backP2P];
    self.tabBarController.tabBar.hidden=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"ApplicationWillResignActive"
                                               object:nil];
    
    NSMutableArray  *array = [[NSMutableArray alloc] init];
    if (connetcSuccess == YES) {
            [array addObject:@"1"];
        
    }else if (connetcSuccess == NO){
        [array addObject:@"0"];
    }
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"connectSuccess.plist"];
    [array writeToFile:filePath atomically:YES];
}

/*
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    //不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    //root view
    self.title = [USER objectForKey:@"device"];
    self.view.backgroundColor =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.000];
    
    UIButton *LButton = [[UIButton alloc]init];
    LButton.frame = CGRectMake(0, 0, 10, 20);
    [LButton setImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [LButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] initWithCustomView:LButton];
    backBarItem.title=@"返回";
    self.navigationItem.backBarButtonItem=backBarItem;
    
    //video view
    Viedo = [[UIView alloc]init];
    //Viedo.frame = CGRectMake(10, 10, kScreen_width -20, (kScreen_width -20) * 9 / 16);
    Viedo.frame = [self getPlayVideoFrame];
    Viedo.backgroundColor = VIEW_BACKGROUND;
    [self.view addSubview:Viedo];
    //play video view
    m_glLayer = [[AAPLEAGLLayer alloc] initWithFrame:CGRectMake(0, 0, Viedo.bounds.size.width, Viedo.bounds.size.height)];
    [Viedo.layer addSublayer:m_glLayer];
    
    NSLog(@"player width is %f",Viedo.bounds.size.width);
    NSLog(@"player height is %f",Viedo.bounds.size.height);
    
    //record time view
    timeView=[[UILabel alloc] initWithFrame:CGRectMake(Viedo.bounds.size.width/2-55, Viedo.bounds.size.height+30, 110, 20)];
    
    recordTime=[[UILabel alloc] initWithFrame:CGRectMake(16, 0, 90, 20)];
    recordTime.textColor=[UIColor redColor];
    [recordTime setText:@"00:00:00"];
    
    circlePoint=[[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 12, 12)];
    [circlePoint.layer setCornerRadius:6];
    [circlePoint setBackgroundColor:[UIColor redColor]];
    [timeView addSubview:circlePoint];
    [timeView addSubview:recordTime];
    timeView.hidden=YES;
    [self.view addSubview:timeView];
    
    m_ConnectImageView=[[UIView alloc]init];
    m_ConnectImageView.frame=[self getPlayVideoFrame];
    m_ConnectImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btn5:)];
    [m_ConnectImageView addGestureRecognizer:singleTap];
    connectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"播放"]];
    connectImageView.frame = CGRectMake(m_ConnectImageView.bounds.size.width/2-25, m_ConnectImageView.bounds.size.height/2-25, 50, 50);
    [m_ConnectImageView addSubview:connectImageView];
    [self.view addSubview:m_ConnectImageView];
 
    //take picture button
    m_TakePictureButton= [UIButton buttonWithType:UIButtonTypeCustom];
    m_TakePictureButton.frame = [self getTakePictureButtonFrame];
    [m_TakePictureButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    m_TakePictureButton.enabled = NO;
    [self.view addSubview:m_TakePictureButton];
    
    m_TakeRecordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    m_TakeRecordButton.frame=[self getRecordVideoButtonFrame];
    [m_TakeRecordButton addTarget:self action:@selector(takeRecord:) forControlEvents:UIControlEventTouchUpInside];
    m_TakeRecordButton.enabled = NO;
    [self.view addSubview:m_TakeRecordButton];
    
    [self shuping];
 
    //[self showWaitDialog];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directionOfRotation1) name:UIDeviceOrientationDidChangeNotification object:nil];
    //myTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(btn5:) userInfo:nil repeats:NO];
}
*/

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicaitonDidBecomeActive");
    [_motionManager startDeviceMotionUpdates];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    [_motionManager stopDeviceMotionUpdates];
}

- (UIDeviceOrientation)realDeviceOrientation
{
    CMDeviceMotion *deviceMotion = _motionManager.deviceMotion;
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0)
            return UIDeviceOrientationPortraitUpsideDown;
        else
            return UIDeviceOrientationPortrait;
    }
    else
    {
        if (x >= 0)
            return UIDeviceOrientationLandscapeRight;
        else
            return UIDeviceOrientationLandscapeLeft;
    }
}

-(void)directionOfRotation1
{
    if([UIDevice currentDevice].orientation != UIDeviceOrientationUnknown)
    {
        [self directionOfRotation];
    }
}

-(void)hideStatusNavigationBar
{
    NSLog(@"hide status navigation bar");
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    });
}

-(void)showStatusNavigationBar
{
    NSLog(@"show status navigation bar");
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    });
}

-(void)directionOfRotation
{
    [myTimer invalidate];
    
    NSLog(@"directionOfRotation!");
    // UIDeviceOrientationUnknown
    // UIDeviceOrientationPortrait
    // Device oriented vertically, home button on the bottom
    // UIDeviceOrientationPortraitUpsideDow
    // Device oriented vertically, home button on the top
    // UIDeviceOrientationLandscapeLeft
    // Device oriented horizontally, home button on the right
    // UIDeviceOrientationLandscapeRight
    // Device oriented horizontally, home button on the left
    // UIDeviceOrientationFaceUp
    // Device oriented flat, face up
    // UIDeviceOrientationFaceDown
    // Device oriented flat, face down
    if (!m_ViewAppear)
        
        return;
    
    if (!m_P2PConnected)
        return;
    
    self.view.backgroundColor = [UIColor whiteColor];
    //单击tap触发的事件
    tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    Viedo.backgroundColor = VIEW_BACKGROUND;
    Viedo.frame = [self getPlayVideoFrame];
    m_ConnectImageView.frame=Viedo.frame;
    
    connectImageView.frame = CGRectMake(m_ConnectImageView.bounds.size.width/2-25, m_ConnectImageView.bounds.size.height/2-25, 50, 50);
    m_glLayer.frame=CGRectMake(0, 0, Viedo.bounds.size.width, Viedo.bounds.size.height);
    m_TakePictureButton.frame = [self getTakePictureButtonFrame];
    m_TakeRecordButton.frame=[self getRecordVideoButtonFrame];
    m_switchVideo.frame = [self getSwitchVideoButtonFrame];
    switch ([[UIDevice currentDevice]orientation])
    {
        case UIDeviceOrientationPortrait:
        {
            [self shuping];
            NSLog(@"屏幕竖屏，HOME键在下");
            [self showStatusNavigationBar];
            m_TakePictureButton.hidden = NO;
            m_TakeRecordButton.hidden=NO;
            m_switchVideo.hidden = NO;
            self.view.autoresizingMask = UIViewAutoresizingNone;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreeTOradians(0));
        }
        break;
            
        case UIDeviceOrientationPortraitUpsideDown:
        if (YES)
        {
            [self shuping];
            NSLog(@"屏幕竖屏，HOME键在上");
            [self showStatusNavigationBar];
            m_TakePictureButton.hidden = NO;
            m_TakeRecordButton.hidden=NO;
            m_switchVideo.hidden = NO;

            self.view.autoresizingMask = UIViewAutoresizingNone;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreeTOradians(180));
        }
        break;
            
        case UIDeviceOrientationLandscapeRight:
        {
            [self hengping];
            NSLog(@"屏幕横屏，HOME键在左");
            [self hideStatusNavigationBar];
            m_TakePictureButton.hidden = YES;
            m_TakeRecordButton.hidden=YES;
            m_switchVideo.hidden = YES;

            myTimer3 = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(btn6:) userInfo:nil repeats:NO];
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollViewClick:)];
            //单击tap触发的事件
            [self.view addGestureRecognizer:tap];
            [self dismissDialog];

            self.view.autoresizingMask = UIViewAutoresizingNone;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreeTOradians(-90));
        }
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        {
            NSLog(@"屏幕横屏，HOME键在右");
            [self hideStatusNavigationBar];
            [self hengping];
            m_TakePictureButton.hidden = YES;
            m_TakeRecordButton.hidden=YES;
            m_switchVideo.hidden = YES;

            myTimer3 = [NSTimer scheduledTimerWithTimeInterval:6.0     target:self selector:@selector(btn6:) userInfo:nil repeats:NO];
            [self dismissDialog];
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollViewClick:)];
            //单击tap触发的事件
            [self.view addGestureRecognizer:tap];
            self.view.autoresizingMask = UIViewAutoresizingNone;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreeTOradians(+90));
        }
        break;
        default:
        //NSLog(@"orientation : %ld",[[UIDevice currentDevice]orientation]);
            [self shuping];
            NSLog(@"屏幕竖屏，HOME键在下");
            [self showStatusNavigationBar];
            m_TakePictureButton.hidden = NO;
            m_TakeRecordButton.hidden=NO;
            m_switchVideo.hidden = NO;

            self.view.autoresizingMask = UIViewAutoresizingNone;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreeTOradians(0));
            break;
    }
}

-(void)hengping
{
    timeView.frame=CGRectMake(Viedo.bounds.size.width/2-55, Viedo.frame.origin.y+10, 110, 20);
    [m_TakePictureButton setBackgroundImage:[UIImage imageNamed:@"拍照-绿-竖版"] forState:UIControlStateNormal];
    [m_TakePictureButton setBackgroundImage:[UIImage imageNamed:@"拍照-灰-竖版"] forState:UIControlStateHighlighted];
    
    [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄影-绿-竖版"] forState:UIControlStateNormal];
    [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄影-灰-竖版"] forState:UIControlStateHighlighted];
    if(isRecording)
    {
        [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"video_recording"] forState:UIControlStateNormal];
    }
    _waitDialog.frame = CGRectMake(0, 0, kScreen_height, kScreen_width);
    layout.center = CGPointMake(_waitDialog.bounds.size.width/2, _waitDialog.bounds.size.height/2);
}

-(void)shuping
{
    timeView.frame=CGRectMake(Viedo.bounds.size.width/2-55, Viedo.frame.origin.y+10, 110, 20);
    [m_TakePictureButton setBackgroundImage:[UIImage imageNamed:@"拍照-白-横版"] forState:UIControlStateNormal];
    [m_TakePictureButton setBackgroundImage:[UIImage imageNamed:@"拍照-绿-横版"] forState:UIControlStateHighlighted];
    [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄像-白-横版"] forState:UIControlStateNormal];
    [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄像-绿-横版"] forState:UIControlStateHighlighted];
    if(isRecording)
    {
        [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"video_recording"] forState:UIControlStateNormal];
    }
    _waitDialog.frame = CGRectMake(0, 0, kScreen_width, kScreen_height);
    layout.center = CGPointMake(_waitDialog.bounds.size.width/2, _waitDialog.bounds.size.height/2);
}

- (void)tapScrollViewClick:(id)sender
{
    NSLog(@"tap scroll view click");
    m_TakePictureButton.hidden = NO;
    m_TakeRecordButton.hidden=NO;
    m_switchVideo.hidden = NO;

    myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
}

/*
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
    isRecording=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden=NO;
}
 */

-(void)scrollTimer
{
    NSLog(@"scrollTimer");
    m_TakePictureButton.hidden = YES;
    m_TakeRecordButton.hidden=YES;
    m_switchVideo.hidden = YES;

    [myTimer setFireDate:[NSDate distantFuture]];
}

-(void)showWaitDialog
{
    NSLog(@"showWaitDialog");
    if(!_waitDialog)
    {
        _waitDialog =[[UIView alloc] init];
    
        _waitDialog.frame = CGRectMake(0, 0, kScreen_width, kScreen_height);
       
        _waitDialog.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        layout = [[UIView alloc] init];
        layout.frame = CGRectMake(0, 0, 120, 120);
        layout.layer.cornerRadius = 5;
        layout.layer.masksToBounds = YES;
        layout.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        layout.center = CGPointMake(_waitDialog.bounds.size.width/2, _waitDialog.bounds.size.height/2);
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] init];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activity.center = CGPointMake(60, 60);
        [activity startAnimating];
        [layout addSubview:activity];
        
        UILabel* label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 75, 120, 20);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"正在初始化连接";
        [layout addSubview:label];

        [_waitDialog addSubview:layout];
    }
    
    [self.view addSubview:_waitDialog];
}

-(void)dismissDialog
{
    NSLog(@"dismissDialog");
    [self performSelectorOnMainThread:@selector(nativeDismissDialog)
                           withObject:self waitUntilDone:NO];
}

-(void)nativeDismissDialog
{
    if (_waitDialog.superview != nil)
        [_waitDialog removeFromSuperview];
}

-(CGRect)getPlayVideoFrame
{
    //NSLog(@"getPlayVideoFrame");
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            return CGRectMake(0,0, kScreen_height, kScreen_width);
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        default:
            return CGRectMake(0, 64, kScreen_width, (kScreen_width) * 3/4);
    }
}

-(CGRect)getTakePictureButtonFrame
{
    //NSLog(@"getTakePictureButtonFrame");
    int takePictureButtonSize = kScreen_width / 5;
    int takePictureMarginTop = kScreen_width / 5;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            return CGRectMake(kScreen_height - takePictureButtonSize,takePictureMarginTop, takePictureButtonSize, takePictureButtonSize);
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        default:
            return CGRectMake(takePictureButtonSize,
                              Viedo.bottom +takePictureMarginTop,
                              takePictureButtonSize,
                              takePictureButtonSize);
    }
}

-(CGRect)getRecordVideoButtonFrame
{
    //NSLog(@"getTakePictureButtonFrame");
    int recordVideoButtonSize = kScreen_width / 5;
    int recordVideoMarginTop = kScreen_width / 5;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            return CGRectMake(kScreen_height - recordVideoButtonSize, recordVideoMarginTop*3, recordVideoButtonSize, recordVideoButtonSize);
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        default:
            return CGRectMake(3*recordVideoButtonSize ,
                              Viedo.bottom +recordVideoMarginTop,
                              recordVideoButtonSize,
                              recordVideoButtonSize);
    }
}


-(CGRect)getSwitchVideoButtonFrame
{
    //NSLog(@"getTakePictureButtonFrame");
    int recordVideoButtonSize = kScreen_width / 5;
    int recordVideoMarginTop = kScreen_width / 5;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            return CGRectMake(kScreen_height - recordVideoButtonSize-50, recordVideoMarginTop*4, 40, 40);
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        default:
            return CGRectMake(1*recordVideoButtonSize ,
                              Viedo.bottom +recordVideoMarginTop,
                              0,
                              0);
    }
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    UIImage * imageTemp = [UIImage imageNamed:@"321321"];
    
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[self imageWithImage:imageTemp scaledToSize:CGSizeMake(32, 32)] style:UIBarButtonItemStyleDone target:self action:@selector(fullScreenAction)];
    //UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"321312" style:UIBarButtonItemStyleDone target:self action:@selector(fullScreenAction)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    
    // 不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    // root view
    self.title = [USER objectForKey:@"device"];
    self.view.backgroundColor =[UIColor colorWithRed:0.943 green:0.943 blue:0.954 alpha:1.000];
    
    UIButton *LButton = [[UIButton alloc]init];
    LButton.frame = CGRectMake(0, 0, 10, 20);
    [LButton setImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [LButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] initWithCustomView:LButton];
    backBarItem.title=@"返回";
    
    UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];

    self.navigationItem.backBarButtonItem=leftBarItem;
   
    // video view
    Viedo = [[UIView alloc]init];
    // Viedo.frame = CGRectMake(10, 10, kScreen_width -20, (kScreen_width -20) * 9 / 16);
    Viedo.frame = [self getPlayVideoFrame];
    Viedo.backgroundColor = VIEW_BACKGROUND;
    [self.view addSubview:Viedo];
    
    // play video view
    m_glLayer = [[AAPLEAGLLayer alloc]initWithFrame:CGRectMake(0, 0, Viedo.bounds.size.width, Viedo.bounds.size.height)];
    

    
    [Viedo.layer addSublayer:m_glLayer];
    
    NSLog(@"player width is %f",Viedo.bounds.size.width);
    NSLog(@"player height is %f",Viedo.bounds.size.height);
    
    //record time view
    timeView=[[UILabel alloc] initWithFrame:CGRectMake(Viedo.bounds.size.width/2-55, Viedo.frame.origin.y+10, 110, 20)];
    
    recordTime=[[UILabel alloc] initWithFrame:CGRectMake(16, 0, 90, 20)];
    recordTime.textColor=[UIColor redColor];
    [recordTime setText:@"00:00:00"];

    circlePoint=[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 12, 12)];
    [circlePoint.layer setCornerRadius:6];
    [circlePoint setBackgroundColor:[UIColor redColor]];
    
    [timeView addSubview:circlePoint];
    [timeView addSubview:recordTime];
    
    timeView.hidden=YES;
    
    [self.view addSubview:timeView];
    
    m_ConnectImageView=[[UIView alloc]init];
    m_ConnectImageView.frame=[self getPlayVideoFrame];
    m_ConnectImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btn5:)];
    
    
    

    
    [m_ConnectImageView addGestureRecognizer:singleTap];
    connectImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"播放"]];
    connectImageView.frame = CGRectMake(m_ConnectImageView.bounds.size.width/2-25, m_ConnectImageView.bounds.size.height/2-25, 50, 50);
    [m_ConnectImageView addSubview:connectImageView];
    [self.view addSubview:m_ConnectImageView];
    

    // take picture button
    m_TakePictureButton= [UIButton buttonWithType:UIButtonTypeCustom];
   
    m_TakePictureButton.frame = [self getTakePictureButtonFrame];
    [m_TakePictureButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    m_TakePictureButton.enabled = YES;
    [self.view addSubview:m_TakePictureButton];
    
    m_switchVideo = [[UIButton alloc]init];
    [m_switchVideo setBackgroundImage:[UIImage imageNamed:@"tab_video"] forState:UIControlStateNormal];
    [m_switchVideo setFrame:[self getSwitchVideoButtonFrame]];
    [m_switchVideo addTarget:self action:@selector(scaleVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_switchVideo];
    
    m_TakeRecordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    m_TakeRecordButton.frame=[self getRecordVideoButtonFrame];
    [m_TakeRecordButton addTarget:self action:@selector(takeRecord:) forControlEvents:UIControlEventTouchUpInside];
    m_TakeRecordButton.enabled = YES;
    [self.view addSubview:m_TakeRecordButton];
    
    [self shuping];

    /*
    [self showWaitDialog];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directionOfRotation1) name:UIDeviceOrientationDidChangeNotification object:nil];
    myTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(btn5:) userInfo:nil repeats:NO];
     */
    
}

-(void)fullScreenAction{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:(YES?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = YES?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

-(void)scaleVideo{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:(NO?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = NO?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

- (void)btn6:(UIButton *)sender
{
    [self dismissDialog];
    //FileViewController *we = [[FileViewController alloc]init];
    //[self.navigationController pushViewController:we animated:NO];
}

-(UIImage *)takePicture
{
    NSLog(@"takePicture");
    UIGraphicsBeginImageContextWithOptions(Viedo.bounds.size, YES, 0);
    [Viedo drawViewHierarchyInRect:Viedo.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)updateDeviceImage
{
    NSLog(@"update device image");
    UIImage * image = [self takePicture];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[USER objectForKey:@"uniqId"]]];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    [self setDeviceImg:filePath];
}

-(void)takePhone:(UIButton *)sender
{
    
    if (!recordControl) {
        
        [self.view makeToast:@"暂无视频流，请连接!" duration:2.0 position:nil];
        
        return;
        
    }
    NSLog(@"save image");
    UIImage * image = [self takePicture];

    /*
    NSString *nameSTTT = [USER objectForKey:@"uniqId"];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:nameSTTT];
   
 
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
   
    // 保存文件的名称
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", nameSTTT]];
    [self setDeviceImg:filePath];
    */
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储失败" message:@"请打开 设置-隐私-照片 来进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library addAssetsGroupAlbumWithName:@"纽眼" resultBlock:^(ALAssetsGroup *group) {
            
            //创建相簿成功
            
        } failureBlock:^(NSError *error) {
            
            //创建相簿失败
            
        }];
        [library saveImage:image toAlbum:@"纽眼" completion:^(NSURL *assetURL, NSError *error) {
            if (!error)
            {
                [self.view makeToast:@"拍照结束,并保存到相册!" duration:2.0 position:nil];
            }
        } failure:^(NSError *error) {
             [self.view makeToast:@"拍照出现错误!" duration:2.0 position:nil];
        }];
      
        //UIImageWriteToSavedPhotosAlbum(image, self, @selector(photo:didFinishSavingWithError:contextInfo:), nil);
        
    }
       //BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES];
}

-(void)setDeviceImg:(NSString *)imgPath
{
    NSLog(@"setDeviceImg");
    NSString * deviceName = [USER objectForKey:@"uniqId"];
    NSLog(@"deviceName----->>>> %@",deviceName);
    //[NSNotificationCenter defaultCenter]
    
    [USER setObject:imgPath forKey:deviceName];
}

-(void)record
{
    if (!recordControl) {
        
        [self.view makeToast:@"暂无视频流，请连接!" duration:2.0 position:nil];

        return;

    }
    
    if(isRecording)
    {
        [recordTimer invalidate];
        [recordTime setText:@"00:00:00"];
        timeView.hidden=YES;
        [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄像_s"] forState:UIControlStateNormal];
        recordTimer=nil;
        isRecording=NO;
        [m_CamObj stopRecordVideo];
        NSString  *filePath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/temp.mp4"];
        if(filePath!=nil)
        {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"存储失败"              message:@"请打开 设置-隐私-照片 来进行设置" delegate:nil cancelButtonTitle:@"确定"    otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library addAssetsGroupAlbumWithName:@"纽眼" resultBlock:^(ALAssetsGroup *group) {
                    
                    //创建相簿成功
                    
                } failureBlock:^(NSError *error) {
                   
                    //创建相簿失败
                    NSLog(error);
                    
                }];
                [library saveVideo:[NSURL fileURLWithPath:filePath] toAlbum:@"纽眼" completion:^(NSURL *assetURL, NSError *error) {
                    if (!error)
                    {
                        [self.view makeToast:@"录像结束,并保存到相册!" duration:2.0 position:nil];
                    }
                } failure:^(NSError *error) {
                    
                        [self.view makeToast:@"录像出现错误!" duration:2.0 position:nil];
                }];
            }
        }
    }
    else
    {
        isRecording=YES;
        hour=0;
        minute=0;
        second=0;
        timeView.hidden=NO;
        [self.view makeToast:@"一分钟之后停止录像!" duration:2.0 position:nil];
        recordTimer=[NSTimer scheduledTimerWithTimeInterval: 1.0f target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
        [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"video_recording"] forState:UIControlStateNormal];
   
        BOOL isSuccess = [m_CamObj startRecordVideo];
        
        if (!isSuccess) {
            [recordTimer invalidate];
            [recordTime setText:@"00:00:00"];
            timeView.hidden=YES;
            [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄像_s"] forState:UIControlStateNormal];
            recordTimer=nil;
            isRecording=NO;
            
            [self.view makeToast:@"录制失败，请重试!" duration:2.0 position:nil];

        }

    }
}


//UIInterfaceOrientation orientation=[UIApplication sharedApplication].statusBarOrientation;
//if(btn.tag==0)
//{
//    deviceDetailView.xline3.hidden=NO;
//    btn.tag=1;
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//    self.view.transform=CGAffineTransformIdentity;
//    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//    self.view.bounds = CGRectMake(0, 0, kScreen_height, kScreen_width);
//    deviceDetailView.frame=self.view.bounds;
//    [deviceDetailView screen];
//    [UIView commitAnimations];
//}else{
//    btn.tag=0;
//    deviceDetailView.xline3.hidden=YES;
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//（获取当前电池条动画改变的时间）
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//    self.view.transform=CGAffineTransformIdentity;
//    self.view.bounds = CGRectMake(0, 0, kScreen_width, kScreen_height);
//    deviceDetailView.frame=self.view.bounds;
//    [deviceDetailView exitScreen];
//    [UIView commitAnimations];
//}

- (void)takeRecord:(UIButton *)sender
{

    
    [self record];
}

- (void)timerAdvanced:(NSTimer *)timer
{
    if(circlePoint.hidden==YES)
    {
        circlePoint.hidden=NO;
    }else{
        circlePoint.hidden=YES;
    }
    NSString *sString,*mString,*hString;
    if(minute==59)
    {
        hour++;
        minute=0;
    }
    else if(second==59)
    {
        minute++;
        second=0;
        [self record];
    }
    else
    {
        second++;
    }
    if(second<10)
    {
        sString=[NSString stringWithFormat:@"0%ld",(long)second];
    }
    else
    {
        sString=[NSString stringWithFormat:@"%ld",(long)second];
    }
    if(minute<10)
    {
        mString=[NSString stringWithFormat:@"0%ld",(long)minute];
    }
    else
    {
        mString=[NSString stringWithFormat:@"%ld",(long)minute];
    }
    if(hour<10)
    {
        hString=[NSString stringWithFormat:@"0%ld",(long)hour];
    }
    else
    {
        hString=[NSString stringWithFormat:@"%ld",(long)hour];
    }
    
    [recordTime setText:[NSString stringWithFormat:@"%@:%@:%@",hString,mString,sString]];

}

- (void)btn3:(UIButton *)sender
{
    NSLog(@"3333");
    FileViewController *we = [[FileViewController alloc]init];
    [self.navigationController pushViewController:we animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"view did disappear!");
//    [self backP2P];
    m_ViewAppear = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"view did appear");
    
    [self showWaitDialog];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directionOfRotation1)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    myTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                target:self
                                              selector:@selector(btn5:)
                                              userInfo:nil
                                               repeats:NO];
    Viedo.backgroundColor = [UIColor colorWithRed:0.648
                                            green:0.648
                                             blue:0.648
                                            alpha:1.000];
    m_ViewAppear = YES;
}

- (void)btn5:(UIButton *)sender
{
    NSLog(@"btn5");
    
    [self showWaitDialog];
    
    m_ConnectImageView.hidden = YES;
    NSString * device = [USER valueForKey: @"device"];
    NSString * imei = [USER valueForKey:@"IMEI"];
    NSString * account = [USER valueForKey:@"userName"];
    
    [HttpEngine deviceOpenVideo:account device:device imei:imei];
    
    //以下两行将任务安排到一个后台线程执行。dispatch_get_global_queue会取得一个系统分配的后台任务队列。
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //计算PI值到100万位。和示例1的calcPI:完全一样，唯一区别是现在它在后台线程上执行了。
        // NSLog(@"555555");
        btn5.userInteractionEnabled = NO;
        //[bgImg removeFromSuperview];
        //[gu removeFromSuperview];
        
        // create cam object
        m_CamObj = [[CamObj alloc] init];
        
        m_CamObj.mP2PListener = self;
        
        // init P2P API
        [CamObj initAPI];
        
        //connect P2P需要传入唯一ID
        //m_CamObj.nsDID=@"NAB-000002-DCWXW";
        //NSString *qwd =[USER objectForKey:@"uniqId"];
        m_CamObj.nsDID=[USER objectForKey:@"uniqId"];
        
        [m_CamObj startConnect:10];
        
        //start video
        if (m_CamObj.isConnected)
        {
            NSLog(@"start play video ...");
            m_CamObj.mP2PListener = self;
            [m_CamObj startVideo];
        }
        
        //计算完成后，因为有UI操作，所以需要切换回主线程。一般原则：
        //1. UI操作必须在主线程上完成。2. 耗时的同步网络、同步IO、运算等操作不要在主线程上跑，以避免阻塞
        //dispatch_get_main_queue()会返回关联到主线程的那个任务队列。
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.view makeToast:@"连接成功!"];
            //if (onP2PConnectionError)
            //{
                //[self.view makeToast:@"连接成功!" duration:4 position:nil];
            //}
            if(backStr!=nil)
            {
                [self.view makeToast:backStr duration:3.0 position:nil];
            }
            
        });
    });
    
    //TimeVideoViewController *timevoide = [[TimeVideoViewController alloc]init];
    //[self.navigationController pushViewController:timevoide animated:NO];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(void)onPixelBufferAvaiable:(CVPixelBufferRef)buffer
{
    //NSLog(@"onPixelBufferAvaiable");
    if (m_glLayer >=0)
    {
        m_glLayer.pixelBuffer = buffer;//
        if (!m_TakenDeviceImage)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_TakePictureButton.enabled = YES;
                m_TakeRecordButton.enabled=YES;
                
                [self updateDeviceImage];
            });
            m_TakenDeviceImage = YES;
        }
    }
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated: NO];
//    [UIView beginAnimations:nil context:nil];
//
//    [UIView setAnimationDuration:0];
//    self.navigationController.view.transform = CGAffineTransformIdentity;
//    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI*(360)/180.0);
////    self.navigationController.view.bounds = CGRectMake(0, 0, kScreen_width, kScreen_height);
//    [UIView commitAnimations];
//}

#pragma 返回按钮
- (void)back:(UIButton*)button
{
    [self backP2P];
}

-(void)dealloc
{
    NSLog(@"dealloc ....");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backP2P
{
    NSLog(@"back ...");
    //[self.navigationController popViewControllerAnimated:YES];
    if(isRecording)
    {
        [self record];
    }
    [self dismissDialog];
    //myTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(backP2P) userInfo:nil repeats:NO];
    [self showStatusNavigationBar];
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (m_P2PConnected) {
//            [m_CamObj stopVideo];
            NSLog(@"stop all");
            [m_CamObj stopVideo];
        }
        NSLog(@"stop connection");
        [m_CamObj stopConnect];
        [CamObj deinitAPI];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(myTimer != nil) {
            [myTimer invalidate];
            myTimer = nil;
        }
        if (myTimer1 != nil) {
            [myTimer1 invalidate];
            myTimer1 = nil;
        }
        if (myTimer2 != nil) {
            [myTimer2 invalidate];
            myTimer2 = nil;
        }
        if (myTimer3 != nil) {
            [myTimer3 invalidate];
            myTimer3 = nil;
        }
    });
    
    //[self dismissModalViewControllerAnimated:YES];
}
/*
-(void)dealloc
{
    NSLog(@"dealloc ....");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backP2P
{
    NSLog(@"stop play video ...");
    [m_CamObj stopVideo];
    [CamObj deinitAPI];
}
 */

-(void)onP2PConnected
{
    [self dismissDialog];
    m_P2PConnected = YES;
    
    NSLog(@"onP2PConnected1!");
    backStr = @"连接成功!";
    dispatch_async(dispatch_get_main_queue(), ^() {
      
        recordControl = YES;
        m_ConnectImageView.hidden = YES;
        connetcSuccess = YES;
    });
}

-(void)onP2PConnectionError
{
  //  [m_TakePictureButton setBackgroundImage:[UIImage imageNamed:@"拍照_active_s"] forState:UIControlStateNormal];
  //  [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄像_active_s"] forState:UIControlStateNormal];
    
    
    recordControl = NO;

    NSLog(@"onP2PConnectionError");
    backStr = @"连接失败!";
    m_P2PConnected = NO;
    [self dismissDialog];
    
    if(isRecording)
    {
        [self record];
    }
    dispatch_async(dispatch_get_main_queue(), ^() {
        m_ConnectImageView.hidden = NO;
        timeView.hidden=YES;
        connetcSuccess = NO;
    });
    
    //[self back];
}
-(void)onP2PDisConnected
{
//    [m_TakePictureButton setBackgroundImage:[UIImage imageNamed:@"拍照_active_s"] forState:UIControlStateNormal];
//    
//    [m_TakeRecordButton setBackgroundImage:[UIImage imageNamed:@"摄像_active_s"] forState:UIControlStateNormal];
    
    NSLog(@"onP2PDisConnected");
    
    //[self updateDeviceImage];
    
    if(isRecording)
    {
        [self record];
    }
    
    recordControl = NO;

    backStr = @"连接断开,请返回!";
    [self dismissDialog];
    dispatch_async(dispatch_get_main_queue(), ^() {
        m_ConnectImageView.hidden = NO;
       
        timeView.hidden=YES;
        connetcSuccess = NO;
    });
    
    //[self back];
}

-(void)onP2PConnectting
{
    NSLog(@"onP2PConnectting");
    recordControl = NO;

    backStr = @"正在连接...";
    dispatch_async(dispatch_get_main_queue(), ^() {
        m_ConnectImageView.hidden = YES;
        connetcSuccess = NO;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
