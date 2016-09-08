//
//  PreviewViewController.m
//  Carcorder
//
//  Created by YF on 16/1/15.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

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
   
    self.title=@"预览";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"使用" style:UIBarButtonItemStylePlain target:self action:@selector(useClick)];
    
    self.navigationItem.rightBarButtonItem=rightItem;
  
}

-(void)useClick

{
    
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
