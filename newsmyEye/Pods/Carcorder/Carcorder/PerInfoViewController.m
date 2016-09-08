//
//  PerInfoViewController.m
//  Carcorder
//
//  Created by YF on 16/1/14.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "PerInfoViewController.h"
#import "HeaderViewController.h"
#import "AlterNameViewController.h"
#import "AlterPswViewController.h"
#import "LandViewController.h"

@interface PerInfoViewController ()

@end

@implementation PerInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.title=@"个人信息";

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
        if (indexPath.row==0)
        {
            return 80;
 
        }
        
        return 50;
    }
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 4;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            UILabel *headerLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 80)];
            
            headerLab.font=[UIFont systemFontOfSize:16.0];
            
            headerLab.text=@"头像";
            
            headerLab.textColor=[UIColor darkGrayColor];
            
            [cell.contentView addSubview:headerLab];
            
            UIImageView *headerImg=[[UIImageView alloc] initWithFrame:CGRectMake(200, 5, 70, 70)];
            
            headerImg.clipsToBounds=YES;
            
            headerImg.layer.cornerRadius=headerImg.frame.size.width/2;
            
            headerImg.image=[UIImage imageNamed:@"car.jpg"];
            
            [cell.contentView addSubview:headerImg];
        }
        else if (indexPath.row==1)
        {
            UILabel *nameLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 50)];
            
            nameLab.font=[UIFont systemFontOfSize:16.0];
            
            nameLab.text=@"昵称";
            
            nameLab.textColor=[UIColor darkGrayColor];
            
            [cell.contentView addSubview:nameLab];
            
            UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 100, 50)];
            
            lab.font=[UIFont systemFontOfSize:15.0];
            
            lab.text=@"存杨先生";
            
            lab.textAlignment=NSTextAlignmentCenter;
            
            lab.textColor=[UIColor lightGrayColor];
            
            [cell.contentView addSubview:lab];
        }
        else if (indexPath.row==2)
        {
            UILabel *accountLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 50)];
            
            accountLab.font=[UIFont systemFontOfSize:16.0];
            
            accountLab.text=@"账号";
            
            accountLab.textColor=[UIColor darkGrayColor];
            
            [cell.contentView addSubview:accountLab];
            
            UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 120, 50)];
            
            lab.font=[UIFont systemFontOfSize:15.0];
            
            lab.text=@"15309640437";
            
            lab.textColor=[UIColor lightGrayColor];
            
            [cell.contentView addSubview:lab];
            
        }
        else
        {
            UILabel *regionLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 50)];
            
            regionLab.font=[UIFont systemFontOfSize:16.0];
            
            regionLab.text=@"地区";
            
            regionLab.textColor=[UIColor darkGrayColor];
            
            [cell.contentView addSubview:regionLab];
            
            UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 100, 50)];
            
            lab.font=[UIFont systemFontOfSize:15.0];
            
            lab.text=@"湖南 长沙";
            
            lab.textAlignment=NSTextAlignmentCenter;
            
            lab.textColor=[UIColor lightGrayColor];
            
            [cell.contentView addSubview:lab];
        }
        
    }
    else
    {
        UILabel *resetNameLab=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 50)];
        
        resetNameLab.font=[UIFont systemFontOfSize:16.0];
        
        resetNameLab.text=@"修改密码";
        
        resetNameLab.textColor=[UIColor darkGrayColor];
        
        [cell.contentView addSubview:resetNameLab];
    }
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            HeaderViewController *headerVC=[[HeaderViewController alloc] init];
            
            [self.navigationController pushViewController:headerVC animated:YES];
        }
        else if (indexPath.row==1)
        {
            AlterNameViewController *alterVC=[[AlterNameViewController alloc] init];
            
            [self.navigationController pushViewController:alterVC animated:YES];
        }
        else if (indexPath.row==2)
        {
            
        }
        else
        {
            
        }
    }
    else
    {
        AlterPswViewController *pswVC=[[AlterPswViewController alloc] init];
        
        [self.navigationController pushViewController:pswVC animated:YES];
    }
 }

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        LandViewController *landVC=[[LandViewController alloc] initWithNibName:@"LandViewController" bundle:nil];
        
        [self presentViewController:landVC animated:YES completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
