//
//  NHTabBarContentView.m
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import "NHTabBarContentView.h"

@implementation NHTabBarContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTabBar:(NHTabBarView *)tabBar {
    if (_tabBar != tabBar){
        [_tabBar removeFromSuperview];
        _tabBar = tabBar;
        [self addSubview:_tabBar];
    }
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView){
        [_contentView removeFromSuperview];
        _contentView = contentView;
        _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.tabBar.frame.origin.y);
        [self addSubview:_contentView];
        [self sendSubviewToBack:_contentView];
        [_contentView setNeedsDisplay];
        [self setNeedsLayout];
    }
}

#pragma mark - Layout & Drawing
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect tabBarRect = _tabBar.frame;
    tabBarRect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(_tabBar.bounds);
    [_tabBar setFrame:tabBarRect];
    
    CGRect contentViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - ((!_isTabBarHidding) ? CGRectGetHeight(_tabBar.bounds) : 0));
    _contentView.frame = contentViewRect;
    [_contentView setNeedsLayout];
}

@end
