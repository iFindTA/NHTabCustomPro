//
//  NHTabBarView.m
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

static int kInterTabMargin = 1;
static int kTopEdgeWidth   = 1;

#import "NHTabBarView.h"
#import "JSBadgeView.h"

@interface NHTabBarView ()

@property (nonatomic, strong)NSMutableArray *badgeViews;

@end

@implementation NHTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        //self.opaque = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleTopMargin);
        
        _badgeViews = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}

#pragma mark - Setters and Getters

- (void)setTabs:(NSArray *)array {
    if (_tabs != array){
        for (NHTabBarItem *tab in _tabs){
            [tab removeFromSuperview];
        }
        _tabs = array;
        
        for (NHTabBarItem *tab in _tabs){
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:tab alignment:JSBadgeViewAlignmentTopRight];
            badgeView.badgePositionAdjustment = CGPointMake(tab.frame.size.width-20, 10);
            [badgeView setHidden:YES];
            [badgeView setUserInteractionEnabled:NO];
            [_badgeViews addObject:badgeView];
        }
    }
    [self setNeedsLayout];
}

- (void)setSelectedTab:(NHTabBarItem *)selectedTab {
    if (selectedTab != _selectedTab){
        [_selectedTab setSelected:NO];
        _selectedTab = selectedTab;
        [_selectedTab setSelected:YES];
    }
}

#pragma mark - Delegate notification

- (void)tabSelected:(NHTabBarItem *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(tabBar:DidSelectTabAtIndex:)]){
        [_delegate tabBar:self DidSelectTabAtIndex:[_tabs indexOfObject:sender]];
    }
}

#pragma mark - BadgeValue
-(void)setBadgeValue:(NSInteger)badgeValue withIndex:(NSInteger)index {
    JSBadgeView *tempView = [self getCurrentBadgeViewWithIndex:index];
    NSString *badgeText ;
    if (badgeValue < 0){
        [tempView setHidden:YES];
        return ;
    }else{
        badgeText = [NSString stringWithFormat:@"%ld",(long)badgeValue];
        if (badgeValue >99){
            badgeText = @"99+";
        }else if (badgeValue == 0){
            badgeText = @"";
        }
        [tempView setHidden:NO];
        [tempView setBadgeText:badgeText];
    }
}

-(NSInteger)getBadgeWithIndex:(NSInteger)index {
    NSInteger badgeCount = 0;
    
    JSBadgeView *tempView = [self getCurrentBadgeViewWithIndex:index];
    if (tempView != nil){
        badgeCount = [tempView.badgeText integerValue];
    }
    
    return badgeCount;
}

-(JSBadgeView *)getCurrentBadgeViewWithIndex:(NSInteger)index_ {
    JSBadgeView *badgeView = nil;
    NSInteger currentIndex = index_;
    if (currentIndex < 0){
        currentIndex = 0;
    }else if (currentIndex >=[_badgeViews count]){
        currentIndex = [_badgeViews count]-1;
    }
    badgeView = [_badgeViews objectAtIndex:currentIndex];
    return badgeView;
}

#pragma mark - Drawing & Layout

- (void)drawRect:(CGRect)rect {
    // Drawing the tab bar background
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIColor *bgColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
    CGContextFillRect(ctx, rect);
    
    /*梯度
     // Drawing the gradient
     CGContextSaveGState(ctx);
     {
     // We set the parameters of the gradient multiply blend
     size_t num_locations = 2;
     CGFloat locations[2] = {0.0, 1.0};
     CGFloat components[8] = {0.9, 0.9, 0.9, 1.0,    // Start color
     0.2, 0.2, 0.2, 0.8};    // End color
     
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     CGGradientRef gradient = _tabColors ? CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_tabColors, locations) : CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
     CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
     CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height), kCGGradientDrawsAfterEndLocation);
     
     CGColorSpaceRelease(colorSpace);
     CGGradientRelease(gradient);
     }
     CGContextRestoreGState(ctx);
     //*/
    
    //*最上部线浮雕
    // Drawing the top dark emboss
    CGContextSaveGState(ctx);
    {
        UIColor *topEdgeColor = _topEdgeColor;
        if (!topEdgeColor) {
            _edgeColor ? _edgeColor : [UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.8f];
            topEdgeColor = UIColorFromRGB(NHLightGrayHexValue);
        }
        CGContextSetFillColorWithColor(ctx, topEdgeColor.CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width, kTopEdgeWidth));
    }
    CGContextRestoreGState(ctx);
    //*/
    
    //*上部明亮浮雕
    // Drawing the top bright emboss
    CGContextSaveGState(ctx);
    {
        CGContextSetBlendMode(ctx, kCGBlendModeOverlay);
        CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 0.7);
        CGContextFillRect(ctx, CGRectMake(0, 1, rect.size.width, 1));
        
    }
    CGContextRestoreGState(ctx);
    //*/
    
    //*边缘边框线
    // Drawing the edge border lines
    //CGContextSetFillColorWithColor(ctx, _edgeColor ? [_edgeColor CGColor] : [[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.8f] CGColor]);
    
    //*内嵌
    for (NHTabBarItem *tab in _tabs)
        CGContextFillRect(ctx, CGRectMake(tab.frame.origin.x - kInterTabMargin, kTopEdgeWidth, kInterTabMargin, rect.size.height));
    //*/
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat screenWidth = self.bounds.size.width;
    
    CGFloat tabNumber = _tabs.count;
    
    // Calculating the tabs width.
    CGFloat tabWidth = floorf(((screenWidth + 1) / tabNumber) - 1);
    
    // Because of the screen size, it is impossible to have tabs with the same
    // width. Therefore we have to increase each tab width by one until we spend
    // of the spaceLeft counter.
    CGFloat spaceLeft = screenWidth - (tabWidth * tabNumber) - (tabNumber - 1);
    
    CGRect rect = self.bounds;
    rect.size.width = tabWidth;
    
    CGFloat dTabWith;
    
    for (NHTabBarItem *tab in _tabs){
        // Here is the code that increment the width until we use all the space left
        
        dTabWith = tabWidth;
        
        if (spaceLeft != 0){
            dTabWith = tabWidth + 1;
            spaceLeft--;
        }
        
        if ([_tabs indexOfObject:tab] == 0){
            tab.frame = CGRectMake(rect.origin.x, rect.origin.y, dTabWith, rect.size.height);
        }else{
            tab.frame = CGRectMake(rect.origin.x + kInterTabMargin, rect.origin.y, dTabWith, rect.size.height);
        }
        
        [self addSubview:tab];
        rect.origin.x = tab.frame.origin.x + tab.frame.size.width;
    }
    
}

@end
