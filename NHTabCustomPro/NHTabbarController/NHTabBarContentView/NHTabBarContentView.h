//
//  NHTabBarContentView.h
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHTabBarView.h"

@interface NHTabBarContentView : UIView

@property (nonatomic, strong) NHTabBarView *tabBar;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isTabBarHidding;

@end
