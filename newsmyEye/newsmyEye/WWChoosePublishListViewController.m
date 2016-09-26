//
//  WWChoosePublishListViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/22.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWChoosePublishListViewController.h"
#import "ChoosePublishListTableViewCell.h"

@interface WWChoosePublishListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WWChoosePublishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(239, 239, 246);
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"选择标签";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;

    self.publishListTableView = [[UITableView alloc]init];
    self.publishListTableView.backgroundColor = [UIColor clearColor];
    self.publishListTableView.delegate = self;
    self.publishListTableView.dataSource = self;
    self.publishListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.publishListTableView];
    [self.publishListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.publishListArray = [[NSMutableArray alloc]init];
    for ( int i = 0; i<10; i++) {
        NSDictionary *dic;
        if (self.is_select == nil) {
            
            dic = @{@"name":@"科幻",@"is_select":@"1"};
        }else{
            if (i == [self.is_select intValue]) {
                dic = @{@"name":@"科幻",@"is_select":@"0"};
            }else{
                dic = @{@"name":@"科幻",@"is_select":@"1"};
            }
        }
        
        [self.publishListArray addObject:dic];
    }
    [self.publishListTableView reloadData];
}

#pragma mark - tableViewDelegate
#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.publishListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellString";
    //
    ChoosePublishListTableViewCell *cell = [[ChoosePublishListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ChoosePublishListTableViewCell alloc] init];
    }
    NSDictionary *dic  = self.publishListArray[indexPath.row];

    [cell reloadPublishListData:dic];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic  = self.publishListArray[indexPath.row];
    self.cellSelectBlock([dic objectForKey:@"name"],[NSString stringWithFormat:@"%ld",indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
