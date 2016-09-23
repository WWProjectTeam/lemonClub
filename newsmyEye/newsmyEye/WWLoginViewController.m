//
//  WWLoginViewController.m
//  newsmyEye
//
//  Created by ww on 16/7/25.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWLoginViewController.h"
#import "HyTransitions.h"
#import "HyLoglnButton.h"
#import "HyLoginButton.h"
#import "WWHomePageViewController.h"
#import "WWRegisterViewController.h"


@interface WWLoginViewController (){
    UITextField * tfUserPhone;
    UITextField * tfUserPwd;
    
    TencentOAuth *_tencentOAuth;
}

@end

@implementation WWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:APP_ID andDelegate:self];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma amrk - UIINIT
-(void)initUI{
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"background-img"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    
    UIImageView * imgLogo = [[UIImageView alloc]init];
    [imgLogo setImage:[UIImage imageNamed:@"logo"]];
    
    [self.view addSubview:imgLogo];
    
    [imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(91);
        make.width.equalTo(@171);
        make.height.equalTo(@90);
    }];
    
    //输入框
    //用户名
    
    UIView * viewPhone = [[UIView alloc]init];
    [viewPhone setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    viewPhone.layer.cornerRadius = 5.f;
    
    [self.view addSubview:viewPhone];
    
    [viewPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.top.equalTo(imgLogo.mas_bottom).offset(44);
        make.height.equalTo(@44);
    }];
    
    tfUserPhone = [[UITextField alloc]init];
    [tfUserPhone setPlaceholder:@"手机号码"];
    [tfUserPhone setKeyboardType:UIKeyboardTypePhonePad];
    
    [viewPhone addSubview:tfUserPhone];
    
    [tfUserPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPhone.mas_left).offset(10);
        make.right.equalTo(viewPhone.mas_right).offset(-10);
        make.top.equalTo(viewPhone.mas_top).offset(5);
        make.bottom.equalTo(viewPhone.mas_bottom).offset(-5);
    }];
    
    //密码
    UIView * viewPwd = [[UIView alloc]init];
    [viewPwd setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    viewPwd.layer.cornerRadius = 5.f;
    
    [self.view addSubview:viewPwd];
    
    [viewPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.top.equalTo(viewPhone.mas_bottom).offset(10);
        make.height.equalTo(@44);
    }];
    
    
    UIButton * btnSwitch = [[UIButton alloc]init];
    [btnSwitch setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [btnSwitch addTarget:self action:@selector(switchSercu) forControlEvents:UIControlEventTouchUpInside];
    
    [viewPwd addSubview:btnSwitch];
    
    [btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewPwd.mas_right).offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(@18);
        make.top.equalTo(@13);
    }];
    
    tfUserPwd = [[UITextField alloc]init];
    [tfUserPwd setPlaceholder:@"密码"];
    [tfUserPwd setSecureTextEntry:YES];
    [tfUserPwd setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    [viewPwd addSubview:tfUserPwd];
    
    [tfUserPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewPwd.mas_left).offset(10);
        make.right.equalTo(btnSwitch.mas_left).offset(-10);
        make.top.equalTo(viewPwd.mas_top).offset(5);
        make.bottom.equalTo(viewPwd.mas_bottom).offset(-5);
    }];
    
    
    //忘记密码
    UIButton * btnForgetPwd = [[UIButton alloc]init];
    [btnForgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btnForgetPwd setTitleColor:WWGreyText forState:UIControlStateNormal];
    [btnForgetPwd.titleLabel setFont:font_nonr_size(14)];
    btnForgetPwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnForgetPwd addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnForgetPwd];
    
    [btnForgetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tfUserPwd.mas_left);
        make.top.equalTo(viewPwd.mas_bottom).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    HyLoginButton *btnSubmit = [[HyLoginButton alloc] initWithFrame:CGRectMake(40, CGRectGetHeight(self.view.bounds) - 230, [UIScreen mainScreen].bounds.size.width - 80, 44)];
    
    [btnSubmit setTitle:@"登    录" forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[self buttonImageFromColor:btn_organ] forState:UIControlStateNormal];
    // [btnSubmit setBackgroundColor:[UIColor colorWithRed:1 green:0.f/255.0f blue:128.0f/255.0f alpha:1]];
    
    [btnSubmit setAlpha:.7f];
    btnSubmit.layer.cornerRadius = 5.f;
    [btnSubmit addTarget:self action:@selector(loginIn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btnSubmit];
    
    //    [btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(40);
    //        make.right.equalTo(self.view.mas_right).offset(-40);
    //        make.top.equalTo(btnForgetPwd.mas_bottom).offset(50);
    //        make.height.equalTo(@44);
    //    }];
    
    
    //账户注册
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"账户注册"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:WWGreyText range:strRange];
    
    UIButton * btnRegister = [[UIButton alloc]init];
    [btnRegister setAttributedTitle:str forState:UIControlStateNormal];
    [btnRegister setTitleColor:WWGreyText forState:UIControlStateNormal];
    [btnRegister.titleLabel setFont:font_nonr_size(14)];
    btnRegister.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnRegister addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnRegister];
    
    [btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnSubmit.mas_right);
        make.top.equalTo(btnSubmit.mas_bottom).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    
    
    
    //其他登陆方式
    UIButton * btnWeChat = [[UIButton alloc]init];
    [btnWeChat setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    [btnWeChat setTag:10001];
    [btnWeChat addTarget:self action:@selector(vendorLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnWeChat];
    
    [btnWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@73);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5);
    }];
    
    
    UIButton * btnQQ = [[UIButton alloc]init];
    [btnQQ setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [btnQQ setTag:10002];
    [btnQQ addTarget:self action:@selector(vendorLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnQQ];
    
    [btnQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@73);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIButton * btnSina = [[UIButton alloc]init];
    [btnSina setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [btnSina setTag:10003];
    [btnSina addTarget:self action:@selector(vendorLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnSina];
    
    [btnSina mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@73);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.5);
    }];
    
    
    //您还可以通过以下方式登陆
    UILabel * labelContent = [[UILabel alloc]init];
    [labelContent setText:@"您还可以通过以下方式登陆"];
    [labelContent setFont:font_nonr_size(14)];
    [labelContent setTextColor:WWGreyText];
    [labelContent setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:labelContent];
    
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
        make.bottom.equalTo(btnSina.mas_top).offset(0);
    }];
}

