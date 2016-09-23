/*
 *       我的发布  赋值数组就ok  空白界面公用一个类
 */
//
//  WWMyPublishViewController.m
//  newsmyEye
//
//  Created by push on 16/9/11.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWMyPublishViewController.h"
#import "WWPublishTableViewCell.h"
#import "WWBlankPageView.h"

@interface WWMyPublishViewController ()<UITableViewDelegate,UITableViewDataSource>{
    WWBlankPageView *blankPageView;
}

@property (nonatomic,strong) UITableView    *publishTableView;
@property (nonatomic,strong) NSMutableArray *publishDataArray;

@end

@implementation WWMyPublishViewController

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"我的发布";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton * submit = [[UIButton alloc]init];
    submit.frame=CGRectMake(0, 0, 22, 22);
    [submit setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(writeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:submit];
    self.navigationItem.rightBarButtonItem = rightButton;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.publishDataArray = [[NSMutableArray alloc]init];
    
    self.publishTableView = [[UITableView alloc]init];
    [self.publishTableView setDelegate:self];
    [self.publishTableView setDataSource:self];
    self.publishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.publishTableView];
    [self.publishTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self.view);
    }];
    
    blankPageView = [[WWBlankPageView alloc]initWithFrame:CGRectNull blankImg:[UIImage imageNamed:@"none"] blankTitle:@"您还没有发表任何帖子哦~"];
    [self.view addSubview:blankPageView];
    [blankPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self.view);
    }];
    blankPageView.hidden = YES;
    
    if (self.publishDataArray.count == 0) {
        blankPageView.hidden = YES;
    }else{
        blankPageView.hidden = NO;
    }
    
    [self loadData];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [self.arrReplyList count];
    return self.publishDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myCollect";
    //
    WWPublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[WWPublishTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    WWHomePageModel * model = self.publishDataArray[indexPath.row];

    cell.deleteCell = ^(){
        NSLog(@"%ld", indexPath.row);
    };
    
    [cell publishData:model is_Type:YES];
    
    model.height = [cell rowHeight];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWHomePageModel * model = self.publishDataArray[indexPath.row];
    
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 返回喽
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

// 发布内容
- (void)writeButtonClick:(UIButton *)sender{
    
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
    [self.publishDataArray addObject:model01];
    
    
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
    
    
    [self.publishDataArray addObject:model02];
    
    
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
    
    [self.publishDataArray addObject:model03];
    
    
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
    
    [self.publishDataArray addObject:model04];
    
    
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
    
    [self.publishDataArray addObject:model05];
    
    [self.publishTableView reloadData];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [self.view layoutIfNeeded];
    
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //        [self.view layoutIfNeeded];
    //    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
