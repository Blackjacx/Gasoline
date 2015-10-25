//
//  UIColor+PCLExtensions.m
//  PublicCodeLibrary
//
//  Created by noskill on 23.05.11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "UIColor+PCLExtensions.h"


@implementation UIColor (PCLExtensions)

- (CGFloat)pcl_red
{
    const CGFloat * aColor = CGColorGetComponents(self.CGColor);
    return aColor[0];
}

- (CGFloat)pcl_green
{
    const CGFloat * aColor = CGColorGetComponents(self.CGColor);
    return aColor[1];
}

- (CGFloat)pcl_blue
{
    const CGFloat * aColor = CGColorGetComponents(self.CGColor);
    return aColor[2];
}

- (CGFloat)pcl_alpha
{
    return CGColorGetAlpha(self.CGColor);
}

+ (UIColor*)pcl_colorWithRed:(NSUInteger)redValue green:(NSUInteger)greenValue blue:(NSUInteger)blueValue alpha:(CGFloat)alpha
{
	NSUInteger max = 255;
    return [UIColor colorWithRed:MIN(redValue,max)/255.f green:MIN(greenValue,max)/255.f blue:MIN(blueValue, max)/255.f alpha:alpha];
}

+ (UIColor*)pcl_randomColor
{
    return [self pcl_colorWithRed:arc4random()%256 green:arc4random()%256 blue:arc4random()%256 alpha:1.f];
}

+ (UIColor *)pcl_colorWithHex:(unsigned int)value alpha:(float)alpha
{
    return [UIColor pcl_colorWithRed:((value & 0xFF0000) >> 16) green:((value & 0xFF00) >> 8) blue:(value & 0xFF) alpha:alpha];
}


@end
