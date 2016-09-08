//
//  LandViewController.m
//  Carcorder
//
//  Created by YF on 15/12/29.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import "LandViewController.h"
#import "RegisterViewController.h"
#import "FinderViewController.h"
#import "DevListViewController.h"
#import "PhotoViewController.h"
#import "MyInfoViewController.h"
#import "HttpEngine.h"
#import "AccountInfo.h"
#import "ParserInfo.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "JPUSHService.h"

@interface LandViewController ()
{
    BOOL isConnection;
}
@end

@implementation LandViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    if (self.accountTF.text!=nil)
//    {
//        if ([self.accountTF.text isEqualToString:[USER valueForKey:@"userName"]])
//        {
//            if ([self.pswTF.text isEqualToString:@""])
//            {
//                self.pswTF.text=[USER valueForKey:@"pswName"];
//                
//                self.secretEntryBtn.hidden=NO;
//                
//                self.pswTF.secureTextEntry=YES;
//                
//                [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
//            }
//        }
//    }
    
    [USER removeObjectForKey: @"accountIDStr"];
    [USER removeObjectForKey: @"confirmCodeStr"];
    [USER removeObjectForKey: @"pswStr"];
    [USER removeObjectForKey: @"certainPswStr"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
 
    CALayer *registerLayer=[self.registerBtn layer];
    
    registerLayer.borderWidth=0.7;
    
    registerLayer.borderColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
    
    CALayer *finderLayer=[self.finderBtn layer];
    
    finderLayer.borderWidth=0.7;
    
    finderLayer.borderColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
    
    //[self.pswImgBtn addTarget:self action:@selector(pswImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelBtn.hidden=YES;
    
    self.secretEntryBtn.hidden=YES;
    self.pswTF.secureTextEntry=YES;
    if (self.accountTF.text.length>0&&self.pswTF.text.length>0)
    {
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
    }

    NSString *userNameStr=[USER valueForKey:@"userName"];

    if (![userNameStr isEqualToString:@""])
    {
        self.accountTF.text=userNameStr;
        
        self.cancelBtn.hidden=NO;
    }
}

#pragma mark 软键盘挡住输入框--移动软键盘
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info=[note userInfo];
    
    CGSize keyboardSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _keyBoardHeight=keyboardSize.height;
    
    CGRect frame=self.pswTF.frame;
    
    int offset=frame.origin.y+self.pswTF.frame.size.height+self.pswLine.frame.size.height+5-(self.view.frame.size.height-_keyBoardHeight);
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    //将视图的y坐标向上移动offset个单位,以使下面腾出地方用于软键盘的显示
    if(offset>0)
    {
        self.view.frame=CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

#pragma mark 按下return键或者按回车键--keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTF resignFirstResponder];
    
    [self.pswTF resignFirstResponder];
    
    return YES;
}

