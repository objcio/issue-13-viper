//
// MMTODOPresenter.m
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

#import "VTDListPresenter.h"

#import "VTDListInteractor.h"
#import "VTDListViewInterface.h"
#import "VTDListWireframe.h"
#import "VTDUpcomingDisplayDataCollector.h"


@implementation VTDListPresenter

- (void)updateView
{
    [self.listInteractor findUpcomingItems];
}


#pragma mark - List Interactor Output

- (void)foundUpcomingItems:(NSArray *)upcomingItems
{
    if ([upcomingItems count] == 0)
    {
        [self.userInterface showNoContentMessage];
    }
    else
    {
        [self updateUserInterfaceWithUpcomingItems:upcomingItems];
    }
}


- (void)updateUserInterfaceWithUpcomingItems:(NSArray *)upcomingItems
{
    [self.userInterface showUpcomingDisplayData:[self upcomingDisplayDataWithItems:upcomingItems]];
}


- (VTDUpcomingDisplayData *)upcomingDisplayDataWithItems:(NSArray *)upcomingItems
{
    VTDUpcomingDisplayDataCollector *collector = [[VTDUpcomingDisplayDataCollector alloc] init];
    [collector addUpcomingItems:upcomingItems];
    
    return [collector collectedDisplayData];
}


#pragma mark -

- (void)addNewEntry
{
    [self.listWireframe presentAddInterface];
}


- (void)addModuleDidCancelAddAction
{
    // No action necessary
}


- (void)addModuleDidSaveAddAction
{
    [self updateView];
}

@end
