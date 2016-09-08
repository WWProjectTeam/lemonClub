//
//  RegisterViewController.m
//  Carcorder
//
//  Created by YF on 15/12/24.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import "RegisterViewController.h"
#import "LandViewController.h"
#import "ServiceViewController.h"
#import "HttpEngine.h"
#import "AccountInfo.h"
#import "ParserInfo.h"
#import "UIView+Toast.h"
#import "DevListViewController.h"
#import "PhotoViewController.h"
#import "MyInfoViewController.h"

@interface RegisterViewController ()
{
    NSString *messageStr;
}
@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([self.accountTF.text isEqualToString:@""]||[self.confirmCodeTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""]||[self.certainPswTF.text isEqualToString:@""])
    {
        self.accountTF.text=[USER objectForKey:@"accountIDStr"];
        
        self.confirmCodeTF.text=[USER objectForKey:@"confirmCodeStr"];
        
        self.pswTF.text=[USER objectForKey:@"pswStr"];
        
        self.certainPswTF.text=[USER objectForKey:@"certainPswStr"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"账号注册";

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};

     
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_back-iOS7@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    self.proLabel=[[UILabel alloc] init];
    //分段控制label上字体颜色
    NSMutableAttributedString *labString=[[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意此《服务协议》"];
    NSRange range=[[labString string] rangeOfString:@"《服务协议》"];
    [labString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0] range:range];
    
    self.proLabel.attributedText=labString;
    CGSize size=[self.proLabel sizeThatFits:CGSizeMake(MAXFLOAT, 40)];
    self.proLabel.frame=CGRectMake((kScreen_width-size.width)/2, self.shareBtn.frame.origin.y+self.shareBtn.frame.size.height+20+25, size.width, size.height);
    self.proLabel.font=[UIFont systemFontOfSize:15.0];
    self.proLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.proLabel];
    
    
    self.serviceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.serviceBtn.frame=CGRectMake(self.proLabel.origin.x,self.proLabel.origin.y,self.proLabel.frame.size.width,self.proLabel.frame.size.height);
    [self.serviceBtn addTarget:self action:@selector(serviceProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.serviceBtn];
    self.accountTF.delegate=self;
    self.pswTF.delegate=self;
    self.confirmCodeTF.delegate=self;
    self.certainPswTF.delegate=self;
    isCertain=!isCertain;
}


-(void)backBtnClick
{
    LandViewController *landVC=[[LandViewController alloc] init];
    
    self.view.window.rootViewController=landVC;
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
        hud.minSize = CGSizeMake(100.0f, 30.0f);
        [hud hide:YES afterDelay:3.0];
        return NO;
    }
    
    return isExistenceNetwork;
}

#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==self.accountTF)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    if(textField==self.pswTF||textField==self.certainPswTF)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 15) {
            return NO;
        }
    }
    if(textField==self.confirmCodeTF)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }

    [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return YES;
}

-(void)textFieldEditChanged:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            [USER setObject:textField.text forKey:@"accountIDStr"];
            
            [USER synchronize];
        }
            break;
        case 2:
        {
            [USER setObject:textField.text forKey:@"confirmCodeStr"];
            
            [USER synchronize];
        }
            break;
        case 3:
        {
            [USER setObject:textField.text forKey:@"pswStr"];
            
            [USER synchronize];
        }
            break;
        case 4:
        {
            [USER setObject:textField.text forKey:@"certainPswStr"];
            
            [USER synchronize];
        }
            break;
            
        default:
            break;
    }
}