#pragma mark 视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            [self viewAnimation];
        }
            break;
        case 2:
        {
            [self viewAnimation];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 封装的动画--视图恢复到初始位置
-(void)viewAnimation
{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark 记住密码
/*
-(void)pswImgBtnClick
{
    if (isPswHighLighted==NO)
    {
        [self.pswImgBtn setBackgroundImage:[UIImage imageNamed:@"输入密码"] forState:UIControlStateNormal];
        
        self.pswTF.text=[USER valueForKey:@"pswName"];

        self.secretEntryBtn.hidden=NO;
        
        if (![self.pswTF.text isEqualToString:@""]&&![self.accountTF.text isEqualToString:@""])
        {
            [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
            
            self.pswTF.secureTextEntry=YES;
        }
        else
        {
            [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
            
            if ([self.accountTF.text isEqualToString:@""])
            {
                self.pswTF.text=@"";
                
                self.secretEntryBtn.hidden=YES;
            }
        }
        
        isPswHighLighted=!isPswHighLighted;
    }
    else
    {
        [self.pswImgBtn setBackgroundImage:[UIImage imageNamed:@"输入密码"] forState:UIControlStateNormal];
        
        self.pswTF.text=@"";
        
        self.secretEntryBtn.hidden=YES;
        
        if ([self.accountTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""])
        {
            [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
        }
        
        isPswHighLighted=!isPswHighLighted;
    }
}
*/

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
    if(textField==self.pswTF)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 15) {
            return NO;
        }
    }
    
     [textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    if (![self.accountTF.text isEqualToString:@""]&&![self.pswTF.text isEqualToString:@""])
    {
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
    }
    
    switch (textField.tag)
    {
        case 1:
        {
            if (textField.text.length>0)
            {
                BOOL isMath=[self checkTelNumber:textField.text];

                NSLog(@">>>>>>>>%d",isMath);
                
                if ([self checkTelNumber:textField.text]==YES)
                {
                   
                }
                
                self.cancelBtn.hidden=NO;
            }
            else
            {
                self.cancelBtn.hidden=YES;
 
            }

        }
            break;
        case 2:
        {
            if (textField.text.length>0)
            {
                

                self.secretEntryBtn.hidden=NO;
 
            }
            else
            {
                self.secretEntryBtn.hidden=YES;
            
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 手机号码匹配的正则表达式
-(BOOL)checkTelNumber:(NSString *)telNumber
{
    NSString *pattern=@"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(14[5]))\\d{8}$";
    
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch=[pred evaluateWithObject:telNumber];
    
    return isMatch;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            [self accountLineColorChanged];
        }
            break;
        case 2:
        {
            [self pswLineColorChanged];
        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 账号取消
- (IBAction)cancel:(id)sender
{
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"帐号取消"] forState:UIControlStateNormal];
    
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"帐号取消_d"] forState:UIControlStateHighlighted];
    
    self.accountTF.text=@"";
    
    if ([self.accountTF.text isEqualToString:@""])
    {
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
        
        self.cancelBtn.hidden=YES;
    }
    
}

#pragma mark 密码隐藏
- (IBAction)secretEntry:(id)sender
{
    [self.secretEntryBtn setBackgroundImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateNormal];
    
    [self.secretEntryBtn setBackgroundImage:[UIImage imageNamed:@"显示密码_d"] forState:UIControlStateHighlighted];
 
    if (![self.pswTF.text isEqualToString:@""])
    {
        if (isSecretEntry==NO)
        {
            self.pswTF.secureTextEntry=YES;
            
            isSecretEntry=!isSecretEntry;
        }
        else
        {
            self.pswTF.secureTextEntry=NO;
            
            isSecretEntry=!isSecretEntry;
        }
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
        hud.minSize = CGSizeMake(100.0f, 30.0f);
        [hud hide:YES afterDelay:3.0];
        return NO;
    }
    
    return isExistenceNetwork;
}

-(void)sleep
{
    [self.view makeToast:@"账号或者密码错误!" duration:1.0 position:CSToastPositionCenter];
}

#pragma mark 登录
- (IBAction)login:(id)sender
{
    /*
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button_d"] forState:UIControlStateHighlighted];
    */
    
    if ([self.accountTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""])
    {
        return;
    }
    else
    {
        isConnection=[self isConnectionAvailable];
        
        NSLog(@"isConnecton===%d",isConnection);
    }
    
    if (isConnection)
    {
        if ([self.accountTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""])
        {
            /*
             UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"账号或者密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
             
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             
             //点击响应事件
             
             }]];
             
             [self presentViewController:alert animated:YES completion:nil];
             */
            
            return;
        }
        else
        {
            [self animationbegin:sender];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view addSubview:hud];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0-tips_error"]];
            hud.delegate = self;
            hud.labelText = @"正在加载";
            
            
            AccountInfo *info=[[AccountInfo alloc] init];
            
            info.accountID=self.accountTF.text;
            
            info.psw=self.pswTF.text;
            
            [HttpEngine loginAccount:info and: ^(NSMutableArray *array) {
                
                [hud hide:YES afterDelay:1.0];
                
                ParserInfo *info=array[0];
                
                //点击响应事件
                if ([info.Message isEqualToString:@"登录成功！"])
                {
                    
                    [JPUSHService setTags:nil alias:self.accountTF.text fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
                    }];
                    
                    [USER setValue:self.accountTF.text forKey:@"userName"];
                    [USER setValue:self.pswTF.text forKey:@"pswName"];
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
           
                    [self.accountTF resignFirstResponder];
                    [self.pswTF resignFirstResponder];
                    
                    self.view.window.rootViewController=tabBarVC;
                 
                }else{
                    [self performSelector:@selector(sleep) withObject:nil afterDelay:1.0];
                    return;
                }
                
              
            } failure:^(NSError *error) {
                [hud hide:YES];
                [self.view makeToast:@"服务器异常" duration:1.0 position:CSToastPositionCenter];
            }];
        }
    }
    else
    {
        if ([self.accountTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""])
        {
            return;
        }
        else
        {
            [self animationbegin:sender];
        }
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

#pragma mark 注册
- (IBAction)goRegisterVC:(id)sender
{
    [self animationbegin:sender];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.alpha=0;
        
    } completion:^(BOOL finished){

        RegisterViewController *registerVC=[[RegisterViewController alloc] init];
        
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:registerVC];
        
        self.view.window.rootViewController=nav;
    }];
}

#pragma mark 找回密码
- (IBAction)goFinderVC:(id)sender
{
    [self animationbegin:sender];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.alpha=0;
        
    } completion:^(BOOL finished){
        
        FinderViewController*finderVC=[[FinderViewController alloc] init];
        
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:finderVC];
        
        self.view.window.rootViewController=nav;
    }];
}

#pragma mark 点击--改变横线颜色
-(void)accountLineColorChanged
{
    [self.pswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.accountLine setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
}

-(void)pswLineColorChanged
{
    [self.accountLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.pswLine setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
}

#pragma mark 键盘隐藏
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
