//
//  InfoViewController.m
//  Carcorder
//
//  Created by YF on 16/1/19.
//  Copyright (c) 2016年 newsmy. All rights reserved.
//

#import "InfoViewController.h"
#import "FenceInfo.h"
#import "QueryTimeInfo.h"
#import "HttpEngine.h"
#import "LocationPuchController.h"
#import "SqlLiteHelp.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "InfoTextView.h"

@interface InfoViewController ()
{
    NSString *ssidStr;
    
    QueryTimeInfo *info;
    
    NSMutableArray *bubbleArr;
    
    NSMutableArray *messages;
    
    SqlLiteHelp *sql;
    
    InfoTextView *textView;
    
    UIView *bubble;
    
    CGRect tableAllFrame;
    
    NSMutableArray *array;
}
@end

@implementation InfoViewController

static NSString *cellIdentifier=@"Cell";

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [super viewWillAppear:YES];
    
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"connectSuccess.plist"];
    array = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    self.tabBarController.tabBar.hidden=YES;
    
    messages=[sql getMessages];
    
    [self getMessageList];
}

//调回该界面,隐藏键盘,view回到底部
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    if (messages.count>0)
    {
          [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.title=@"消息";
    
    UIBarButtonItem *backBarItem=[UIBarButtonItem new];
    backBarItem.title=@"返回";
    self.navigationItem.backBarButtonItem=backBarItem;
    
    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clearBarClick)];
    self.navigationItem.rightBarButtonItem=rightBtnItem;
   
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    bubbleArr=[NSMutableArray array];
   
    sql=[[SqlLiteHelp alloc]init];
  
    //使用左对话框
    isLocation=!isLocation;
    
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    _table.bounces=NO;
    _table.showsVerticalScrollIndicator=YES;
    tableAllFrame=_table.frame;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardClick)];
    [_table addGestureRecognizer:tapRecognizer];
    
    
    //这种方法可以隐藏键盘,改变view的位置,但是table拖不动,使用scrollViewBegainDragging方法实现这个效果
    /*
    UIPanGestureRecognizer *panRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardClick)];
    
    [_table addGestureRecognizer:panRecognizer];
    */
    
    textView=[InfoTextView getInstance];
    textView.frame=CGRectMake(0, kScreen_height-50, kScreen_width, 50);
    textView.sendMessageTF.delegate=self;
    [textView.locationBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [textView.sendMessageBtn addTarget:self action:@selector(messageSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textView];
    
    
    info=[[QueryTimeInfo alloc] init];
    info.accountID=[USER valueForKey:@"userName"];
    info.deviceID=[USER valueForKey:@"device"];
    info.IMEI=[USER valueForKey:@"IMEI"];
    
    /*获取设备的session_id*/
    /*
    [HttpEngine deviceQueryDeviceSessionID:info and:^(NSString *str) {
        
        ssidStr=str;
        
    }];
    */

}

-(void)keyboardWillHide:(id)sender
{
    self.view.frame = CGRectMake(0,0, kScreen_width,kScreen_height);
    CGRect rect=textView.frame;
    rect.origin.y=kScreen_height - textView.frame.size.height;
    textView.frame=rect;
}

-(void)clearBarClick
{
    //删除数组
    [messages removeAllObjects];
    //删除数据库中的数据
    [sql deleteMessage];
    [_table reloadData];
}

-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *dicInfo=[note userInfo];
    
    CGSize keyboardSize=[[dicInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyBoardHeight=keyboardSize.height;
    
    //int offset = textView.frame.origin.y+textView.frame.size.height-(self.view.frame.size.height -_keyBoardHeight);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self reloadMessageCellFrame];
    [UIView commitAnimations];
}

-(void)reloadMessageCellFrame
{
    if (messages.count*(bubble.frame.size.height+10)>tableAllFrame.size.height)
    {
        // 1, 消息总高度超过表高度
        
        NSLog(@"1");
        
        self.view.frame = CGRectMake(0, -_keyBoardHeight, kScreen_width, kScreen_height);
        
    }
    else if ((messages.count*(bubble.frame.size.height+10)+textView.frame.size.height+_keyBoardHeight + 64)<kScreen_height)
    {
        // 2, 导航 + 消息总高度 + 键盘 + textview < 屏幕高度
        
        NSLog(@"2, message count : %f ", (messages.count*(bubble.frame.size.height+10)+textView.frame.size.height+_keyBoardHeight));
        
       self.view.frame = CGRectMake(0, 0, kScreen_width, kScreen_height);
            CGRect rect=textView.frame;
            rect.origin.y=kScreen_height-_keyBoardHeight - textView.frame.size.height;
            textView.frame=rect;
    }
    else
    {
        // 3, 导航 + 消息总高度 + 键盘 + textview > 屏幕高度
        
        NSLog(@"3");
        
        /*
        int offset =  (messages.count*(bubble.frame.size.height+10)+textView.frame.size.height+_keyBoardHeight + 64) - kScreen_height;
        
        CGRect rect=textView.frame;
        rect.origin.y=kScreen_height - textView.frame.size.height - _keyBoardHeight + offset + bubble.frame.size.height;
        textView.frame=rect;
        self.view.frame = CGRectMake(0,  -offset -bubble.frame.size.height ,kScreen_width, kScreen_height);

        */
        
        CGRect rect=textView.frame;
        rect.origin.y=kScreen_height - textView.frame.size.height;
        textView.frame=rect;
         self.view.frame = CGRectMake(0,  -_keyBoardHeight ,kScreen_width, kScreen_height);
    }

}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textView.sendMessageTF resignFirstResponder];
    
    [self viewAnimation];
    
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboardClick];
}