-(void)animationbegin:(UIView *)view
{
    /** 放大缩小 */
    
    //设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    //动画选项设定
    animation.duration = 0.1; //动画持续时间
    animation.repeatCount = -1; //重复次数
    animation.autoreverses = YES; //动画结束时执行逆动画
    
    //缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; //开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; //结束时的倍率
    
    //添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

#pragma mark 获取验证码
-(IBAction)getCode:(id)sender
{
    /*
     [self.getCodeBtn setBackgroundImage:[UIImage imageNamed:@"验证码"] forState:UIControlStateNormal];
     
     [self.getCodeBtn setBackgroundImage:[UIImage imageNamed:@"验证码_d"] forState:UIControlStateHighlighted];
     */
    
    [self animationbegin:sender];
    
    BOOL isConnection=[self isConnectionAvailable];
    
    if (isConnection)
    {
        if (![self.accountTF.text isEqualToString:@""])
        {
            
            if (self.accountTF.text.length>0&&self.accountTF.text.length<11)
            {
                [self.view makeToast:@"请输入正确手机号!" duration:1.0 position:CSToastPositionCenter];
            }
            else
            {
                BOOL isMatchTelNum=[self checkTelNumber:self.accountTF.text];
                
                NSLog(@"isMatch======%d",isMatchTelNum);
                
                if (isMatchTelNum)
                {
                    /*获取验证码倒计时*/
                    
                    //倒计时时间
                    __block int timeout=59;
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    
                    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    
                    //每秒执行
                    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
                    
                    dispatch_source_set_event_handler(_timer, ^{
                        
                        if(timeout<=0)
                        {
                            //倒计时结束,关闭
                            dispatch_source_cancel(_timer);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示,根据自己需求设置
                                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                                
                                self.getCodeBtn.userInteractionEnabled = YES;
                            });
                            
                        }
                        else
                        {
                            int seconds = timeout % 60;
                            
                            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                //设置界面的按钮显示,根据自己需求设置
                                //NSLog(@"____%@",strTime);
                                [UIView beginAnimations:nil context:nil];
                                
                                [UIView setAnimationDuration:1];
                                
                                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后继续",strTime] forState:UIControlStateNormal];
                                
                                [UIView commitAnimations];
                                
                                self.getCodeBtn.userInteractionEnabled = NO;
                            });
                            
                            timeout--;
                        }
                        
                    });
                    
                    dispatch_resume(_timer);
                    
                    AccountInfo *info=[[AccountInfo alloc] init];
                    
                    info.accountID=self.accountTF.text;
                    
                    info.command=@"phone_verify";
                    
                    [HttpEngine getCheckCode:info and:^(NSMutableArray *array) {
                        
                        ParserInfo *info=array[0];
                        
                        [USER setObject:info.Message forKey:@"confirmCode"];
                        
                        [USER synchronize];
                        
                        if([info.Flag intValue]==1)
                        {
                            [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
                        }else{
                            [self.view makeToast:info.Message duration:1.0 position:CSToastPositionCenter];
                            dispatch_source_cancel(_timer);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示,根据自己需求设置
                                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                                
                                self.getCodeBtn.userInteractionEnabled = YES;
                            });
                        }
                       
                        /*
                         NSLog(@"code=========== %@",info.Message);
                         
                         self.confirmCodeTF.text=info.Message;
                         
                         NSLog(@"++++++++=========== %@",self.confirmCodeTF.text);
                         */
                        
                    }];
                    
                }
                else
                {
                    [self.view makeToast:@"手机号是空号!" duration:1.0 position:CSToastPositionCenter];
                }
            }
        }
        else
        {
            /*
             UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号!" preferredStyle:UIAlertControllerStyleAlert];
             
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             
             }]];
             
             [self presentViewController:alert animated:YES completion:nil];
             */
            
            [self.view makeToast:@"请输入手机号!" duration:1.0 position:CSToastPositionCenter];
        }
    }
}

-(void)sleep
{
    [self.view makeToast:messageStr duration:1.0 position:CSToastPositionCenter];
    
    [self performSelector:@selector(backLancVCSleep) withObject:nil afterDelay:1.0];
    
}

