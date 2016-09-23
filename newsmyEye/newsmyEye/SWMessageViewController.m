/*
 *              消息  公用同一个cell 不同的数组   
 */

//
//  SWMessageViewController.m
//  newsmyEye
//
//  Created by push on 16/9/11.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "SWMessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"
#import "WWBlankPageView.h"

@interface SWMessageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *chooseView;
    UIButton *myMessageBtn;
    UIButton *sysMessageBtn;
    UILabel  *chooseLine;
    UILabel *myRed;
    UILabel *sysRed;
    WWBlankPageView *myBlanView;
    WWBlankPageView *sysBlanView;
}

@end

@implementation SWMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"消息";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI];
}

// 创建试图
- (void)creatUI{
    chooseView = [[UIView alloc]init];
    [chooseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.width.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    UILabel *chooseBottomLine = [[UILabel alloc]init];
    chooseBottomLine.backgroundColor = WWPageLineColor;
    [chooseView addSubview:chooseBottomLine];
    [chooseBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(chooseView);
        make.bottom.equalTo(chooseView.mas_bottom).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
    
    chooseLine = [[UILabel alloc]init];
    chooseLine.backgroundColor = RGBCOLOR(237, 200, 30);
    [chooseView addSubview:chooseLine];
    [chooseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@2);
        make.bottom.equalTo(chooseView.mas_bottom).offset(-0.5);
        make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(0.5);
    }];
    
    myMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myMessageBtn setTitle:@"评论我的" forState:UIControlStateNormal];
    [myMessageBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    [myMessageBtn setTitleColor:btn_organ forState:UIControlStateSelected];
    myMessageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myMessageBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    myMessageBtn.tag = 1001;
    [chooseView addSubview:myMessageBtn];
    [myMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseView.mas_centerY);
        make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(0.5);
        make.height.equalTo(chooseView);
    }];
    myMessageBtn.selected = YES;
    // 消息提示
    myRed = [[UILabel alloc]init];
    myRed.backgroundColor = [UIColor redColor];
    myRed.layer.cornerRadius = 3.5;
    myRed.layer.masksToBounds = YES;
    [chooseView addSubview:myRed];
    [myRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(7);
        make.left.equalTo(myMessageBtn.mas_right).offset(7);
        make.top.mas_equalTo(10);
    }];

    sysMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sysMessageBtn setTitle:@"系统通知" forState:UIControlStateNormal];
    [sysMessageBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    [sysMessageBtn setTitleColor:btn_organ forState:UIControlStateSelected];
    sysMessageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sysMessageBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    sysMessageBtn.tag = 1002;
    [chooseView addSubview:sysMessageBtn];
    [sysMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseView.mas_centerY);
        make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(1.5);
        make.height.equalTo(chooseView);
    }];
    // 消息提示
    sysRed = [[UILabel alloc]init];
    sysRed.backgroundColor = [UIColor redColor];
    sysRed.layer.cornerRadius = 3.5;
    sysRed.layer.masksToBounds = YES;
    [chooseView addSubview:sysRed];
    [sysRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(7);
        make.left.equalTo(sysMessageBtn.mas_right).offset(7);
        make.top.mas_equalTo(10);
    }];

    // 背景scrollview
    self.messageBackScrollview = [[UIScrollView alloc]init];
    self.messageBackScrollview.contentSize = CGSizeMake(MainView_Width*2, 0);
    self.messageBackScrollview.pagingEnabled = YES;
    self.messageBackScrollview.scrollEnabled= NO;
    [self.view addSubview:self.messageBackScrollview];
    [self.messageBackScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(chooseView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    //评论我的
    self.myMessageTableView = [[UITableView alloc]init];
    self.myMessageTableView.delegate = self;
    self.myMessageTableView.dataSource = self;
    self.myMessageTableView.backgroundColor = [UIColor clearColor];
    [self.messageBackScrollview addSubview:self.myMessageTableView];
    [self.myMessageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.equalTo(self.messageBackScrollview);
        make.width.mas_equalTo(MainView_Width);
    }];
    //消息
    self.sysMessageTableView = [[UITableView alloc]init];
    self.sysMessageTableView.delegate = self;
    self.sysMessageTableView.dataSource = self;
    self.sysMessageTableView.backgroundColor = [UIColor clearColor];
    [self.messageBackScrollview addSubview:self.sysMessageTableView];
    [self.sysMessageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.messageBackScrollview);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(MainView_Width);
        make.left.equalTo(self.myMessageTableView.mas_right);
    }];

    // 空白页面
    myBlanView = [[WWBlankPageView alloc]initWithFrame:CGRectNull blankImg:[UIImage imageNamed:@"gost"] blankTitle:@"还没有人评论你呢~"];
    [self.messageBackScrollview addSubview:myBlanView];
    [myBlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self.messageBackScrollview);
    }];
    myBlanView.hidden = YES;
    
    if (self.myMessageArray.count == 0) {
        myBlanView.hidden = YES;
    }else{
        myBlanView.hidden = NO;
    }
    // 空白页面
    sysBlanView = [[WWBlankPageView alloc]initWithFrame:CGRectNull blankImg:[UIImage imageNamed:@"gost"] blankTitle:@"还任何消息~"];
    [self.messageBackScrollview addSubview:sysBlanView];
    [sysBlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.messageBackScrollview);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(MainView_Width);
        make.left.equalTo(self.myMessageTableView.mas_right);
    }];
    sysBlanView.hidden = YES;
    
    if (self.sysMessageArray.count == 0) {
        sysBlanView.hidden = YES;
    }else{
        sysBlanView.hidden = NO;
    }

    
    self.myMessageArray = [[NSMutableArray alloc]init];
    self.sysMessageArray = [[NSMutableArray alloc]init];

    [self loadData];
}

