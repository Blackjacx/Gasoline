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


#pragma mark - Keyboard Helper

+ (void)pcl_attachDoneButtonToolbarTo:(id<UITextInput>)input target:(id)target action:(SEL)action;



#pragma mark - Working with Subviews

- (void)pcl_recursivelyFindSubviewsOfClass:(Class)aClass storeInArray:(NSMutableArray*)array;
- (void)addSubviewMaximized:(UIView *)view;

@end

