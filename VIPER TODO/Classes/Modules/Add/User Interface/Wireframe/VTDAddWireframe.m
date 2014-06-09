//
// VTDAddWireframe.m
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

#import "VTDAddWireframe.h"

#import "VTDAddPresenter.h"
#import "VTDAddViewController.h"
#import "VTDAddDismissalTransition.h"
#import "VTDAddPresentationTransition.h"

static NSString *AddViewControllerIdentifier = @"VTDAddViewController";

@interface VTDAddWireframe () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIViewController *presentedViewController;

@end

@implementation VTDAddWireframe

- (void)presentAddInterfaceFromViewController:(UIViewController *)viewController
{
    VTDAddViewController *addViewController = [self addViewController];
    addViewController.eventHandler = self.addPresenter;
    addViewController.modalPresentationStyle = UIModalPresentationCustom;
    addViewController.transitioningDelegate = self;

    [self.addPresenter configureUserInterfaceForPresentation:addViewController];

    [viewController presentViewController:addViewController animated:YES completion:nil];
    
    self.presentedViewController = viewController;
}


- (void)dismissAddInterface
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


- (VTDAddViewController *)addViewController
{
    UIStoryboard *storyboard = [self mainStoryboard];
    VTDAddViewController *addViewController = [storyboard instantiateViewControllerWithIdentifier:AddViewControllerIdentifier];
    
    return addViewController;
}


- (UIStoryboard *)mainStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    
    return storyboard;
}


#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[VTDAddDismissalTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[VTDAddPresentationTransition alloc] init];
}

@end