#pragma mark - otherLoginType
-(void)vendorLogin:(UIButton *)sender{
    switch (sender.tag) {
        case 10001:
            DDLogInfo(@"WeChat");
            break;
            
        case 10002:
        {
            DDLogInfo(@"QQ");
            
            NSArray* permissions = [NSArray arrayWithObjects:
                                    kOPEN_PERMISSION_GET_USER_INFO,
                                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                    kOPEN_PERMISSION_ADD_ALBUM,
                                    kOPEN_PERMISSION_ADD_ONE_BLOG,
                                    kOPEN_PERMISSION_ADD_SHARE,
                                    kOPEN_PERMISSION_ADD_TOPIC,
                                    kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                    kOPEN_PERMISSION_GET_INFO,
                                    kOPEN_PERMISSION_GET_OTHER_INFO,
                                    kOPEN_PERMISSION_LIST_ALBUM,
                                    kOPEN_PERMISSION_UPLOAD_PIC,
                                    nil];
            
            [_tencentOAuth authorize:permissions inSafari:NO];
        }
            break;
            
        case 10003:
            DDLogInfo(@"Sina");
            break;
            
        default:
            break;
    }
}

#pragma mark - Action -- Register -- ForgetPwd -- LoginIn
-(void)loginIn:(HyLoginButton *)button{
    
    typeof(self) __weak weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        DDLogInfo(@"登陆动作");
        //        //校验
        //        if (tfUserPhone.text.length != 11) {
        //            [SVProgressHUD showImage:nil status:@"手机号码错误，请重新输入!"];
        //
        //            [button failedAnimationWithCompletion:^{
        //                    //[weak didPresentControllerButtonTouch];
        //            }];
        //
        //            return;
        //        }
        //
        //        if (tfUserPwd.text.length < 6) {
        //            [SVProgressHUD showImage:nil status:@"密码长度不能小于6位!"];
        //
        //
        //            [button failedAnimationWithCompletion:^{
        //                //[weak didPresentControllerButtonTouch];
        //            }];
        //
        //            return;
        //        }
        
        
        [self.view endEditing:YES];
        //网络正常 或者是密码账号正确跳转动画
        [button succeedAnimationWithCompletion:^{
            [weak didPresentControllerButtonTouch];
        }];
        
    });
    
}


- (void)didPresentControllerButtonTouch {
    WWHomePageViewController  *controller = [WWHomePageViewController new];
    controller.transitioningDelegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.transitioningDelegate = self;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isPush:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isPush:false];
}


-(void)registerAction{
    DDLogInfo(@"注册动作");
    WWRegisterViewController *registerVC = [[WWRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

-(void)forgetPwd{
    DDLogInfo(@"忘记密码");
    WWRegisterViewController *registerVC = [[WWRegisterViewController alloc]init];
    registerVC.is_register = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma makr - tfText
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


//密文切换
-(void)switchSercu{
    [tfUserPwd setSecureTextEntry:!tfUserPwd.secureTextEntry];
}

//通过颜色来生成一个纯色图片
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}


#pragma mark - QQ登陆


/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        
        [_tencentOAuth getUserInfo];
        
        [self.view endEditing:YES];
        
        
    }else{
        
        NSLog(@"accessToken 没有获取成功");
    }
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}


/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }
    
    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@" response %@",response);
    
    WWHomePageViewController  *controller = [WWHomePageViewController new];
    controller.dicUserInfoFromQQ = [response jsonResponse];
    controller.transitioningDelegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.transitioningDelegate = self;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
