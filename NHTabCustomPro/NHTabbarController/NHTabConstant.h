//
//  NHTabConstant.h
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#ifndef NHTabConstant_h
#define NHTabConstant_h

// cross fade animation duration.
static const float kAnimationDuration = 0.15;

// Padding of the content
static const float kPadding = 4.0;

// Margin between the image and the title
static const float kMargin = 2.0;

// Margin at the top
static const float kTopMargin = 2.0;

#define NHTabBarHeight           50

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

/**
 * 常见颜色设置
 * 系统绿色 RGB值
 * NHGreenRGB_R,NHGreenRGB_G,NHGreenRGB_B三个值合起来对应:NHGreenHexValue
 */
#define NHGreenRGB_R                                0.058
#define NHGreenRGB_G                                0.658
#define NHGreenRGB_B                                0.270
#define NHGreenHexValue                             0x0FBA45
#define NHLightGrayHexValue                         0x999999
#define NHTabBarBgHexValue                          0xEAEAEC

#endif /* NHTabConstant_h */
