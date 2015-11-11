//
//  NHTabBarItem.h
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHTabConstant.h"
#import <QuartzCore/QuartzCore.h>

@interface NHTabBarItem : UIButton

#pragma mark -- IconFont Start --

@property (nullable, nonatomic, copy) NSString *fontName;
@property (nullable, nonatomic, copy) NSString *iconInfo;
@property (nullable, nonatomic, copy) NSString *titleInfo;

@property (nonatomic, assign) BOOL nightMode;

@property (nonatomic, assign) BOOL isSelect;

#pragma mark -- IconFont End --

@end
