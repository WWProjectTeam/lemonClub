//
//  MyInfoViewController.m
//  Carcorder
//
//  Created by YF on 16/1/27.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "MyInfoViewController.h"
#import "PerInfoViewController.h"
#import "AboutViewController.h"
#import "ZPDFReaderController.h"
#import "PDFWebViewController.h"
#import "LandViewController.h"
#import "AppDelegate.h"
@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"我的";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] init];
    
    backBarItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backBarItem;
    
    
    _table.scrollEnabled=NO;
    
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
         return 100;
    }
    
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (indexPath.section==0)
    {
        UIImageView *headerImg=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
        
        headerImg.image=[UIImage imageNamed:@"用户登录头像.jpg"];
        
        [cell.contentView addSubview:headerImg];
        
        
        UILabel *nameLab=[[UILabel alloc] initWithFrame:CGRectMake(110, 20, 200, 30)];
        
        nameLab.font=[UIFont boldSystemFontOfSize:16.0];
        
//        nameLab.text=@"尊贵的VIP";
        nameLab.text=@"纽眼用户";
        
        [cell.contentView addSubview:nameLab];
        
        UILabel *accountNameLab=[[UILabel alloc] initWithFrame:CGRectMake(112, 50, 50, 30)];
        
        accountNameLab.font=[UIFont systemFontOfSize:15.0];
        
        accountNameLab.text=@"账号:";
        
        accountNameLab.textColor=[UIColor darkGrayColor];
        
        [cell.contentView addSubview:accountNameLab];
        
        
        UILabel *accountLab=[[UILabel alloc] initWithFrame:CGRectMake(152, 50, 148, 30)];
        
        accountLab.font=[UIFont systemFontOfSize:15.0];
        
        NSString *userNameStr=[USER objectForKey:@"userName"];
        
        NSLog(@"userNameStr=======%@",userNameStr);
        
        accountLab.text=userNameStr;
        
        accountLab.textColor=[UIColor darkGrayColor];

        [cell.contentView addSubview:accountLab];

    }
    else
    {
        UIImageView *rowBidImg=[[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 20, 20)];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row==0)
        {
            rowBidImg.image=[UIImage imageNamed:@"4-1"];
            
            UILabel *aboutLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 55)];
            
            aboutLab.font=[UIFont systemFontOfSize:16.0];
            
            aboutLab.text=@"关于";
            
            [cell.contentView addSubview:aboutLab];
        }else if (indexPath.row==1)
        {
            rowBidImg.image=[UIImage imageNamed:@"商店"];
            
            UILabel *shopLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 55)];
            
            shopLab.font=[UIFont systemFontOfSize:16.0];
            
            shopLab.text=@"商店";
            
            [cell.contentView addSubview:shopLab];
        }
        else if (indexPath.row==2)
        {
            rowBidImg.image=[UIImage imageNamed:@"4-3"];
            
            UILabel *helpLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 55)];
            
            helpLab.font=[UIFont systemFontOfSize:16.0];
            
            helpLab.text=@"帮助";
            
            [cell.contentView addSubview:helpLab];
        }
        else
        {
            rowBidImg.image=[UIImage imageNamed:@"4-4"];
            
            UILabel *backLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 55)];

            backLab.text=@"退出登录";

            backLab.font=[UIFont systemFontOfSize:16.0];
            
            [cell.contentView addSubview:backLab];
        }
        
        [cell.contentView addSubview:rowBidImg];
    }

    cell.selectionStyle= UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        /*
        PerInfoViewController *perInfoVC=[[PerInfoViewController alloc] init];
        
        [self.navigationController pushViewController:perInfoVC animated:YES];
        */ 
        
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            AboutViewController *aboutVC=[[AboutViewController alloc] init];
            
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
//        else if (indexPath.row==1)
//        {
            /*
            NSString *otherBtn=NSLocalizedString(@"确定", nil);
            
            NSString *message=NSLocalizedString(@"您使用的已经是最新版本了.", nil);
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            
            NSMutableAttributedString *messageStr=[[NSMutableAttributedString alloc] initWithString:message];
            
            [messageStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 13)];
            
            [alert setValue:messageStr forKey:@"attributedMessage"];
            
            UIAlertAction *removeAction=[UIAlertAction actionWithTitle:otherBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                
            }];

            [alert addAction:removeAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            */
            
            //[self showAlert:@"您使用的已经是最新版本了."];
            
//        }
        else if (indexPath.row==1)
        {
            /*
            ZPDFReaderController *readerVC=[[ZPDFReaderController alloc] init];
            
            readerVC.fileName=@"纽眼手机客户端v1.0.2——操作手册.pdf";
            */
            NSString* path=[NSString stringWithFormat:@"https://newsmynsm.tmall.com"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
           
        }else if(indexPath.row==2)
        {
            PDFWebViewController *pdfWebVC=[[PDFWebViewController alloc] init];
            
            [self.navigationController pushViewController:pdfWebVC animated:YES];
        }
        else
        {
            UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定退出此账号?" delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [sheet showInView:self.view.window];
        }
    }
}

-(void)showAlert:(NSString *)timeMessage
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:timeMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:alert repeats:YES];
    
    [alert show];
}

-(void)timerMethod:(NSTimer *)timer
{
    UIAlertView *alert=(UIAlertView *)[timer userInfo];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    alert=NULL;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [USER removeObjectForKey:@"pswName"];
        /**
         *  退出登录后向极光清空别名
         */
        [(AppDelegate *)[UIApplication sharedApplication].delegate JPushRegisterAliasWithAccountId:@""];
        
        
        LandViewController *landVC=[[LandViewController alloc] initWithNibName:@"LandViewController" bundle:nil];
        
        [self presentViewController:landVC animated:YES completion:nil];
    }
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
