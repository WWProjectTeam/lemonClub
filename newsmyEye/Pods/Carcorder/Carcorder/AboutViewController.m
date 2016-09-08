//
//  AboutViewController.m
//  Carcorder
//
//  Created by YF on 16/1/18.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "AboutViewController.h"
#import "ServiceViewController.h"
#define HeadImg_width 80
#define NameLab_width 100
#define NameLab_height 30
#define Version_width 100
#define Version_height 25
#define Row_height (kScreen_width * 8/16)

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    self.title=@"关于";
    
    self.allowLab.font=[UIFont boldSystemFontOfSize:12.0];
    
    _table.scrollEnabled=NO;

    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (IBAction)protocol:(id)sender {
    ServiceViewController *serviceVC=[[ServiceViewController alloc] init];
    
    [self.navigationController pushViewController:serviceVC animated:YES];
}
- (IBAction)bbs:(id)sender {
    NSString* path=[NSString stringWithFormat:@"http://www.newsmy-car.com/bbs/forum.php"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return Row_height;
    }
    else
    {
        return 45;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row==0)
    {
        UIImageView *bgImg=[[UIImageView alloc] initWithFrame:cell.frame];
        
        bgImg.backgroundColor=[UIColor colorWithRed:80 /255.0 green:210/255.0 blue:194/255.0 alpha:1.0];

        [cell.contentView addSubview:bgImg];
        
        UIImageView *headerImg=[[UIImageView alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width-HeadImg_width)/2, (Row_height-(HeadImg_width+NameLab_height+Version_height))/2, HeadImg_width, HeadImg_width)];
       
        headerImg.image=[UIImage imageNamed:@"AppLogo"];
        
        [cell.contentView addSubview:headerImg];
        
        UILabel *nameLab=[[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width-NameLab_width)/2, (Row_height-(HeadImg_width+NameLab_height+Version_height))/2+headerImg.frame.size.height, NameLab_width, NameLab_height)];
        
        nameLab.text=@"纽眼";
        
        nameLab.textColor=[UIColor whiteColor];
        
        nameLab.textAlignment=NSTextAlignmentCenter;
        
        [cell.contentView addSubview:nameLab];
        
        UILabel *versionLab=[[UILabel alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width-Version_width)/2, nameLab.frame.origin.y+NameLab_height, Version_width, Version_height)];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        versionLab.text=app_Version;
        
        versionLab.textColor=[UIColor whiteColor];
        
        versionLab.textAlignment=NSTextAlignmentCenter;
        
        [cell.contentView addSubview:versionLab];
    
    }
    else if (indexPath.row==1)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 40)];
        
        lab.text=@"服务热线: 4008109810";
        
        lab.font=[UIFont systemFontOfSize:15.0];
        
        [cell.contentView addSubview:lab];

    }
    else if (indexPath.row==2)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 40)];
        
        lab.text=@"邮箱: ny_support@newsmy.com";
        
        lab.font=[UIFont systemFontOfSize:15.0];
        
        [cell.contentView addSubview:lab];

    }
    
    else if(indexPath.row==3)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 40)];
        
        lab.text=@"技术商务合作: 0731-82087068 常先生";
        
        lab.font=[UIFont systemFontOfSize:15.0];
        
        [cell.contentView addSubview:lab];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
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
