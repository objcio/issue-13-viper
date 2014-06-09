//
// VTDListViewTests.m
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

#import <XCTest/XCTest.h>
#import "VTDListViewController.h"
#import "VTDUpcomingDisplayData.h"


@interface VTDListViewTests : XCTestCase

@property (nonatomic, strong)   VTDListViewController*  view;

@end


@implementation VTDListViewTests

- (void)setUp
{
    [super setUp];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.view = [storyboard instantiateViewControllerWithIdentifier:@"VTDListViewController"];
}


- (void)tearDown
{
    [super tearDown];
}


- (void)testShowingNoContentMessageShowsNoContentView
{
    [self.view showNoContentMessage];
    
    XCTAssertEqualObjects(self.view.view, self.view.noContentView, @"the no content view should be the view");
}


- (void)testShowingUpcomingItemsShowsTableView
{
    [self.view showUpcomingDisplayData:nil];
    
    XCTAssertEqualObjects(self.view.view, self.view.tableView, @"the table view should be the view");
}

@end
