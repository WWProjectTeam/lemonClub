//
//  WWPublishViewController.m
//  newsmyEye
//
//  Created by push on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWPublishViewController.h"
#import "WWChoosePublishListViewController.h"
#import "TZImagePickerController.h"

@interface WWPublishViewController ()<TZImagePickerControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UILabel *tagContent;
    NSString *tagStr;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic,strong) NSMutableArray     *selectImageArray;
@property (nonatomic,strong) UIView             *photoView;             // 上传照片
@property (nonatomic,strong) UIButton           *lemonImage;          // 上传照片按钮
@property (nonatomic,strong) NSMutableArray     *lemonImageArray; // 图片数组

@end

@implementation WWPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(239, 239, 246);
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"发布帖子";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton * submit = [[UIButton alloc]init];
    submit.frame=CGRectMake(0, 0, 22, 22);
    [submit setImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:submit];
    
    UIButton * photo = [[UIButton alloc]init];
    photo.frame=CGRectMake(0, 0, 22, 22);
    [photo setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
    [photo addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithCustomView:photo];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc]initWithObjects:rightButton,rightButton1,nil];
    
    self.lemonImageArray = [[NSMutableArray alloc]init];
    [self creatUI];
}

- (void)creatUI{
    // 选择标签
    UIView *tagClassView = [[UIView alloc]init];
    tagClassView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tagClassView];
    [tagClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@74);
        make.left.mas_equalTo(0);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@44);
    }];
    UIImageView *rightArrow = [[UIImageView alloc]init];
    rightArrow.image = [UIImage imageNamed:@"right-1"];
    [tagClassView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tagClassView.mas_centerY);
        make.right.equalTo(tagClassView.mas_right).offset(-17);
    }];
    UILabel *tagTitle = [[UILabel alloc]init];
    tagTitle.text = @"选择标签";
    tagTitle.textColor = WWContentTextColor;
    tagTitle.font = font_nonr_size(15);
    [tagClassView addSubview:tagTitle];
    [tagTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.centerY.equalTo(tagClassView.mas_centerY);
    }];
    tagContent = [[UILabel alloc]init];
    tagContent.textColor = btn_organ;
    tagContent.font = font_nonr_size(15);
    [tagClassView addSubview:tagContent];
    [tagContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightArrow.mas_left).offset(-5);
        make.centerY.equalTo(tagClassView.mas_centerY);
    }];
    UILabel *tagLine = [[UILabel alloc]init];
    tagLine.backgroundColor = RGBCOLOR(214, 215, 219);
    [tagClassView addSubview:tagLine];
    [tagLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(tagClassView.mas_bottom).offset(-0.5);
    }];
    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tagButton addTarget:self action:@selector(chooseTag) forControlEvents:UIControlEventTouchUpInside];
    [tagClassView addSubview:tagButton];
    [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(tagClassView);
    }];
    
    //标题
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagClassView.mas_bottom);
        make.width.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    self.titleTextView = [[UITextView alloc]init];
    self.titleTextView.backgroundColor = [UIColor clearColor];
    self.titleTextView.textColor = WWContentTextColor;
    self.titleTextView.font = font_nonr_size(17);
    self.titleTextView.delegate = self;
    self.titleTextView.returnKeyType = UIReturnKeyDone;
    [titleView addSubview:self.titleTextView];
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagClassView.mas_bottom);
        make.left.equalTo(@15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(80);
    }];
    self.titlePlaceholder = [[UILabel alloc]init];
    self.titlePlaceholder.textColor = WWSubTitleTextColor;
    self.titlePlaceholder.font =[UIFont systemFontOfSize:17.0f];
    self.titlePlaceholder.text = @"输入标题";
    [self.titleTextView addSubview:self.titlePlaceholder];
    [self.titlePlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.top.mas_equalTo(9);
        make.right.equalTo(self.titleTextView.mas_right).offset(-5);
    }];
    self.titleNum = [[UILabel alloc]init];
    self.titleNum.text = @"30";
    self.titleNum.textColor = WWSubTitleTextColor;
    self.titleNum.font = font_nonr_size(10);
    [titleView addSubview:self.titleNum];
    [self.titleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleTextView.mas_right).offset(-5);
        make.bottom.equalTo(self.titleTextView.mas_bottom).offset(-10);
    }];
    UILabel *titleLine = [[UILabel alloc]init];
    titleLine.backgroundColor = RGBCOLOR(214, 215, 219);
    [titleView addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(titleView.mas_bottom).offset(-0.5);
    }];
    //内容
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(200);
        //        make.bottom.equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.equalTo(self.view);
    }];
    self.contentTextView = [[UITextView alloc]init];
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.textColor = WWContentTextColor;
    self.contentTextView.font = font_nonr_size(17);
    self.contentTextView.delegate = self;
    self.contentTextView.returnKeyType = UIReturnKeyDone;
    [contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(@15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(contentView);
    }];
    self.contentPlaceholder = [[UILabel alloc]init];
    self.contentPlaceholder.textColor = WWSubTitleTextColor;
    self.contentPlaceholder.font =[UIFont systemFontOfSize:17.0f];
    self.contentPlaceholder.text = @"把你想说的分享给大家吧......";
    [self.contentTextView addSubview:self.contentPlaceholder];
    [self.contentPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.top.mas_equalTo(9);
        make.right.equalTo(self.contentTextView.mas_right).offset(-5);
    }];
    UILabel *contentLine = [[UILabel alloc]init];
    contentLine.backgroundColor = RGBCOLOR(214, 215, 219);
    [contentView addSubview:contentLine];
    [contentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(contentView.mas_bottom).offset(-0.5);
    }];
    // 上传病历
    self.photoView = [[UIView alloc]init];
    self.photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoView];
   
    self.lemonImage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lemonImage.frame = CGRectMake(10, 10, 50, 50);
    [self.lemonImage setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
    [self.lemonImage addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoView addSubview:self.lemonImage];
    [self.lemonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.top.mas_equalTo(10);
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(contentView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.lemonImage.mas_bottom).offset(10);
    }];

}