#pragma mark - tableViewDelegate
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [self.myMessageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myCollect";
    MessageTableViewCell *cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc]init];
    }
    if (tableView == self.myMessageTableView) {
        MessageModel *model = self.myMessageArray[indexPath.row];
        [cell messageCellData:model];
        
        model.height = [cell rowHeight];
    }
    
    if (tableView == self.sysMessageTableView) {
        MessageModel *model = self.sysMessageArray[indexPath.row];
        [cell messageCellData:model];
        
        model.height = [cell rowHeight];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel * model = self.myMessageArray[indexPath.row];
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)chooseClick:(UIButton *)sender{
    if (sender.tag == 1001) {
        myMessageBtn.selected = YES;
        sysMessageBtn.selected = NO;
        [chooseLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@2);
            make.bottom.equalTo(chooseView.mas_bottom).offset(-0.5);
            make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(0.5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.messageBackScrollview.contentOffset = CGPointMake(0, 0);
        }];
        
    }else{
        myMessageBtn.selected = NO;
        sysMessageBtn.selected = YES;
        [chooseLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@2);
            make.bottom.equalTo(chooseView.mas_bottom).offset(-0.5);
            make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(1.5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.messageBackScrollview.contentOffset = CGPointMake(MainView_Width, 0);
        }];

    }
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)loadData{
    
    for (int i =0; i<7; i++) {
        MessageModel * model01 = [[MessageModel alloc]init];
        model01.messageNameStr = @"黄小军";
        model01.messageContentStr = @"如果过去的时光消逝了，那就让他随风而去吧，只是。让我很难过.";
        model01.messageTimeStr = @"06-22 12:13";
        
        model01.commentTitleStr = @"浪里格朗 浪里";
        model01.commentNameStr = @"李小伟:";
        model01.commentContentStr = @"如果过去的时光消逝了，那就让他随风而让";
        [self.myMessageArray addObject:model01];

    }
    
    for (int i =0; i<7; i++) {
        MessageModel * model01 = [[MessageModel alloc]init];
        model01.messageNameStr = @"黄小军";
        model01.messageContentStr = @"如果过去的时光消逝了，那就让他随风而去吧，只是。让我很难过.";
        model01.messageTimeStr = @"06-22 12:13";
        
        model01.commentTitleStr = @"浪里格朗 浪里";
        model01.commentNameStr = @"李小伟:";
        model01.commentContentStr = @"如果过去的时光消逝了，那就让他随风而让";
        [self.sysMessageArray addObject:model01];
        
    }
    
    [self.myMessageTableView reloadData];
    [self.sysMessageTableView reloadData];
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [self.view layoutIfNeeded];
    
}


// 返回喽
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
