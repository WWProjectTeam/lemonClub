/*
 编辑资料数据传值  是  nameTextField。text
                    labelBirthday
                    labelSex
 */
//
//  WWEditInformationViewController.m
//  newsmyEye
//
//  Created by songs on 16/9/21.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#import "WWEditInformationViewController.h"

@interface WWEditInformationViewController (){
    UIView *shadowView;
    UIButton *shadowButton;
    
    UITextField *nameTextField;
    UILabel *labelBirthday;
    UILabel *labelSex;
}

@end

@implementation WWEditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 恢复导航条
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font_nonr_size(19),NSForegroundColorAttributeName:WWOrganText}];
    self.title = @"编辑资料";
    
    UIButton * goBack = [[UIButton alloc]init];
    goBack.frame=CGRectMake(0, 0, 22, 22);
    [goBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:goBack];
    self.navigationItem.leftBarButtonItem = leftButton;

    
    [self creatUI];
    
}

- (void)creatUI{
    imageViewHead = [[UIImageView alloc]init];
    [imageViewHead setImage:[UIImage imageNamed:@"photo--default"]];
    imageViewHead.layer.cornerRadius = 38.0f;
    imageViewHead.layer.masksToBounds = YES;
    [self.view addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@113);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@76);
        make.height.equalTo(@76);
    }];
    UIButton *imageHeadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [imageHeadButton addTarget:self action:@selector(imageHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageHeadButton];
    [imageHeadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@113);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@76);
        make.height.equalTo(@76);
    }];
    //昵称
    labelUserNickName = [[UILabel alloc]init];
    [labelUserNickName setFont:font_nonr_size(15)];
    [labelUserNickName setText:@"更换头像"];
    [labelUserNickName setTextAlignment:NSTextAlignmentCenter];
    [labelUserNickName setTextColor:RGBCOLOR(237, 200, 30)];
    [self.view addSubview:labelUserNickName];
    [labelUserNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(imageViewHead.mas_bottom).offset(15);
        make.height.equalTo(@15);
    }];
    
    NSArray *titleArr = @[@"昵称",@"生日",@"性别"];
    
    UIView *lastView = nil;
    for (int i=0; i<3; i++) {
        UIView *backView = [[UIView alloc]init];
        [self.view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.right.equalTo(self.view.mas_right).offset(-40);
            make.height.equalTo(@44);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.equalTo(labelUserNickName.mas_bottom).offset(75);
            }
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.text = titleArr[i];
        title.textColor = WWPlaceTextColor;
        title.font = font_nonr_size(15);
        [backView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView.mas_centerY);
            make.left.mas_equalTo(0);
        }];
        
        if (i == 0) {
            nameTextField = [[UITextField alloc]init];
            nameTextField.textColor = WWContentTextColor;
            nameTextField.font = font_nonr_size(15);
            nameTextField.placeholder = @"输入用户名称";
            [nameTextField setValue:WWContentTextColor forKeyPath:@"_placeholderLabel.textColor"];
            [backView addSubview:nameTextField];
            [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(30);
                make.top.mas_equalTo(0);
                make.height.equalTo(backView.mas_height);
                make.width.mas_equalTo(MainView_Width-40-80);
            }];
        }else if(i == 1){
            labelBirthday = [[UILabel alloc]init];
            labelBirthday.text = @"输入生日";
            labelBirthday.textColor = WWContentTextColor;
            labelBirthday.font = font_nonr_size(15);
            [backView addSubview:labelBirthday];
            [labelBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(30);
                make.top.mas_equalTo(0);
                make.height.equalTo(backView.mas_height);
                make.width.mas_equalTo(MainView_Width-40-80);
            }];
        }else{
            labelSex = [[UILabel alloc]init];
            labelSex.text = @"选择性别";
            labelSex.textColor = WWContentTextColor;
            labelSex.font = font_nonr_size(15);
            [backView addSubview:labelSex];
            [labelSex mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(30);
                make.top.mas_equalTo(0);
                make.height.equalTo(backView.mas_height);
                make.width.mas_equalTo(MainView_Width-40-80);
            }];
        }
        if (i>0) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1000+i;
            [backView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.width.height.equalTo(backView);
            }];
        }
        
        UIImageView *rightArrow = [[UIImageView alloc]init];
        rightArrow.image = [UIImage imageNamed: @"right2"];
        [backView addSubview:rightArrow];
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView.mas_centerY);
            make.right.equalTo(backView.mas_right);
        }];
       
        UILabel *bottomLine = [[UILabel alloc]init];
        bottomLine.backgroundColor = RGBCOLOR(214, 215, 219);
        [backView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(backView);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(backView.mas_bottom);
        }];
        
        lastView = backView;
    }
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = font_nonr_size(15);
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.backgroundColor = btn_organ;
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    
#pragma mark --- 阴影背景
    shadowView = [[UIView alloc]init];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.3;
    [self.view addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self.view);
    }];
    shadowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shadowButton addTarget:self action:@selector(shadowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shadowView addSubview:shadowButton];
    [shadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(shadowView);
    }];
    shadowView.hidden = YES;
