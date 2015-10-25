//
//  UIView+PCLExtensions.h
//  PublicCodeLibrary
//
//  Created by noskill on 23.05.11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

@interface UIView (PCLExtensions)


#pragma mark - Animations

- (void)pcl_jump;


#pragma mark - Style

- (void)pcl_enableRoundRect;
- (void)pcl_enableRoundRectWithRadius:(CGFloat)aRadius;
- (void)pcl_enableRoundRectWithRadius:(CGFloat)aRadius borderWidth:(CGFloat)aWidth borderColor:(UIColor*)aColor;


#pragma mark - Finding Views

- (void)pcl_recursivelyFindSubviewsOfClass:(Class)aClass storeInArray:(NSMutableArray*)array;

@end

