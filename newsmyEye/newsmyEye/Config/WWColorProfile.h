//
//  WWColorProfile.h
//  newsmyEye
//
//  Created by newsmy on 16/7/4.
//  Copyright © 2016年 newsmy. All rights reserved.
//

#ifndef WWColorProfile_h
#define WWColorProfile_h

//设备屏幕高度
#ifndef MainView_Height
#define MainView_Height    [UIScreen mainScreen].bounds.size.height
#endif

//设备屏幕宽度
#ifndef MainView_Width
#define MainView_Width    [UIScreen mainScreen].bounds.size.width
#endif

//rpg颜色宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


//转RGB颜色值
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//绿色按钮三态
#define Btn_Blue_Normal_Top UIColorFromRGB(#7accc5)

#define btn_organ   RGBCOLOR(241,213,43)

//工程主调颜色
#define WW_BASE_COLOR RGBCOLOR(242,242,242)

//线条颜色
#define WWPageLineColor                 RGBCOLOR(217,217,217)
//内容颜色
#define WWContentTextColor              RGBCOLOR(51,51,51)
//提示文字颜色
#define WWPlaceTextColor                RGBCOLOR(153,153,153)
//黄色文字
#define WWOrganText                      RGBCOLOR(237,200,30)

//灰色的文字
#define WWGreyText                      RGBCOLOR(102,102,102)

//标题颜色
#define WWTitleTextColor                RGBCOLOR(64,64,64)
//副标题颜色
#define WWSubTitleTextColor             RGBCOLOR(134,134,134)
//按键高亮的显示颜色
#define WWBtnStateHighlightedColor      RGBCOLOR(222,222,222)

#define WWLowGreyText                      RGBCOLOR(170,170,170)

#endif /* WWColorProfile_h */