#pragma mark --- // 选择view
    self.pickBackView = [[UIView alloc]init];
    self.pickBackView.layer.cornerRadius = 5.0f;
    self.pickBackView.layer.masksToBounds = YES;
    self.pickBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickBackView];
    [self.pickBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(MainView_Height);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(210);
    }];
    UIButton *canclePick = [[UIButton alloc]init];
    [canclePick setTitle:@"取消" forState:UIControlStateNormal];
    [canclePick setTitleColor:RGBCOLOR(95, 135, 249) forState:UIControlStateNormal];
    [canclePick addTarget:self action:@selector(pickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    canclePick.tag = 1000;
    canclePick.titleLabel.font = font_nonr_size(15);
    [self.pickBackView addSubview:canclePick];
    [canclePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    UILabel *titlePick = [[UILabel alloc]init];
    titlePick.text = @"生日";
    titlePick.textColor = WWContentTextColor;
    titlePick.font = font_nonr_size(17);
    [self.pickBackView addSubview:titlePick];
    [titlePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pickBackView.mas_centerX);
        make.centerY.equalTo(canclePick.mas_centerY);
    }];
    UIButton *okPick = [[UIButton alloc]init];
    [okPick setTitle:@"确定" forState:UIControlStateNormal];
    [okPick setTitleColor:RGBCOLOR(95, 135, 249) forState:UIControlStateNormal];
    [okPick addTarget:self action:@selector(pickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    okPick.tag = 2000;
    okPick.titleLabel.font = font_nonr_size(15);
    [self.pickBackView addSubview:okPick];
    [okPick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pickBackView.mas_right).offset(-17);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    UILabel *linePick = [[UILabel alloc]init];
    linePick.backgroundColor = RGBCOLOR(214, 215, 219);
    [self.pickBackView addSubview:linePick];
    [linePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.pickBackView.mas_right).offset(-17);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(canclePick.mas_bottom);
    }];
    
    self.pickView = [[UIPickerView alloc] init];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    [self.pickBackView addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.equalTo(self.pickBackView.mas_right).offset(-17);
        make.bottom.equalTo(self.pickBackView.mas_bottom);
        make.height.mas_equalTo(166);
    }];

    [self viewLoad:[NSDate date]];
}

- (void)shadowButtonClick:(UIButton *)sender{
    shadowView.hidden = YES;
    [self.pickBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MainView_Height);
    }];
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)pickBtnClick:(UIButton *)sender{
    if (sender.tag == 2000) {
        labelBirthday.text = [NSString stringWithFormat:@"%@%@%@",currentYearString,currentMonthString,currentDateString];
    }
    [self.pickBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(MainView_Height);
    }];
    
    shadowView.hidden = YES;
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 选择性别和生日
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 1001) {
        shadowView.hidden = NO;
        [self.pickBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MainView_Height-210);
        }];
        // 告诉self.view约束需要更新
        [self.view setNeedsUpdateConstraints];
        // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self.view updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];

        
    }else{
        UIAlertController *sexAlert = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        // 创建按钮
        UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            labelSex.text = @"男";
        }];
        // 创建警告按钮
        UIAlertAction *womanAction = [UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            labelSex.text = @"女";
        }];
        // 注意取消按钮只能添加一个
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        // 添加按钮 将按钮添加到UIAlertController对象上
        [sexAlert addAction:manAction];
        [sexAlert addAction:womanAction];
        [sexAlert addAction:cancelAction];
        
        [self presentViewController:sexAlert animated:YES completion:nil];
    }
}