// 选择标签
- (void)chooseTag{
    WWChoosePublishListViewController *publishVC = [[WWChoosePublishListViewController alloc]init];
    publishVC.cellSelectBlock = ^(NSString *name ,NSString *tagIndex){
        tagContent.text = name;
        tagStr = tagIndex;
    };
    publishVC.is_select = tagStr;
    [self.navigationController pushViewController:publishVC animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.contentTextView) {
        int number = (textView.text.length-range.length+text.length) > 0 ? (int)(textView.text.length-range.length+text.length):0;
        if ([text isEqualToString:@"\n"]) {
            if (number -1 > 0) {
                self.contentPlaceholder.hidden = YES;
            }else{
                self.contentPlaceholder.hidden = NO;
            }
            [textView resignFirstResponder];
            return NO;
        }
        if (number != 0) {
            self.contentPlaceholder.hidden = YES;
        }else{
            self.contentPlaceholder.hidden = NO;
        }
        
        return YES;
    }else{
        int number = (textView.text.length-range.length+text.length) > 0 ? (int)(textView.text.length-range.length+text.length):0;
        self.titleNum.text = [NSString stringWithFormat:@"%d",30-number];
        if (textView.text.length-range.length+text.length >= 30) {
            [SVProgressHUD showInfoWithStatus:@"不能超过30字哦！"];
            return NO;
        }
        if ([text isEqualToString:@"\n"]) {
            if ([self.titleNum.text intValue]-1 > 0) {
                self.titlePlaceholder.hidden = YES;
            }else{
                self.titlePlaceholder.hidden = NO;
            }
            [textView resignFirstResponder];
            return NO;
        }
        if (![self.titleNum.text isEqualToString:@"30"]) {
            self.titlePlaceholder.hidden = YES;
        }else{
            self.titlePlaceholder.hidden = NO;
        }
        return YES;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

// 提交
- (void)submit{
    
}

- (void)addPicture{
    
}

// 退出
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----
#pragma mark ---- 图片选择
- (void)addImageButtonClick:(UIButton *)sender{
    [self.view endEditing:YES];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = self.selectImageArray; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.lemonImageArray = [[NSMutableArray alloc]initWithArray:photos];
        self.selectImageArray = [NSMutableArray arrayWithArray:assets];
        [self addPhotoImageView];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark ----
#pragma mark ---- 添加照片
- (void)addPhotoImageView{
    
    [self.photoView removeAllSubviews];
    //定义每个cell图片
    UIButton *lastButton = nil;
    for (int i=0;i<self.lemonImageArray.count;i++){
        int rowNum = i %4 ==0? i/4:i/4 +1;
        NSLog(@"%d%d%d",i %4,i /4,rowNum);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:self.lemonImageArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(longPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(50);
            if (i%4 == 0) {
                make.left.mas_equalTo(10);
                
            }else{
                if (lastButton) {
                    make.left.equalTo(lastButton.mas_right).offset(10);
                }else{
                    make.left.mas_equalTo(10);
                }
            }
            switch (i/4) {
                case 0:
                    make.top.mas_equalTo(10);
                    break;
                case 1:
                    make.baseline.equalTo(lastButton.mas_bottom).offset(10);
//                    make.top.equalTo(lastButton.mas_bottom).offset(10);
                    break;
                case 2:
                    make.top.equalTo(lastButton.mas_bottom).offset(10);
                    break;
                case 3:
                    make.top.equalTo(lastButton.mas_bottom).offset(10);
                    break;
                default:
                    break;
            }
            
//            if (i%4 == 0) {
//                if (lastButton) {
//                    make.top.equalTo(lastButton.mas_bottom).offset(10);
//                }else{
//                    make.top.mas_equalTo(10);
//                }
//            }else{
//                
//            }
        }];
        
        lastButton = button;
        
    }
    self.lemonImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lemonImage setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
    [self.lemonImage addTarget:self action:@selector(addImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoView addSubview:self.lemonImage];
    
    [self.lemonImage mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.lemonImageArray.count >= 4) {
            make.top.equalTo(lastButton.mas_bottom).offset(10);
        }else{
            make.top.mas_equalTo(10);
        }
        if (self.lemonImageArray.count % 4 == 0) {
            make.left.mas_equalTo(10);
        }else{
            make.left.equalTo(lastButton.mas_right).offset(10);
        }
    }];
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lemonImage.mas_bottom).offset(10);
    }];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

    
    if (self.lemonImageArray.count >= 9) {
        self.lemonImage.hidden = YES;
    }else{
        self.lemonImage.hidden = NO;
    }
}

// 长按添加删除按钮
- (void)longPress : (UIButton *)gester
{
    UIButton *btn = (UIButton *)gester;
    UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
    dele.bounds = CGRectMake(10, 10, 30, 30);
    [dele setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
    //    dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
    dele.frame = CGRectMake(15, 15, 20, 20);
    [btn addSubview:dele];
    [self start : btn];
}

// 长按开始抖动
- (void)start : (UIButton *)btn {
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle1),  @(angle2), @(angle1)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [btn.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stop : (UIButton *)btn{
    [btn.layer removeAnimationForKey:@"shake"];
}
// 删除图片
- (void)deletePic : (UIButton *)btn{
    [self.lemonImageArray removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
    [self.selectImageArray removeObjectAtIndex:btn.tag];
    [btn.superview removeFromSuperview];
    [self addPhotoImageView];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
