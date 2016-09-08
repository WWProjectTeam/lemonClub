//
//  PhotoViewController.m
//  Carcorder
//
//  Created by YF on 16/1/7.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "PhotoViewController.h"
#import "MyPhotoTableViewCell.h"
#import "CheckViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Media.h"
#import <Photos/Photos.h>

@interface PhotoViewController ()
{
    NSMutableArray *albumArr;
}

@end

@implementation PhotoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title=@"相册";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};

    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc] init];
    
    backBarItem.title=@"返回";
    
    self.navigationItem.backBarButtonItem=backBarItem;
    
    
    albumArr=[NSMutableArray new];
    

    
    _table.rowHeight=200;
    
    _table.showsVerticalScrollIndicator=YES;
    
    _table.bounces=NO;
    
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_table registerNib:[UINib nibWithNibName:@"MyPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self reloadData];
}

-(void)reloadData{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library loadAssetsForProperty:NULL fromAlbum:@"纽眼" completion:^(NSMutableArray *array, NSError *error) {
        
        NSMutableArray * newlist = [[NSMutableArray alloc] init];
        for (Media * miediaModel  in [array reverseObjectEnumerator]) {
            
            [newlist addObject:miediaModel];
        }
        
        
        
        albumArr = [NSMutableArray arrayWithArray:newlist];
        
        NSLog(@"albumArr.count====%lu",(unsigned long)albumArr.count);
        
        [_table reloadData];
        
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return albumArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPhotoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Media *media=albumArr[indexPath.row];
    
    NSString *dateStr=[[media.dateAndTime componentsSeparatedByString:@" "] firstObject];
    
    cell.dateLab.text=dateStr;
    
    NSString *timeStr=[[media.dateAndTime componentsSeparatedByString:@" "] lastObject];
    
    cell.timeLab.text=timeStr;
    
    cell.timeLab.font=[UIFont boldSystemFontOfSize:16.0];

    
    UIImage * imageTemp = media.media;
    
    
    cell.photoImg.image=[self imageWithImage:imageTemp scaledToSize:CGSizeMake(225, 75)];
    
    
    
    NSString *mediaType=media.mediaType;
    
    if ([mediaType isEqualToString:@"ALAssetTypeVideo"])
    {
        [cell.playImg setHidden:NO];
        
        cell.playImg.image=[UIImage imageNamed:@"播放"];
        cell.photoImg.backgroundColor=[UIColor lightGrayColor];
    }
    else
    {
        [cell.playImg setHidden:YES];
    }
    
    cell.photoBtn.tag=indexPath.row;
    
    [cell.photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *layer=[cell.circleImg layer];
    
    layer.shadowColor=[[UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:0.7] CGColor];
    
    layer.shadowOffset=CGSizeMake(2, 2);
    
    layer.shadowOpacity=0.8;
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    [cell.btnDel.layer setCornerRadius:3];
    [cell.btnDel.layer setBorderWidth:1];
    [cell.btnDel.layer setBorderColor:[UIColor colorWithRed:82/255.0 green:211/255.0 blue:199/255.0 alpha:1.0].CGColor];
    [cell.btnDel addTarget:self action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];;
    [cell.btnDel setTag:indexPath.row];
    return cell;
}


-(void)delPhoto:(UIButton *)sender{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请在相册-纽眼中删除" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
    
//    Media *media=albumArr[sender.tag];
//    
//    PHFetchResult *pAsset = [PHAsset fetchAssetsWithLocalIdentifiers:[media.alasset valueForProperty:ALAssetPropertyLocation] options:nil];
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        [PHAssetChangeRequest deleteAssets:pAsset];
//    } completionHandler:^(BOOL success, NSError *error) {
//
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//                           if (success) {
//                               [self reloadData];
//                           }
//                           
////                           if(callBack)
////                               callBack(success);
//                       });
//    }];
    
    
    
//    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
//    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        PHAssetCollection *assetCollection = obj;
//        NSLog(assetCollection.localizedTitle);
//        if ([assetCollection.localizedTitle isEqualToString:@"纽眼"])  {
//            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
//            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                    //获取相册的最后一张照片
//                    if (idx == sender.tag) {
//                        [PHAssetChangeRequest deleteAssets:@[obj]];
//                    }
//                } completionHandler:^(BOOL success, NSError *error) {
//                    NSLog(@"Error: %@", error);
//                }];
//            }];
//        }
//    }];

}

-(void)photoBtnClick:(UIButton *)button
{
    CheckViewController *checkVC=[[CheckViewController alloc] init];
    
    Media *media=albumArr[button.tag];
    
    if([media.mediaType isEqualToString: @"ALAssetTypePhoto"])
    {
        checkVC.mediaImg=media.media;
    }
    
    checkVC.mediaUrl=media.mediaURL;
    
    [self.navigationController pushViewController:checkVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSelector:@selector(unselectCell:) withObject:nil afterDelay:0.5];
 
}

-(void)unselectCell:(id)sender
{
    [_table deselectRowAtIndexPath:[_table indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
