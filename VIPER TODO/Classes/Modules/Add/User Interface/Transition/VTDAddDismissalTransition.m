//
// VTDAddDismissalTransition.m
//
// Copyright (c) 2014 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VTDAddDismissalTransition.h"

#import "VTDAddViewController.h"

@implementation VTDAddDismissalTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return 0.72;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    VTDAddViewController *fromVC = (VTDAddViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGPoint finalCenter = CGPointMake(160.0f, (fromVC.view.bounds.size.height / 2) - 1000.0f);
    
	[UIView
     animateWithDuration:[self transitionDuration:transitionContext]
     delay:0.0f
     usingSpringWithDamping:0.64f
     initialSpringVelocity:0.22f
     options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent
     animations:^{
         fromVC.view.center = finalCenter;
         fromVC.transitioningBackgroundView.alpha = 0.0f;
     } completion:^(BOOL finished) {
         [fromVC.view removeFromSuperview];
         [transitionContext completeTransition:YES];
     }];
}

@end
