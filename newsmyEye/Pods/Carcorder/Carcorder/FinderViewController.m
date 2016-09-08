//
//  FinderViewController.m
//  Carcorder
//
//  Created by YF on 15/12/29.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import "FinderViewController.h"
#import "LandViewController.h"
#import "AccountInfo.h"
#import "HttpEngine.h"
#import "ParserInfo.h"
#import "UIView+Toast.h"

@interface FinderViewController ()
{
    NSString *messageStr;
}
@end

@implementation FinderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"忘记密码";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};

    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_back-iOS7@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    self.accountTF.delegate=self;
    self.pswTF.delegate=self;
    self.confirmCodeTF.delegate=self;
    self.certainPswTF.delegate=self;
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
    return YES;
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
        hud.minSize = CGSizeMake(100.0f, 50.0f);
        [hud hide:YES afterDelay:3.0];
        return NO;
    }
    
    return isExistenceNetwork;
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
                    
                    info.command=@"account_phone_verify";
                    
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
    if ([messageStr isEqualToString:@"修改密码成功!"])
    {
        LandViewController *landVC=[[LandViewController alloc] init];
        
        self.view.window.rootViewController=landVC;
    }
}

#pragma mark 找回密码
- (IBAction)finderBtn:(id)sender
{
    /*
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"button-1"] forState:UIControlStateNormal];
    
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"button_d-1"] forState:UIControlStateHighlighted];
     */
    
    [self animationbegin:sender];
    
    BOOL isConnection=[self isConnectionAvailable];
    
    if (isConnection)
    {
        BOOL isMatchTelNum=[self checkTelNumber:self.accountTF.text];
        
        if ([self.accountTF.text isEqualToString:@""]||[self.confirmCodeTF.text isEqualToString:@""]||[self.pswTF.text isEqualToString:@""]||[self.certainPswTF.text isEqualToString:@""])
        {
            /*
             UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"输入框不能为空!" preferredStyle:UIAlertControllerStyleAlert];
             
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             
             //点击响应事件
             
             }]];
             
             [self presentViewController:alert animated:YES completion:nil];
             */
            
            if ([self.accountTF.text isEqualToString:@""])
            {
                [self.view makeToast:@"请输入手机号!" duration:1.0 position:CSToastPositionCenter];
            }
            else
            {
                if (isMatchTelNum)
                {
                    [self.view makeToast:@"输入框不能为空!" duration:1.0 position:CSToastPositionCenter];
                }
                else
                {
                   [self.view makeToast:@"请输入正确手机号!" duration:1.0 position:CSToastPositionCenter];
                }
            }
            
            return;
        }
        else
        {
            if (self.accountTF.text.length>0&&self.accountTF.text.length<11)
            {
                [self.view makeToast:@"请输入正确手机号!" duration:1.0 position:CSToastPositionCenter];
            }
            else
            {
                if (isMatchTelNum)
                {
                    NSString *getConfirmCode=[USER objectForKey:@"confirmCode"];
                    
                    if ([self.confirmCodeTF.text isEqualToString:getConfirmCode])
                    {
                        if (self.pswTF.text.length>=6&&self.certainPswTF.text.length>=6)
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
                                
                                accountInfo.psw=self.pswTF.text;
                                
                                accountInfo.confirmCode=self.confirmCodeTF.text;
                                
                                [HttpEngine resetAccountPsw:accountInfo and:^(NSMutableArray *array) {
                                    
                                    [hud hide:YES afterDelay:1.0];
                                    
                                    ParserInfo *info=array[0];
                                    
                                    /*
                                     UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:info.Message preferredStyle:UIAlertControllerStyleAlert];
                                     
                                     [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                     
                                     if ([info.Message isEqualToString:@"修改密码成功！"])
                                     {
                                     LandViewController *landVC=[[LandViewController alloc] init];
                                     self.view.window.rootViewController=landVC;
                                     }
                                     
                                     }]];
                                     
                                     [self presentViewController:alert animated:YES completion:nil];
                                     */
                                    
                                    messageStr=info.Message;
                                    
                                    [self performSelector:@selector(sleep) withObject:nil afterDelay:1.0];
                                    NSLog(@"finderMessage------>>>>> %@",info.Message);
                                    
                                }];
                            }
                            else
                            {
                                /*
                                 UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                 
                                 }]];
                                 
                                 [self presentViewController:alert animated:YES completion:nil];
                                 */
                                
                                [self.view makeToast:@"两次输入密码不一致" duration:1.0 position:CSToastPositionCenter];
                            }
                        }
                        else
                        {
                            /*
                             UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"两次密码输入少于六位" preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *certainAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                             
                             }];
                             
                             [alert addAction:certainAction];
                             
                             [self presentViewController:alert animated:YES completion:nil];
                             */
                            
                            [self.view makeToast:@"两次密码输入少于六位" duration:1.0 position:CSToastPositionCenter];
                        }
                    }
                    else
                    {
                        NSString *confirmCodeStr=[USER objectForKey:@"confirmCode"];
                        
                        if ([confirmCodeStr isEqualToString:@"账户已存在！"])
                        {
                            [self.view makeToast:@"账户已存在!" duration:1.0 position:CSToastPositionCenter];
                        }
                        else
                        {
                            [self.view makeToast:@"您所输入的验证码无效!" duration:1.0 position:CSToastPositionCenter];
                        }
                    }
                }
                else
                {
                    [self.view makeToast:@"手机号是空号!" duration:1.0 position:CSToastPositionCenter];
                }
            }
        }
    }
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
