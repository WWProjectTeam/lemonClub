//
//  FileViewController.m
//  Carcorder
//
//  Created by L on 15/10/10.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "FileViewController.h"
#import "MRImgShowView.h"

@interface FileViewController ()

@end

@implementation FileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.891 alpha:1.000];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%d.png", (int)current]];
    self.title = @"截屏管理";
    
    RButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RButton.frame = CGRectMake(0, 0, 50, 40);
    //  [RButton setBackgroundImage:[UIImage imageNamed:@"tj"] forState:UIControlStateNormal];
    [RButton setTitle:@"管理" forState:UIControlStateNormal];
    [RButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [RButton addTarget:self action:@selector(btnadd:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:RButton];
    self.navigationItem.rightBarButtonItem = rightButton;
  
    
    _myscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kScreen_width, kScreen_height)];
    _myscrollview.directionalLockEnabled = YES; //只能一个方向滑动
    _myscrollview.pagingEnabled = NO; //是否翻页
    _myscrollview.backgroundColor = [UIColor colorWithRed:0.918 green:0.922 blue:0.941 alpha:1.000];
    _myscrollview.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _myscrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _myscrollview.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _myscrollview.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    [_myscrollview setContentSize:newSize];
    
    arrStr=[[NSMutableArray alloc] initWithCapacity:0];
    [self.view addSubview:_myscrollview];
    [self imageview];
}

