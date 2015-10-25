//
//  PLCCrossFadeTransitionAnimator.m
//  flinc
//
//  Created by Stefan Herold on 16/09/15.
//  Copyright © 2015 flinc. All rights reserved.
//

#import "PLCCrossFadeTransitionAnimator.h"
#import "PCLTransitionAnimatorConstants.h"

@implementation PLCCrossFadeTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    containerView.backgroundColor = fromViewController.view.backgroundColor;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    
    toViewController.view.alpha = 1.f;
    toViewController.view.transform = CGAffineTransformMakeScale(kDefaultMinimumScaleFactor, kDefaultMinimumScaleFactor);
    fromViewController.view.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromViewController.view.alpha = 0.f;
        fromViewController.view.transform = CGAffineTransformMakeScale(kDefaultMinimumScaleFactor, kDefaultMinimumScaleFactor);
        
        toViewController.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .25f;
}

@end
