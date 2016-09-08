//
//  AlterPswViewController.m
//  Carcorder
//
//  Created by YF on 16/1/18.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "AlterPswViewController.h"
#import "CustomPswTableViewCell.h"

@interface AlterPswViewController ()

@end

@implementation AlterPswViewController

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
   
    
    self.title=@"修改密码";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishedClick)];
    
    self.navigationItem.rightBarButtonItem=rightItem;
    
    _table.rowHeight=220;
    
    _table.scrollEnabled=NO;
    
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_table registerNib:[UINib nibWithNibName:@"CustomPswTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

-(void)finishedClick

{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomPswTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
