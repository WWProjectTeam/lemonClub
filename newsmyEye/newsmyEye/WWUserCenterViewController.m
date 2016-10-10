/*
 * 个人中心   公用同一个cell 不同的数组   publishArray
                                    collectionArray
            空白界面布局公用一个类    可以该界面布局有问题     填写完数据后在检测
 */

//
//  WWUserCenterViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWUserCenterViewController.h"
#import "WWPublishTableViewCell.h"
#import "WWBlankPageView.h"

@interface WWUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    WWBlankPageView *publishBlanView;
    WWBlankPageView *collectionBlanView;
}

@end

@implementation WWUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * backGround = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, MainView_Height)];
    [backGround setImage:[UIImage imageNamed:@"personbackground-2"]];
    [backGround setContentMode:UIViewContentModeScaleAspectFill];
    //  [backGround setAlpha:.6f];
    [self.view addSubview:backGround];
    
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:YES];
    
    UIButton * goBack = [[UIButton alloc]init];
    [goBack setImage:[UIImage imageNamed:@"back-whirte"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBack];
    [goBack mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.height.mas_equalTo(22);
        make.width.equalTo(@15);
        make.height.equalTo(@26);
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(28);
    }];
    
    // 标题
    UILabel  *tagLabel = [[UILabel alloc]init];
    tagLabel.text = @"个人主页";
    tagLabel.font = font_nonr_size(19);
    tagLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(goBack.mas_centerY);
    }];

    [self creatUI];
}