#pragma 管理图片视频
- (void)btnadd:(UIButton *)sender
{
//    for (bgview in _myscrollview.subviews)
//    {
//        [bgview removeFromSuperview];
//    }
    
    RButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RButton.frame = CGRectMake(0, 0, 50, 40);
    //    [RButton setBackgroundImage:[UIImage imageNamed:@"tj"] forState:UIControlStateNormal];
    [RButton setTitle:@"删除" forState:UIControlStateNormal];
    [RButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [RButton addTarget:self action:@selector(btndel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:RButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    #pragma 最终版图片显示路径 做了判断不同设备存储目录问题
    NSString *nameSTTT = [USER objectForKey:@"uniqId"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", nameSTTT]];   // 保存文件的名称
    
    
    NSArray *files = [fileManager subpathsAtPath: filePath ];
    if (files.count>0)
    {
        NSString *imgStr11 =files[0];
        NSString *towStr = @".DS_Store";
        reversedArray = [[files reverseObjectEnumerator] allObjects];//倒叙数组files
        if([imgStr11 isEqual:towStr])
        {
            for (int i =0 ; i<=reversedArray.count-1; i++)
            {
                UIView *bgview1 = [[UIView alloc]init];
                bgview1.frame = CGRectMake( 0, (i)*(kScreen_height/6 +20)+10, kScreen_width, kScreen_height/6+10);
                bgview1.backgroundColor = [UIColor whiteColor];
                
                _myscrollview.contentSize = CGSizeMake(self.view.frame.size.width, (bgview.height*(i+1))+(i+2)*10);
                [_myscrollview addSubview:bgview1];
                
                NSString *imgStr =reversedArray[i];
                NSString *iamStr = @"/";
                NSString *wwe =[iamStr stringByAppendingString:imgStr ];
                NSLog(@"%@",filePath);
                NSString *StrStarTime  = [filePath stringByAppendingString:wwe ];
                UIImage *img = [UIImage imageWithContentsOfFile:StrStarTime];
                imgView = [[UIImageView alloc]init];
                imgView.image = img;
                imgView.frame = CGRectMake(10, 10, bgview1.width /3, bgview1.height-20);
                [bgview1 addSubview:imgView];
                
                nameStr = [[UILabel alloc]init];
                nameStr.text = imgStr;
                nameStr.frame = CGRectMake(imgView.right +10, 2, bgview1.width-(bgview1.width /3+20), 60);
                [bgview1 addSubview:nameStr];
                
                /*
                if (iPhone6) {
                    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    messageBtn.frame = CGRectMake(imgView.right+5, nameStr.bottom , 70, 70);
                    messageStr = @"n";
                    messageBtn.tag = i+1000;
                    [messageBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                    [messageBtn setImage:[UIImage imageNamed:@"8"] forState:UIControlStateSelected];
                    //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                    [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [bgview1 addSubview:messageBtn];
                }
                if (iPhone5) {
                    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    messageBtn.frame = CGRectMake(imgView.right+5, nameStr.bottom , 50, 50);
                    messageStr = @"n";
                    messageBtn.tag = i+1000;
                    [messageBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                    [messageBtn setImage:[UIImage imageNamed:@"8"] forState:UIControlStateSelected];
                    //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                    [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [bgview1 addSubview:messageBtn];
                }
                 */
                
                UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                messageBtn.frame = CGRectMake(imgView.right+5, nameStr.bottom , 50, 50);
                messageStr = @"n";
                messageBtn.tag = i+1000;
                [messageBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                [messageBtn setImage:[UIImage imageNamed:@"8"] forState:UIControlStateSelected];
                //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgview1 addSubview:messageBtn];
                
                
            }
        }
        else
        {
            for (int i =0 ; i<=reversedArray.count-1; i++)
            {
                
                UIView *bgview1 = [[UIView alloc]init];
                bgview1.frame = CGRectMake( 0, i*(kScreen_height/6 +20)+10, kScreen_width, kScreen_height/6+10);
                bgview1.backgroundColor = [UIColor whiteColor];
                
                _myscrollview.contentSize = CGSizeMake(self.view.frame.size.width, (bgview.height*(i+1))+(i+2)*10);
                [_myscrollview addSubview:bgview1];
                
                NSString *imgStr =reversedArray[i];
                NSString *iamStr = @"/";
                NSString *wwe =[iamStr stringByAppendingString:imgStr ];
                NSLog(@"%@",filePath);
                NSString *StrStarTime  = [filePath stringByAppendingString:wwe ];
                UIImage *img = [UIImage imageWithContentsOfFile:StrStarTime];
                imgView = [[UIImageView alloc]init];
                imgView.image = img;
                imgView.frame = CGRectMake(10, 10, bgview1.width /3, bgview1.height-20);
                [bgview1 addSubview:imgView];
                
                nameStr = [[UILabel alloc]init];
                //nameStr.text = imgStr;  zyb
                nameStr.text = [self formatFileName:imgStr];
                nameStr.frame = CGRectMake(imgView.right +10, 2, bgview1.width-(bgview1.width /3+20), 60);
                [bgview1 addSubview:nameStr];
               
                /*
                if (iPhone6) {
                    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    messageBtn.frame = CGRectMake(imgView.right+5, nameStr.bottom , 70, 70);
                    messageStr = @"n";
                    messageBtn.tag = i+1000;
                    [messageBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                    [messageBtn setImage:[UIImage imageNamed:@"8"] forState:UIControlStateSelected];
                    //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                    [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [bgview1 addSubview:messageBtn];
                }
                if (iPhone5) {
                    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    messageBtn.frame = CGRectMake(imgView.right+5, nameStr.bottom , 50, 50);
                    messageStr = @"n";
                    messageBtn.tag = i+1000;
                    [messageBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                    [messageBtn setImage:[UIImage imageNamed:@"8"] forState:UIControlStateSelected];
                    //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                    [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [bgview1 addSubview:messageBtn];
                }
                 */
                
                UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                messageBtn.frame = CGRectMake(imgView.right+5, nameStr.bottom , 50, 50);
                messageStr = @"n";
                messageBtn.tag = i+1000;
                [messageBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
                [messageBtn setImage:[UIImage imageNamed:@"8"] forState:UIControlStateSelected];
                //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                [messageBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgview1 addSubview:messageBtn];
            }
        }
    }
}

- (id)initWithSourceData:(NSMutableArray *)data withIndex:(NSInteger)index
{
    
    self = [super init];
    if (self)
    {
        //[self init];
        _data = data;
        _index = index;
    }
    return self;
    
}

- (void)imgadd:(UIButton *)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    #pragma 最终版图片显示路径 做了判断不同设备存储目录问题
    NSString *nameSTTT = [USER objectForKey:@"uniqId"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@/", nameSTTT]];// 保存文件的名称
    
    NSArray *files = [fileManager subpathsAtPath: filePath ];
    reversedArray = [[files reverseObjectEnumerator] allObjects];//倒叙数组files
    NSMutableArray *imgList = [NSMutableArray arrayWithCapacity:reversedArray.count];
    NSString *imgStr11 =files[0];
    NSString *towStr = @".DS_Store";
    reversedArray = [[files reverseObjectEnumerator] allObjects];//倒叙数组files
//    if([imgStr11 isEqual:towStr])
//    {
        for (int i = 0; i <= reversedArray.count-1; i++)
        {
            if ([imgStr11 isEqualToString:towStr])
                continue;
        //NSString *imgStr =reversedArray[i];
        //NSString *iamStr = @"/";
        //NSString *wwe =[iamStr stringByAppendingString:imgStr ];
        //NSString *StrStarTime  = [filePath stringByAppendingString:wwe ];
            NSString *StrStarTime = [NSString stringWithFormat:@"%@/%@", filePath, reversedArray[i]];
            UIImage *img = [UIImage imageWithContentsOfFile:StrStarTime];
            [imgList addObject:img];
        }
        
        NSMutableArray *dau = [NSMutableArray arrayWithObjects:0, nil];
        [dau addObjectsFromArray:reversedArray];
        MRImgShowView *imgShowView = [[MRImgShowView alloc] initWithFrame:self.view.frame withSourceData:imgList withIndex:1];
        
        // 解决谦让
        [imgShowView requireDoubleGestureRecognizer:[[self.view gestureRecognizers] lastObject]];
        
        winview22 = [[UIView alloc]init];
        winview22.frame = CGRectMake(0, 0, kScreen_width,kScreen_height);
        winview22.backgroundColor = [UIColor blackColor];
        [self.view addSubview:winview22];
        [winview22 addSubview:imgShowView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(kScreen_width-55, 0 , 35, 35);
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        // messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
        [closeBtn addTarget:self action:@selector(closeClick:)
           forControlEvents:UIControlEventTouchUpInside];
        [winview22 addSubview:closeBtn];
//    }
        /*else{
                for (int i = 0; i < reversedArray.count-1; i++) {
                    NSString *imgStr =reversedArray[i];
                    NSString *iamStr = @"/";
                    NSString *wwe =[iamStr stringByAppendingString:imgStr ];
                    NSString *StrStarTime  = [filePath stringByAppendingString:wwe ];
                    UIImage *img = [UIImage imageWithContentsOfFile:StrStarTime];
        //            UIImage *imgMod = reversedArray[i];
                    [imgList addObject:img];
                }
                
                NSMutableArray *dau = [NSMutableArray arrayWithObjects:0, nil];
                [dau addObjectsFromArray:reversedArray];
                MRImgShowView *imgShowView = [[MRImgShowView alloc]
                                              initWithFrame:self.view.frame
                                              withSourceData:imgList
                                              withIndex:0];
                
        //        winview = [[UIView alloc]init];
        //        winview.frame = CGRectMake(0, 0, kScreen_width,100);
        //        winview.backgroundColor = [UIColor blackColor];
        //        [self.view addSubview:winview];
        //        
        //
                // 解决谦让
                [imgShowView requireDoubleGestureRecognizer:[[self.view gestureRecognizers] lastObject]];
                
                winview22 = [[UIView alloc]init];
                winview22.frame = CGRectMake(0, 0, kScreen_width,kScreen_height);
                winview22.backgroundColor = [UIColor blackColor];
                [self.view addSubview:winview22];
                [winview22 addSubview:imgShowView];
                UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                closeBtn.frame = CGRectMake(kScreen_width-55, 0 , 35, 35);
                [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
                        //        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(-0, -20, -0, -0);
                [closeBtn addTarget:self
                             action:@selector(closeClick:)
                   forControlEvents:UIControlEventTouchUpInside];
                [winview22 addSubview:closeBtn];
            } */
}

#pragma mark -UIGestureReconginzer
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // 隐藏导航栏
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    }];
    
}

#pragma mark -NavAction
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeClick:(UIButton *)sender
{
    [winview22 removeFromSuperview];
//    [MRImgShowView  colse];
//    [self.view re]
    
}

- (void)btndel:(UIButton *)sender
{
//    NSString *pngDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSString *FileDir = [NSString stringWithFormat:@"%@/AnnexFiles", pngDir];
//    NSError *err;
//    [fileMgr createDirectoryAtPath:FileDir withIntermediateDirectories:YES attributes:nil error:&err];
//    NSString *FileFullPath = [FileDir stringByAppendingPathComponent:[DBTopicAnnexData Name]];
//    BOOL bRet = [fileMgr fileExistsAtPath:FileFullPath];
//    if (bRet) {
//        //
//        NSError *err;
//        [fileMgr removeItemAtPath:FileFullPath error:&err];
//    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *nameSTTT = [USER objectForKey:@"uniqId"];
    
    if (arrStr.count >0)
    {
        for (int i=0; i<arrStr.count; i++)
        {
            NSString *imgStr =arrStr[i];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", nameSTTT,imgStr]];   // 保存文件的名称
            [fileManager removeItemAtPath:filePath error:nil];
            
            RButton = [UIButton buttonWithType:UIButtonTypeCustom];
            RButton.frame = CGRectMake(0, 0, 50, 40);
            //[RButton setBackgroundImage:[UIImage imageNamed:@"tj"] forState:UIControlStateNormal];
            [RButton setTitle:@"管理" forState:UIControlStateNormal];
            [RButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [RButton addTarget:self action:@selector(btnadd:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:RButton];
            self.navigationItem.rightBarButtonItem = rightButton;
        }
        
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"文件删除成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        for (bgview in _myscrollview.subviews)
        {
            [bgview removeFromSuperview];
        }
        [self imageview];
    }
    else
    {
        NSLog(@"无文件删除");
    }
}

-(void)imageview
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    #pragma 最终版图片显示路径 做了判断不同设备存储目录问题
    // NSString *ddd = @"Documents/";
    NSString *nameSTTT = [USER objectForKey:@"uniqId"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@/", nameSTTT]];   // 保存文件的名称
    NSArray *files = [fileManager subpathsAtPath: filePath ];
    // 保存文件的名称

    if (files.count > 0)
    {
        NSString *imgStr11 =files[0];
        NSString *towStr = @".DS_Store";
        //NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",nil];
        reversedArray = [[files reverseObjectEnumerator] allObjects];
//        if([imgStr11 isEqual:towStr])
//        {
            for (int i = 0; i<reversedArray.count; i++)
            {
                //NSDictionary *dic = files[i];
                if ([imgStr11 isEqualToString:towStr])
                    continue;
                bgview = [[UIView alloc]init];
                bgview.frame = CGRectMake(0, (i)*(kScreen_height/6 +20)+10, kScreen_width, kScreen_height/6+10);
                bgview.backgroundColor = [UIColor whiteColor];
                
                _myscrollview.contentSize = CGSizeMake(self.view.frame.size.width, (bgview.height*(i+1))+(i+2)*10);
                [_myscrollview addSubview:bgview];
                
                NSString *imgStr =reversedArray[i];
                NSString *iamStr = @"/";
                NSString *wwe =[iamStr stringByAppendingString:imgStr ];
                NSLog(@"%@",filePath);
                NSString *StrStarTime  = [filePath stringByAppendingString:wwe ];
                UIImage *img = [UIImage imageWithContentsOfFile:StrStarTime];
                imgView = [[UIImageView alloc]init];
                imgView.image = img;
                imgView.frame = CGRectMake(10, 10, bgview.width /3, bgview.height-20);
                [bgview addSubview:imgView];
                
                UIButton *imgbtn = [[UIButton alloc]init];
                imgbtn.frame = CGRectMake(0, 0, bgview.width, bgview.height);
                [imgbtn addTarget:self action:@selector(imgadd:) forControlEvents:UIControlEventTouchUpInside];
                imgbtn.backgroundColor = [UIColor clearColor];
                [bgview addSubview:imgbtn];
                
                nameStr = [[UILabel alloc]init];
                //nameStr.text = imgStr; zyb
                nameStr.text = [self formatFileName:imgStr];
                nameStr.frame = CGRectMake(imgView.right +10, 2, bgview.width-(bgview.width /3+20), 60);
                [bgview addSubview:nameStr];
//            }
        }
        /*else{
            for (int i = 0; i<=reversedArray.count-1; i++) {
                //        NSDictionary *dic = files[i];
                bgview = [[UIView alloc]init];
                bgview.frame = CGRectMake(0, i*(kScreen_height/6 +20)+10,
                                          kScreen_width, kScreen_height/6+10);
                bgview.backgroundColor = [UIColor whiteColor];
                _myscrollview.contentSize = CGSizeMake(self.view.frame.size.width,
                                                       (bgview.height*(i+1))+(i+2)*10);
                [_myscrollview addSubview:bgview];

                NSString *imgStr =reversedArray[i];
                NSString *iamStr = @"/";
                NSString *wwe =[iamStr stringByAppendingString:imgStr ];
                NSLog(@"%@",filePath);
                NSString *StrStarTime  = [filePath stringByAppendingString:wwe ];
                UIImage *img = [UIImage imageWithContentsOfFile:StrStarTime];
                imgView = [[UIImageView alloc]init];
                imgView.image = img;
                imgView.frame = CGRectMake(10, 10, bgview.width /3, bgview.height-20);
                [bgview addSubview:imgView];
                
                UIButton *imgbtn = [[UIButton alloc]init];
                imgbtn.frame = CGRectMake(0, 0, bgview.width, bgview.height);
                [imgbtn addTarget:self action:@selector(imgadd:) forControlEvents:UIControlEventTouchUpInside];
                imgbtn.backgroundColor = [UIColor clearColor];
                [bgview addSubview:imgbtn];
                
                nameStr = [[UILabel alloc]init];
                //nameStr.text = imgStr;
                nameStr.text = [self formatFileName:imgStr];
                nameStr.frame = CGRectMake(imgView.right +10, 2,
                                           bgview.width-(bgview.width /3+20), 60);
                [bgview addSubview:nameStr];
            }
          
        } */
    }
    
    /*
    else
    {
        //UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"暂无图像数据！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[view show];
    }
    */
}

- (NSString *)formatFileName : (NSString *) fileName
{
    if (fileName == nil)
        return nil;

    // image name 年月日点分秒
    return  [NSString stringWithFormat:@"%@月%@日%@点%@分%@秒",
                [fileName substringWithRange:NSMakeRange(4, 2)],
                [fileName substringWithRange:NSMakeRange(6, 2)],
                [fileName substringWithRange:NSMakeRange(8, 2)],
                [fileName substringWithRange:NSMakeRange(10, 2)],
                [fileName substringWithRange:NSMakeRange(12, 2)]];
}

- (void)messageBtnClick:(id)sender
{
    //NSInteger tagStr = sender.tag;
    
    //int i = tagStr - 100;
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == NO)
    {
        btn.selected = YES;
        messageStr = @"y";
        NSInteger tagStr = btn.tag;
        int i = tagStr - 1000;
        imgStr =reversedArray[i];
        [arrStr addObject:imgStr];
        //arrStr = imgStr;
        NSLog(@"%@",messageStr);
    }
    else
    {
        btn.selected = NO;
        messageStr = @"n";
        NSLog(@"%@",messageStr);
    }
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
