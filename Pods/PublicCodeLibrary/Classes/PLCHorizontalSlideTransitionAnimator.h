//
//  PLCHorizontalSlideTransitionAnimator.h
//  flinc
//
//  Created by Stefan Herold on 16/09/15.
//  Copyright © 2015 flinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLCHorizontalSlideTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
/**
 *  Drives the animation for show and hide animations.
 */
@property(assign, nonatomic)BOOL presenting;
/**
 *  Controls the display of a shadow at the border of view controllers.
 */
@property(assign, nonatomic)BOOL showShadow;
@end