- (void)creatUI{
    imageViewHead = [[UIImageView alloc]init];
    [imageViewHead setImage:[UIImage imageNamed:@"photo--default"]];
    imageViewHead.layer.cornerRadius = 35.5f;
    [self.view addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@84);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@71);
        make.height.equalTo(@71);
    }];
    //昵称
    labelUserNickName = [[UILabel alloc]init];
    [labelUserNickName setFont:font_nonr_size(14)];
    [labelUserNickName setText:@"黄海军"];
    [labelUserNickName setTextAlignment:NSTextAlignmentCenter];
    [labelUserNickName setTextColor:RGBCOLOR(50, 50, 50)];
    [self.view addSubview:labelUserNickName];
    [labelUserNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(imageViewHead.mas_bottom).offset(12);
        make.height.equalTo(@15);
    }];
    // 性别
    sexImage = [[UIImageView alloc]init];
    sexImage.image = [UIImage imageNamed:@"man"];
    //or  sexImage.image = [UIImage imageNamed:@"woman"];
    [self.view addSubview:sexImage];
    [sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelUserNickName.mas_right).offset(10);
        make.centerY.equalTo(labelUserNickName.mas_centerY);
    }];
    // 年龄
    ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ageButton setTitle:@"19岁" forState:UIControlStateNormal];
    [ageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ageButton.titleLabel.font = [UIFont systemFontOfSize:10];
    ageButton.backgroundColor = RGBCOLOR(143, 241, 64);
    ageButton.layer.cornerRadius = 3;
    ageButton.layer.masksToBounds = YES;
    [self.view addSubview:ageButton];
    [ageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelUserNickName.mas_bottom).offset(10);
    }];
    
    chooseView = [[UIView alloc]init];
    [chooseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ageButton.mas_bottom).offset(20);
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
    
    publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    [publishBtn setTitleColor:btn_organ forState:UIControlStateSelected];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [publishBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    publishBtn.tag = 1001;
    [chooseView addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseView.mas_centerY);
        make.left.mas_equalTo(0);
        //make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(0.5);
        make.height.equalTo(chooseView);
        make.width.mas_equalTo(MainView_Width/2);
    }];
    publishBtn.selected = YES;
    
    collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectionBtn setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
    [collectionBtn setTitleColor:btn_organ forState:UIControlStateSelected];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [collectionBtn addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.tag = 1002;
    [chooseView addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseView.mas_centerY);
        make.left.mas_equalTo(MainView_Width/2);
        //make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(1.5);
        make.height.equalTo(chooseView);
        make.width.mas_equalTo(MainView_Width/2);
    }];
  
    // 背景scrollview
    self.BackScrollview = [[UIScrollView alloc]init];
    self.BackScrollview.backgroundColor = [UIColor whiteColor];
    self.BackScrollview.contentSize = CGSizeMake(MainView_Width*2, 0);
    self.BackScrollview.pagingEnabled = YES;
    self.BackScrollview.scrollEnabled= NO;
    [self.view addSubview:self.BackScrollview];
    [self.BackScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(chooseView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    //评论我的
    self.publishTableView = [[UITableView alloc]init];
    self.publishTableView.delegate = self;
    self.publishTableView.dataSource = self;
    self.publishTableView.backgroundColor = [UIColor clearColor];
    self.publishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.BackScrollview addSubview:self.publishTableView];
    [self.publishTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.equalTo(self.BackScrollview);
        make.width.mas_equalTo(MainView_Width);
    }];
    //消息
    self.collectionTableView = [[UITableView alloc]init];
    self.collectionTableView.delegate = self;
    self.collectionTableView.dataSource = self;
    self.collectionTableView.backgroundColor = [UIColor clearColor];
    self.collectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.BackScrollview addSubview:self.collectionTableView];
    [self.collectionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.BackScrollview);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(MainView_Width);
        make.left.equalTo(self.publishTableView.mas_right);
    }];
    
    // 空白页面
    publishBlanView = [[WWBlankPageView alloc]initWithFrame:CGRectNull blankImg:[UIImage imageNamed:@"sleep"] blankTitle:@"忙着睡觉的他 还没发布帖子~"];
    [self.BackScrollview addSubview:publishBlanView];
    [publishBlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.equalTo(self.BackScrollview);
        make.width.mas_equalTo(MainView_Width);
    }];
    publishBlanView.hidden = YES;
    
    if (self.publishArray.count == 0) {
        publishBlanView.hidden = YES;
    }else{
        publishBlanView.hidden = NO;
    }
    // 空白页面
    collectionBlanView = [[WWBlankPageView alloc]initWithFrame:CGRectNull blankImg:[UIImage imageNamed:@"sleep"] blankTitle:@"忙着睡觉的他 还没收藏帖子~"];
    [self.BackScrollview addSubview:collectionBlanView];
    [collectionBlanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.BackScrollview);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(MainView_Width);
        make.left.equalTo(self.publishTableView.mas_right);
    }];
    collectionBlanView.hidden = YES;
    
    if (self.collectionArray.count == 0) {
        collectionBlanView.hidden = YES;
    }else{
        collectionBlanView.hidden = NO;
    }
    
    self.publishArray = [[NSMutableArray alloc]init];
    self.collectionArray = [[NSMutableArray alloc]init];
    [self loadData];
}
#pragma mark -----
#pragma mark ----- UITableViewDataSource
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.publishTableView) {
        return self.publishArray.count;
    }else{
        return self.collectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == self.publishTableView) {
        static NSString *cellIdentifier = @"publichCell";
        //
        WWPublishTableViewCell *cell = [[WWPublishTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[WWPublishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        WWHomePageModel * model = self.publishArray[indexPath.row];
        cell.deleteButton.hidden = YES;
        [cell publishData:model is_Type:YES];
        model.height = [cell rowHeight];
        return cell;
    }else{
        static NSString *cellIdentifier = @"collectionCell";
        //
        WWPublishTableViewCell *cell = [[WWPublishTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[WWPublishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        WWHomePageModel * model = self.collectionArray[indexPath.row];
        cell.deleteButton.hidden = YES;
        [cell publishData:model is_Type:NO];
        model.height = [cell rowHeight];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.publishTableView) {
        WWHomePageModel * model = self.publishArray[indexPath.row];
        return model.height;
    }else{
        WWHomePageModel * model = self.collectionArray[indexPath.row];
        return model.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)chooseClick:(UIButton *)sender{
    if (sender.tag == 1001) {
        publishBtn.selected = YES;
        collectionBtn.selected = NO;
        [chooseLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@2);
            make.bottom.equalTo(chooseView.mas_bottom).offset(-0.5);
            make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(0.5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.BackScrollview.contentOffset = CGPointMake(0, 0);
        }];
        
    }else{
        publishBtn.selected = NO;
        collectionBtn.selected = YES;
        [chooseLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@2);
            make.bottom.equalTo(chooseView.mas_bottom).offset(-0.5);
            make.centerX.equalTo(chooseView.mas_centerX).multipliedBy(1.5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.BackScrollview.contentOffset = CGPointMake(MainView_Width, 0);
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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadData{
    WWHomePageModel * model01 = [[WWHomePageModel alloc]init];
    model01.strUserHead = @"testHeadView";
    model01.strUserNickName = @"黄小军";
    model01.strTitle = @"就让时光消逝吧";
    model01.strDesc = @"如果过去的时光消逝了，那就让他随风而去吧，只是。让我很难过.";
    model01.strImageContent = @"testqiu01";
    model01.strTag = @"时光";
    model01.strTime = @"06-22 12:13";
    
    model01.strFavtionNum = @"998";
    model01.strCollectNum = @"198";
    model01.strShareNum = @"78";
    model01.strCommitNum = @"698";
    [self.collectionArray addObject:model01];
    [self.publishArray addObject:model01];
    
    WWHomePageModel * model02 = [[WWHomePageModel alloc]init];
    model02.strUserHead = @"testqiu05";
    model02.strUserNickName = @"天和";
    model02.strTitle = @"一叶知秋";
    model02.strImageContent = @"testqiu03";
    model02.strTag = @"一次心灵的路程";
    model02.strTime = @"06-22 12:13";
    
    model02.strFavtionNum = @"998";
    model02.strCollectNum = @"198";
    model02.strShareNum = @"78";
    model02.strCommitNum = @"698";
    [self.collectionArray addObject:model02];
     [self.publishArray addObject:model02];
    
    
    WWHomePageModel * model03 = [[WWHomePageModel alloc]init];
    model03.strUserHead = @"testqiu05";
    model03.strUserNickName = @"大狸子";
    model03.strImageContent = @"testqiu04";
    model03.strTitle = @"真希望你们好好地";
    model03.strTag = @"大水笔";
    model03.strTime = @"06-22 12:13";
    
    model03.strFavtionNum = @"998";
    model03.strCollectNum = @"198";
    model03.strShareNum = @"78";
    model03.strCommitNum = @"698";
    
    [self.collectionArray addObject:model03];
     [self.publishArray addObject:model03];
    
    
    WWHomePageModel * model04 = [[WWHomePageModel alloc]init];
    model04.strUserHead = @"testHeadView";
    model04.strUserNickName = @"大狸子";
    model04.strImageContent = @"testqiu02";
    model04.strTitle = @"毕业了";
    model04.strTag = @"大水笔";
    model04.strTime = @"06-22 12:13";
    
    model04.strFavtionNum = @"998";
    model04.strCollectNum = @"198";
    model04.strShareNum = @"78";
    model04.strCommitNum = @"698";
    
    [self.collectionArray addObject:model04];
     [self.publishArray addObject:model04];
    
    
    WWHomePageModel * model05 = [[WWHomePageModel alloc]init];
    model05.strUserHead = @"testqiu05";
    model05.strUserNickName = @"阿萨德";
    model05.strTitle = @"真希望你们好好地";
    model05.strDesc = @"毕业了";
    model05.strTag = @"回忆";
    model05.strTime = @"06-22 12:13";
    
    model05.strFavtionNum = @"998";
    model05.strCollectNum = @"198";
    model05.strShareNum = @"78";
    model05.strCommitNum = @"698";
    [self.collectionArray addObject:model05];
     [self.publishArray addObject:model05];
    
    [self.collectionTableView reloadData];
    [self.publishTableView reloadData];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [self.view layoutIfNeeded];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
