//
//  UIColor+PCLExtensions.h
//  PublicCodeLibrary
//
//  Created by noskill on 23.05.11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

@interface UIColor (PCLExtensions)

- (CGFloat)pcl_red;
- (CGFloat)pcl_green;
- (CGFloat)pcl_blue;
- (CGFloat)pcl_alpha;

+ (UIColor*)pcl_colorWithRed:(NSUInteger)redValue green:(NSUInteger)greenValue blue:(NSUInteger)blueValue alpha:(CGFloat)alpha;

+ (UIColor*)pcl_randomColor;

+ (UIColor *)pcl_colorWithHex:(unsigned int)value alpha:(float)alpha;

@end
