//
//  ShareViewController.m
//  Carcorder
//
//  Created by YF on 15/12/31.
//  Copyright © 2015年 newsmy. All rights reserved.
//

#import "ShareViewController.h"
#import "HttpEngine.h"
#import "ParserInfo.h"
#import "UIView+Toast.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //服务协议返回按钮标题设置
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem=leftBtnItem;
    
    [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    
    [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    
    /*
    if (self.accountTF.text.length>0&&self.confirmCodeTF.text.length>0&&self.pswTF.text.length>0&&self.certainPswTF.text.length>0)
    {
        [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
        [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
    }
    */
}


/*
-(void)textEditChanged:(UITextField *)textField
{
    if (![self.accountTF.text isEqualToString:@""])
    {
        [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
        [self.getCodeBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
    }

    if (![self.accountTF.text isEqualToString:@""]&&![self.confirmCodeTF.text isEqualToString:@""]&&![self.pswTF.text isEqualToString:@""]&&![self.certainPswTF.text isEqualToString:@""])
    {
        [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
    }
    else
    {
        [self.shareBtn setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.5]];
    }

}
*/

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
            [self codeLineColorChanged];
        }
            break;
        case 3:
        {
            [self pswLineColorChanged];
        }
            break;
        case 4:
        {
            [self certainLineColorChanged];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 手机号码匹配的正则表达式
-(BOOL)checkTelNumber:(NSString *)telNumber
{
    //@"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(14[5]))\\d{8}$";
    NSString *pattern=@"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch=[pred evaluateWithObject:telNumber];
    
    return isMatch;
}

#pragma 正则匹配用户密码6-10位数字或字母
-(BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^[a-zA-Z0-9]{6,10}+$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
}

#pragma mark 按下return键或者按回车键--keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTF resignFirstResponder];
    
    [self.confirmCodeTF resignFirstResponder];
    
    [self.pswTF resignFirstResponder];
    
    [self.certainPswTF resignFirstResponder];
    
    return YES;
}

#pragma mark 点击--改变横线颜色
-(void)accountLineColorChanged
{
    [self.codeLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.pswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.certainPswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.accountLine setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
}

-(void)codeLineColorChanged
{
    [self.accountLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.pswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.certainPswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.codeLine setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
}

-(void)pswLineColorChanged
{
    [self.accountLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.codeLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.certainPswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.pswLine setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
}

-(void)certainLineColorChanged
{
    [self.accountLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.codeLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.pswLine setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.certainPswLine setBackgroundColor:[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1.0]];
}

#pragma mark 隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
