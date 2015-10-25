//
//  UIView+PCLExtensions.m
//  PublicCodeLibrary
//
//  Created by noskill on 23.05.11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "UIView+PCLExtensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (PCLExtensions)

#pragma mark - Animations

- (void)pcl_jump
{
    CGAffineTransform upJump = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -25);
    CGAffineTransform downJump = CGAffineTransformTranslate(CGAffineTransformIdentity, 0,  25);
    
    // -- Start with upJump
    self.transform = upJump;
    
    [UIView animateWithDuration:0.2f 
                          delay:0.0f 
                        options:UIViewAnimationOptionAllowUserInteraction
                                | UIViewAnimationOptionAutoreverse
                                | UIViewAnimationOptionCurveEaseIn                    
                     animations:^
                     {
                         [UIView setAnimationRepeatCount:5];
                         self.transform = downJump;
                     }
                     completion:^(BOOL finished)
                     {
                         self.transform = CGAffineTransformIdentity;                         
                     }];
}

#pragma mark - Style

- (void)pcl_enableRoundRect
{
    [self pcl_enableRoundRectWithRadius:5.0f];
}

- (void)pcl_enableRoundRectWithRadius:(CGFloat)aRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = aRadius;
}

- (void)pcl_enableRoundRectWithRadius:(CGFloat)aRadius borderWidth:(CGFloat)aWidth borderColor:(UIColor*)aColor
{
    [self pcl_enableRoundRectWithRadius:aRadius];
    self.layer.borderWidth = aWidth;
    self.layer.borderColor = aColor.CGColor;
}


#pragma mark - Finding Views 

- (void)pcl_recursivelyFindSubviewsOfClass:(Class)aClass storeInArray:(NSMutableArray*)array {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:aClass]) {
            [array addObject:subview];
        }
        [subview pcl_recursivelyFindSubviewsOfClass:aClass storeInArray:array];
    }
}


@end
