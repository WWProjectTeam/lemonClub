//
//  WWHomePageViewController.m
//  newsmyEye
//
//  Created by ww on 16/7/26.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWHomePageViewController.h"
#import "WWLeftMenuView.h"
#import "WWHomePageTableViewCell.h"
#import "WWHomePageModel.h"
@interface WWHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
@private WWLeftMenuView * leftView;
    UITableView * tableViewPage;
    NSMutableArray * arrayList;
}

@end

@implementation WWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化左侧菜单
    leftView = [[WWLeftMenuView alloc]initWithFrame:CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [leftView setImageHeadUrl:_dicUserInfoFromQQ[@"figureurl_qq_2"]];
    [leftView setStrNickName:_dicUserInfoFromQQ[@"nickname"]];
    UIWindow * currentWindows = [UIApplication sharedApplication].keyWindow;
    [currentWindows addSubview:leftView];
    

    
    tableViewPage = [[UITableView alloc]init];
    [tableViewPage setDelegate:self];
    [tableViewPage setDataSource:self];
    [self.view addSubview:tableViewPage];
    [tableViewPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self.view);
    }];
    
    arrayList = [[NSMutableArray alloc]init];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action -- userCenter
-(void)enterUserCenter{
    [leftView showView];
}

-(void)addTips{

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    
    self.title = @"柠檬社";
    
    
    UIButton * userCenter = [[UIButton alloc]init];
    userCenter.frame=CGRectMake(0, 0, 22, 22);
    [userCenter setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [userCenter addTarget:self action:@selector(enterUserCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:userCenter];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    
    UIButton * submit = [[UIButton alloc]init];
    submit.frame=CGRectMake(0, 0, 22, 22);
    [submit setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(addTips) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:submit];
    self.navigationItem.rightBarButtonItem = rightButton;

}

#pragma mark - tableViewDelegate
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // return [self.arrReplyList count];
    
    return arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myCollect";
    //
    WWHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[WWHomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    WWHomePageModel * model = arrayList[indexPath.row];
    
    [cell.imgHead setImage:[UIImage imageNamed:model.strUserHead]];
    [cell.labelUserNickName setText:model.strUserNickName];
    [cell.btnTag setTitle:[NSString stringWithFormat:@" %@ ",model.strTag] forState:UIControlStateNormal];
    [cell.labelTitle setText:model.strTitle];
    
    //判断是否有描述
    if (model.strDesc) {
        [cell.labelDesc setHidden:NO];
        [cell.labelDesc setText:model.strDesc];
        
        //判断是否有图片
        if (model.strImageContent) {
            [cell.imgContent setImage:[UIImage imageNamed:model.strImageContent]];
            [cell.imgContent setHidden:NO];
        }
        else
        {
            [cell.imgContent setHidden:YES];
            
            [cell.labelTime mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.labelDesc.mas_bottomMargin).offset(10);
            }];
        }
    }
    else
    {
        [cell.labelDesc setHidden:YES];

        [cell.imgContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.labelTitle.mas_bottomMargin).offset(20);
        }];
        
        //判断是否有图片
        if (model.strImageContent) {
            [cell.imgContent setHidden:NO];
            [cell.imgContent setImage:[UIImage imageNamed:model.strImageContent]];
        }
        else
        {
            [cell.imgContent setHidden:YES];

            [cell.labelTime mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.labelTitle.mas_bottomMargin).offset(10);
            }];
            
        }
    }
    

    cell.labelTime.text = model.strTime;
    cell.labelLike.text= model.strFavtionNum;
    cell.labelShareNum.text = model.strShareNum;
    cell.labelCommentNum.text = model.strCommitNum;
    cell.labelCollectNum.text = model.strCollectNum;
    
    
    model.height = [cell rowHeight];
    
        return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWHomePageModel * model = arrayList[indexPath.row];

    return model.height;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
    [arrayList addObject:model01];
    
    
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

    
    [arrayList addObject:model02];
    

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
    
    [arrayList addObject:model03];
    
    
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
    
    [arrayList addObject:model04];
    
    
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
    
    [arrayList addObject:model05];
    
    [tableViewPage reloadData];
    
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

@end
