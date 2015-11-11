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

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    
    // Container, basically centered in rect
    CGRect container = CGRectInset(rect, kPadding, kPadding);
    container.size.height -= kTopMargin;
    container.origin.y += kTopMargin;
    
    CGRect imageRect = CGRectZero;
    CGFloat ratio = 1;
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
    imageRect.size = iconSize;
    
    NSDictionary *titleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName,isSelect?selectColor:normalColor,NSForegroundColorAttributeName, nil];
    CGSize titleSize = [_titleInfo sizeWithAttributes:titleAttrs];
    
    // Container, basically centered in rect
    CGRect labelRect = CGRectZero;
    
    labelRect.size = titleSize;
    
    // Container of the image + label (when there is room)
    CGRect content = CGRectZero;
    content.size.width = CGRectGetWidth(container);
    
    // We determine the height based on the longest side of the image (when not square) , presence of the label and height of the container
    content.size.height = MIN(MAX(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect)) + (kMargin + CGRectGetHeight(labelRect)) , CGRectGetHeight(container));
    
    // Now we move the boxes
    content.origin.x = floorf(CGRectGetMidX(container) - CGRectGetWidth(content) / 2);
    content.origin.y = floorf(CGRectGetMidY(container) - CGRectGetHeight(content) / 2);
    
    //    labelRect.size.width = CGRectGetWidth(content);
    labelRect.origin.x = (rect.size.width-titleSize.width)*0.5;
    labelRect.origin.y = CGRectGetMaxY(content) - CGRectGetHeight(labelRect);
    
    CGRect imageContainer = content;
    imageContainer.size.height = CGRectGetHeight(content) - (kMargin + CGRectGetHeight(labelRect));
    
    // When the image is not square we have to make sure it will not go beyond the bonds of the container
    if (CGRectGetWidth(imageRect) >= CGRectGetHeight(imageRect)) {
        imageRect.size.width = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.height = floorf(CGRectGetWidth(imageRect) / ratio);
    } else {
        imageRect.size.height = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.width = floorf(CGRectGetHeight(imageRect) * ratio);
    }
    
    imageRect.origin.x = floorf(CGRectGetMidX(content) - CGRectGetWidth(imageRect) / 2);
    imageRect.origin.y = floorf(CGRectGetMidY(imageContainer) - CGRectGetHeight(imageRect) / 2);
    
    [_iconInfo drawInRect:imageRect withAttributes:iconAttrs];
    
    [_titleInfo drawInRect:labelRect withAttributes:titleAttrs];
}

@end