-(void)hideKeyboardClick
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[InfoTextView class]])
        {
            [self viewAnimation];
            
            for (UITextField *TF in view.subviews)
            {
                if ([TF isKindOfClass:[UITextField class]])
                {
                    [TF resignFirstResponder];
                    
                }
            }
        }
    }
}

-(void)viewAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame=CGRectMake(0, 0, kScreen_width, kScreen_height);
    [UIView commitAnimations];
}

-(void)locationBtnClick:(UIButton *)button
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    LocationPuchController *locationMap=[[LocationPuchController alloc] init];
    [self.navigationController pushViewController:locationMap animated:YES];
}

#pragma mark 警告框自动消失
-(void)showAlert:(NSString *)timeMessage
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:timeMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:alert repeats:YES];
    [alert show];
}

-(void)timerMethod:(NSTimer *)timer
{
    UIAlertView *alert=(UIAlertView *)[timer userInfo];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    alert=NULL;
}

-(BOOL)isConnectionAvailable
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    if (!isExistenceNetwork)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = NSLocalizedString(@"网络不可用,请检查网络连接", nil);
        hud.minSize = CGSizeMake(100.0f, 50.0f);
        [hud hide:YES afterDelay:3.0];
        return NO;
    }
    return isExistenceNetwork;
}

-(void)messageSendBtnClick:(UIButton *)button
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    BOOL isConnection=[self isConnectionAvailable];
    if (isConnection)
    {
        if([textView.sendMessageTF.text isEqualToString:@""])
        {
            [self.view makeToast:@"发送消息不能为空!" duration:1.0 position:CSToastPositionCenter];

            return;
        }
            info.messageStr=textView.sendMessageTF.text;
            
            [HttpEngine deviceSendMessage:info and:^(int code) {
                
                int resultCode=code;
                
                NSLog(@"resultCode====%d",resultCode);
                
                if (resultCode==3)
                {
                
                    
                    [self.view makeToast:@"设备不在线!" duration:1.0 position:CSToastPositionCenter];
                    
                    return ;
                }
                
                if (resultCode==0 || true)
                {
                    [self.view makeToast:@"发送成功" duration:1.0 position:CSToastPositionCenter];
                    NSString *messageStr=[NSString stringWithFormat:@"%@",textView.sendMessageTF.text];
                    
                    Message *mes=[[Message alloc]init];
                    mes.content=messageStr;
                    mes.device=[USER valueForKey:@"device"];
                    NSDate *currentDate=[NSDate date];
                    NSLog(@"currentDate=====%@",currentDate);
                    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                    NSString *dateStr=[formatter stringFromDate:currentDate];
                    
                    mes.time=dateStr;
                    [sql addMessage:mes];
                    [messages addObject:mes];
                    [self getMessageList];
                    
                    //[self reloadMessageCellFrame];
                }
            }];
        }
}

-(void)getMessageList
{
    [bubbleArr removeAllObjects];
    
    for (Message *item in messages)
    {
        [self getMessageListItem:item];
    }
    
    [_table reloadData];
    
    if (messages.count>0)
    {
        [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
}

-(BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    return YES;
}

-(void)getMessageListItem:(Message*)message
{
    UILabel *dateLab=[[UILabel alloc] init];
    dateLab.backgroundColor=[UIColor lightGrayColor];
    dateLab.text=message.time;
    CGSize size1=[dateLab sizeThatFits:CGSizeMake(MAXFLOAT, 25)];
    dateLab.frame=CGRectMake((kScreen_width-(size1.width-20))/2, 0, size1.width-20, 25);
    dateLab.textAlignment=NSTextAlignmentCenter;
    dateLab.textColor=[UIColor whiteColor];
    dateLab.font=[UIFont systemFontOfSize:14.0];
    
    UILabel *messageLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    messageLab.text=message.content;
    messageLab.numberOfLines=0;
    messageLab.font=[UIFont systemFontOfSize:16.0];
    
    //CGSize size2=[messageLab sizeThatFits:CGSizeMake(kScreen_width-80, MAXFLOAT)];
    CGSize size2=[message.content boundingRectWithSize:CGSizeMake(kScreen_width-80, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreen_width-(size2.width+35+5), 35, size2.width+35, size2.height+15)];
    NSString *imgName=isLocation ? @"对话框-右":@"对话框-左";
    UIImage *img=[UIImage imageNamed:imgName];
    UIImage *newImg=[img stretchableImageWithLeftCapWidth:23 topCapHeight:17];
    imgView.image=newImg;

    [messageLab setFrame:CGRectMake(13, 0, imgView.frame.size.width-28, imgView.frame.size.height)];
    
    UIImageView *location=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"定位标"]];
    location.frame=CGRectMake(10, (imgView.frame.size.height-20)/2, 20, 20);
    if(message.point_or_text==1)
    {
        [imgView  addSubview:location];
        [messageLab setFrame:CGRectMake(30, 0, imgView.frame.size.width-40, imgView.frame.size.height)];
    }
    [imgView addSubview:messageLab];
    
    UIView *bubbleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, dateLab.frame.size.height+imgView.frame.size.height+10)];
    bubbleView.tag=1;
    
    [bubbleView addSubview:dateLab];
    [bubbleView addSubview:imgView];
    [bubbleArr addObject:bubbleView];

    textView.sendMessageTF.text=@"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]];
    UIView *oldBubble=[cell viewWithTag:1];
    [oldBubble removeFromSuperview];
    
    UIView *bubbleView=[bubbleArr objectAtIndex:indexPath.row];
    [cell addSubview:bubbleView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bubble=[bubbleArr objectAtIndex:indexPath.row];
    return bubble.frame.size.height+10;
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
