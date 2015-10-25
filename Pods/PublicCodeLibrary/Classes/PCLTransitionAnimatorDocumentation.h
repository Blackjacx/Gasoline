//
//  PCLTransitionAnimatorDocumentation.h
//  PublicCodeLibrary
//
//  Created by Stefan Herold on 30/09/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

/*
 * Usage Example:
 *
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    FLIHorizontalSlideTransitionAnimator *animator = [[FLIHorizontalSlideTransitionAnimator alloc] init];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    FLIHorizontalSlideTransitionAnimator *animator = [[FLIHorizontalSlideTransitionAnimator alloc] init];
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.leftScreenEdgePanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        self.percentDrivenInteractiveTransition.completionCurve = UIViewAnimationOptionCurveEaseOut;
    } else {
        self.percentDrivenInteractiveTransition = nil;
    }
    return self.percentDrivenInteractiveTransition;
}


#pragma mark - Actions

- (IBAction)onLeftEdgePanInLocationPicker:(UIScreenEdgePanGestureRecognizer*)sender {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat percent = MAX([sender translationInView:self.view].x, 0) / width;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self.presentedViewController performSegueWithIdentifier:@"kFLIOnboardingUnwindToIntroSegue" sender:self];
            break;
        case UIGestureRecognizerStateChanged:
            // Update the transition using a UIPercentDrivenInteractiveTransition.
            [self.percentDrivenInteractiveTransition updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            // Cancel or finish depending on how the gesture ended.
            if (percent > 0.5 || fabs([sender velocityInView:self.view].x) > 1000)
                [self.percentDrivenInteractiveTransition finishInteractiveTransition];
            else
                [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
            break;
        default:
            DDLogError(@"unhandled state for gesture=%@", sender);
            break;
    }
}
*/