-(void)backLancVCSleep
{
    if ([messageStr isEqualToString:@"创建账户成功！"])
    {
        [USER setObject:self.accountTF.text forKey:@"userName"];
        [USER setObject:self.pswTF.text forKey:@"pswName"];
        UITabBarController *tabBarVC=[[UITabBarController alloc] initWithNibName:@"TabbarViewController" bundle:nil];
        
        DevListViewController *deviceVC=[[DevListViewController alloc] init];
        
        UINavigationController *deviceNav=[[UINavigationController alloc] initWithRootViewController:deviceVC];
        
        PhotoViewController *photoVC=[[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
        
        UINavigationController *photoNav=[[UINavigationController alloc] initWithRootViewController:photoVC];
        
        MyInfoViewController *myInfoVC=[[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
        
        UINavigationController *myInfoNav=[[UINavigationController alloc] initWithRootViewController:myInfoVC];
        
        UITabBarItem *deviceItem=[[UITabBarItem alloc] initWithTitle:@"设备" image:[[UIImage imageNamed:@"设备-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"设备-绿"] ];
        
        deviceNav.tabBarItem=deviceItem;
        
        UITabBarItem *photoItem=[[UITabBarItem alloc] initWithTitle:@"相册" image:[[UIImage imageNamed:@"相册-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"相册-绿"]];
        
        photoNav.tabBarItem=photoItem;
        
        UITabBarItem *myInfoItem=[[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"我的-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"我的-绿"]];
        
        myInfoNav.tabBarItem=myInfoItem;
        
        
        tabBarVC.viewControllers=@[deviceNav,photoNav,myInfoNav];
        
        self.view.window.rootViewController=tabBarVC;
    }
}

#pragma mark 注册
- (IBAction)registerBtn:(id)sender
{
    [self animationbegin:sender];
    BOOL isConnection=[self isConnectionAvailable];
    if (isConnection)
    {
        if ([self.accountTF.text isEqualToString:@""]||[self.confirmCodeTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""]||[self.certainPswTF.text isEqualToString:@""])
           {
            
                [self.view makeToast:@"输入框不能为空!" duration:1.0 position:CSToastPositionCenter];
                            return;
            }
        
        else
        {
            if (![self checkTelNumber:self.accountTF.text])
            {
                [self.view makeToast:@"请输入正确手机号!" duration:1.0 position:CSToastPositionCenter];
            }
            else if (self.pswTF.text.length>=6&&self.certainPswTF.text.length>=6)
                        {
                            if ([self.pswTF.text isEqualToString:self.certainPswTF.text])
                            {
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                [self.view addSubview:hud];
                                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
                                hud.delegate = self;
                                hud.labelText = @"正在加载";
                                
                                AccountInfo *accountInfo=[[AccountInfo alloc] init];
                                
                                accountInfo.accountID=self.accountTF.text;
                                accountInfo.confirmCode=self.confirmCodeTF.text;
                               
                                accountInfo.psw=self.pswTF.text;
                                
                                accountInfo.confirmCode=self.confirmCodeTF.text;
                        
                                [HttpEngine registerAccount:accountInfo and:^(NSMutableArray *array) {
                                    
                                    [hud hide:YES afterDelay:1.0];
                                    
                                    ParserInfo *info=array[0];
                                    
                            
                                    messageStr=info.Message;
                                    
                                    [self performSelector:@selector(sleep) withObject:nil afterDelay:1.0];
                                    
                                    NSLog(@"registerMessage------->>>>>>%@",info.Message);
                                    
                                }];
                            }
                            else
                            {
                                
                                [self.view makeToast:@"两次密码输入不一致!" duration:1.0 position:CSToastPositionCenter];
                            }
                        }
                        else
                        {
                            [self.view makeToast:@"两次密码输入少于六位!" duration:1.0 position:CSToastPositionCenter];
                        }
                        
                    }
    }
    
}

#pragma mark 协议按钮
-(void)protocol:(id)sender
{
    /*
    [self.protocolBtn setBackgroundImage:[UIImage imageNamed:@"确认"] forState:UIControlStateNormal];
    
    [self.protocolBtn setBackgroundImage:[UIImage imageNamed:@"确认_s"] forState:UIControlStateHighlighted];
    */
    
    if (isCertain==YES)
    {
        [self.protocolBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
        
        [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
        
        isCertain=!isCertain;
    }
    else
    {
        [self animationbegin:sender];
        
        [self.protocolBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
        
        [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
        
        isCertain=!isCertain;
    }
}

#pragma mark 服务协议
- (void)serviceProtocol:(id)sender
{
    ServiceViewController *serviceVC=[[ServiceViewController alloc] init];
    
    [self.navigationController pushViewController:serviceVC animated:YES];
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
