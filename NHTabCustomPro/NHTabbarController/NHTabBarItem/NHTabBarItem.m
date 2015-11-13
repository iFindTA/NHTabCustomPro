//
//  NHTabBarItem.m
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import "NHTabBarItem.h"

@interface NHTabBarItem () {
    BOOL isTabIconPresent;
}
// Permits the cross fade animation between the two images, duration in seconds.
- (void)animateContentWithDuration:(CFTimeInterval)duration;

@end

@implementation NHTabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

#pragma mark - Touche handeling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self animateContentWithDuration:kAnimationDuration];
}

#pragma mark - Animation

- (void)animateContentWithDuration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"contents"];
    [self setNeedsDisplay];
}

- (void)setIconInfo:(NSString *)iconInfo {
    if (_iconInfo != iconInfo) {
        _iconInfo = [iconInfo copy];
        [self setNeedsDisplay];
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    if (_isSelect != isSelect) {
        _isSelect = isSelect;
        [self setNeedsDisplay];
    }
}

- (void)setFontName:(NSString *)fontName {
    if (_fontName != fontName) {
        _fontName = fontName;
        [self setNeedsDisplay];
    }
}

#define NHTabBarIconFontSize     30
#define NHTabBarTitleFontSize    11

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
    // Container, basically centered in rect
    CGRect container = CGRectInset(rect, kPadding, kPadding);
    container.size.height -= kTopMargin;
    container.origin.y += kTopMargin;
    
    CGRect imageRect = CGRectZero;
//    BOOL isSelect = _isSelect;
    BOOL isSelect = self.selected;
    UIColor *bgColor = UIColorFromRGB(NHTabBarBgHexValue);
    UIColor *normalColor = UIColorFromRGB(NHLightGrayHexValue);
    UIColor *selectColor = UIColorFromRGB(NHGreenHexValue);
    UIFont *iconFont = [UIFont fontWithName:_fontName size:NHTabBarIconFontSize];
    UIFont *titleFont = [UIFont fontWithName:_fontName size:NHTabBarTitleFontSize];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
    CGContextFillRect(ctx, rect);
    
    NSDictionary *iconAttrs = [NSDictionary dictionaryWithObjectsAndKeys:iconFont,NSFontAttributeName,isSelect?selectColor:normalColor,NSForegroundColorAttributeName, nil];
    CGSize iconSize = [_iconInfo sizeWithAttributes:iconAttrs];
    CGFloat max = MAX(ceilf(iconSize.width), ceilf(iconSize.height));
    max = MIN(max, NHTabBarIconFontSize);
    imageRect.size = CGSizeMake(max, max);
    imageRect.origin = CGPointMake((rect.size.width-max)*0.5, container.origin.y);
    
    NSDictionary *titleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName,isSelect?selectColor:normalColor,NSForegroundColorAttributeName, nil];
    CGSize titleSize = [_titleInfo sizeWithAttributes:titleAttrs];
    titleSize = CGSizeMake(ceilf(titleSize.width), ceilf(titleSize.height));
    // Container, basically centered in rect
    CGRect labelRect = CGRectZero;
    labelRect.size = titleSize;
    CGFloat cur_y = imageRect.origin.y+imageRect.size.height;
    cur_y += MAX(0, (container.size.height-imageRect.size.height-titleSize.height)*0.5);
    labelRect.origin = CGPointMake((rect.size.width-titleSize.width)*0.5, cur_y);
    
    [_iconInfo drawInRect:imageRect withAttributes:iconAttrs];
    
    [_titleInfo drawInRect:labelRect withAttributes:titleAttrs];
}

@end
