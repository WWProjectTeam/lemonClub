//
//  HeaderViewController.m
//  Carcorder
//
//  Created by YF on 16/1/15.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "HeaderViewController.h"
#import "CustomHeaderColCell.h"
#import "PreviewViewController.h"

@interface HeaderViewController ()

@end

@implementation HeaderViewController

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
    
    self.title=@"图片";
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] init];
    
    backBarItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backBarItem;
    
    _collection.showsVerticalScrollIndicator=NO;
    
    //_collection.bounces=NO;
    
    [_collection registerNib:[UINib nibWithNibName:@"CustomHeaderColCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomHeaderColCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
 
    [cell.headerBtn setBackgroundImage:[UIImage imageNamed:@"car.jpg"] forState:UIControlStateNormal];

    [cell.headerBtn addTarget:self action:@selector(headerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)headerBtnClick
{
    PreviewViewController *previewVC=[[PreviewViewController alloc] init];
    
    [self.navigationController pushViewController:previewVC animated:YES];
}

//设置元素的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((_collection.frame.size.width-10)/3, (_collection.frame.size.height-7*5)/8);
}

//元素列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

//元素行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

//上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
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