#pragma mark UIPickerView代理

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
    {
        return [self.yearArray count];
        
    }
    else if (component == 1)
    {
        return [self.monthArray count];
    }
    else if (component == 2)
    { // day
        if (self.selectedMonthRow == 0 || self.selectedMonthRow == 2 || self.selectedMonthRow == 4 || self.selectedMonthRow == 6 || self.selectedMonthRow == 7 || self.selectedMonthRow == 9 || self.selectedMonthRow == 11)
        {
            return 31;
        }else if (self.selectedMonthRow == 1){
            
            int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow]intValue ];
            
            if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                return 29;
            }
            else
            {
                return 28; // or return 29
            }
        }
        else
        {
            return 30;
        }
    }
    return 0;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        return [self.yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        return [self.monthArray objectAtIndex:row];  // Month
    }
    else
    {
        return [self.daysArray objectAtIndex:row]; // Date
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *yearString;
    NSString *monthString;
    NSString *dayString;
    if (component == 0)
    {
        self.selectedYearRow = row;
        yearString = [self.yearArray objectAtIndex:row];
    }
    else if (component == 1)
    {
        self.selectedMonthRow = row;
        [self.pickView reloadComponent:2];
        monthString = [self.monthArray objectAtIndex:row];
    }
    else if (component == 2)
    {
        self.selectedDayRow = row;
        dayString = [self.daysArray objectAtIndex:row];
    }
    [self.pickView reloadComponent:component];
    
    if (yearString == NULL) {
        yearString = currentYearString;
    }else{
        currentYearString = yearString;
    }
    if (monthString == NULL) {
        monthString = currentMonthString;
    }else{
        currentMonthString = monthString;
    }
    if (dayString == NULL) {
        dayString = currentDateString;
    }else{
        currentDateString = dayString;
    }
}


// 更改头像
- (void)imageHeadButtonClick:(UIButton *)sender{
    UIAlertController *imageHeadAlert = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 创建按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        _pickerImage = [[UIImagePickerController alloc]init];
        _pickerImage.delegate = self;
        _pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerImage.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        _pickerImage.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _pickerImage.showsCameraControls = YES;
        _pickerImage.allowsEditing = YES;
        [self presentViewController:_pickerImage animated:YES completion:nil];
        
    }];
    // 创建警告按钮
    UIAlertAction *structlAction = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        _pickerImage  = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        _pickerImage.delegate = self;
        _pickerImage.allowsEditing = NO;
        [self presentViewController:_pickerImage animated:YES completion:nil];

    }];
    
    // 创建按钮
    // 注意取消按钮只能添加一个
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        // 点击按钮后的方法直接在这里面写
        NSLog(@"注意学习");
    }];
    
    // 添加按钮 将按钮添加到UIAlertController对象上
    [imageHeadAlert addAction:okAction];
    [imageHeadAlert addAction:structlAction];
    [imageHeadAlert addAction:cancelAction];
    
    [self presentViewController:imageHeadAlert animated:YES completion:nil];
}

#pragma mark ----- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //关闭相册选取控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        //获取到媒体的类型
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        //判断选取的资源是否为相片
        if([mediaType isEqualToString:@"public.image"]) {
            UIImage  *images = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self ClipPhoto:images];
        }
    }];
}

- (void)ClipPhoto:(UIImage *)imageObj
{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = 1;
    imageCrop.image = imageObj;
    [imageCrop showWithAnimation:YES];
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
   // 未压缩
    imageViewHead.image = cropImage;
}

//用户取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// 返回拜拜
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewLoad:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Get Current Year
    [formatter setDateFormat:@"yyyy"];
    currentYearString = [NSString stringWithFormat:@"%@年",[formatter stringFromDate:date]];
    
    // Get Current  Month
    [formatter setDateFormat:@"M"];
    currentMonthString = [NSString stringWithFormat:@"%@月",[formatter stringFromDate:date]];
    
    // Get Current  Date
    [formatter setDateFormat:@"d"];
    currentDateString = [NSString stringWithFormat:@"%@日",[formatter stringFromDate:date]];
    
    [formatter setDateFormat:@"yyyy"];
    int currentyear = [[formatter stringFromDate:date] intValue];
    // PickerView -  Years data
    self.yearArray = [[NSMutableArray alloc] init];
    for (int i = 1900; i <= 2050 ; i++)
    {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    // PickerView -  Months data
    self.monthArray = [[NSMutableArray alloc] init];
    for (int i = 01; i <= 12 ; i++)
    {
        [self.monthArray addObject:[NSString stringWithFormat:@"%d月",i]];
    }
    // PickerView -  Days data
    self.daysArray = [[NSMutableArray alloc] init];
    for (int i = 01; i <= 31; i++)
    {
        [self.daysArray addObject:[NSString stringWithFormat:@"%d日",i]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
