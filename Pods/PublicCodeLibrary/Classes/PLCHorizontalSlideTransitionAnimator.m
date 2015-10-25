//
//  PLCHorizontalSlideTransitionAnimator.m
//  flinc
//
//  Created by Stefan Herold on 16/09/15.
//  Copyright © 2015 flinc. All rights reserved.
//

#import "PLCHorizontalSlideTransitionAnimator.h"

@implementation PLCHorizontalSlideTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat width = containerView.frame.size.width;
    
    CGRect fromViewFrame = CGRectOffset(fromViewController.view.frame, self.presenting ? -width : width, 0);
    
    toViewController.view.frame = CGRectOffset(toViewController.view.frame, self.presenting ? width : 0.0f, 0.f);
    
    if (self.showShadow) {
        toViewController.view.layer.shadowRadius = 5;
        toViewController.view.layer.shadowOpacity = .4f;
    }
    
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        toViewController.view.frame = fromViewController.view.frame;
        fromViewController.view.frame = fromViewFrame;
        
    } completion:^(BOOL finished) {
        if (self.showShadow) {
            toViewController.view.layer.shadowOpacity = 0.f;
        }

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25f;
}

@end
