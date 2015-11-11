//
//  NHTabBarView.h
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHTabBarItem.h"

@protocol NHTabBarViewDelegate;
@interface NHTabBarView : UIView

@property (nonatomic, assign) id <NHTabBarViewDelegate> delegate;
@property (nonatomic, strong) NSArray *tabs;
@property (nonatomic, strong) NHTabBarItem *selectedTab;

// Tab top embos Color
@property (nonatomic, strong) UIColor *edgeColor;

// Top embos Color. optional, default to edgeColor
@property (nonatomic, strong) UIColor *topEdgeColor;

// Tabs selected colors.
@property (nonatomic, strong) NSArray *tabColors;

// Tab background image
@property (nonatomic, strong) NSString *backgroundImageName;

- (void)tabSelected:(NHTabBarItem *)sender;

-(void)setBadgeValue:(NSInteger)badgeValue withIndex:(NSInteger)index;
-(NSInteger)getBadgeWithIndex:(NSInteger)index;

@end

@protocol NHTabBarViewDelegate <NSObject>
@required
-(void)tabBar:(NHTabBarView *)FLTabbarView DidSelectTabAtIndex:(NSInteger)index;

@end
