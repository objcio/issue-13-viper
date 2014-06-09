//
// VTDListWireframe.m
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

#import "VTDListWireframe.h"

#import "VTDAddWireframe.h"
#import "VTDListPresenter.h"
#import "VTDListViewController.h"
#import "VTDRootWireframe.h"

#import "VTDUpcomingDisplayData.h"
#import "VTDUpcomingDisplaySection.h"
#import "VTDUpcomingDisplayItem.h"


static NSString *ListViewControllerIdentifier = @"VTDListViewController";

@interface VTDListWireframe ()

@property (nonatomic, strong) VTDListViewController *listViewController;

@end

@implementation VTDListWireframe

- (void)presentListInterfaceFromWindow:(UIWindow *)window
{
    VTDListViewController *listViewController = [self listViewControllerFromStoryboard];
    listViewController.eventHandler = self.listPresenter;
    self.listPresenter.userInterface = listViewController;
    self.listViewController = listViewController;
    
    [self.rootWireframe showRootViewController:listViewController
                                      inWindow:window];
}


- (void)presentAddInterface
{
    [self.addWireframe presentAddInterfaceFromViewController:self.listViewController];
}


- (VTDListViewController *)listViewControllerFromStoryboard
{
    UIStoryboard *storyboard = [self mainStoryboard];
    VTDListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:ListViewControllerIdentifier];
    
    return viewController;
}


- (UIStoryboard *)mainStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    
    return storyboard;
}

@end
