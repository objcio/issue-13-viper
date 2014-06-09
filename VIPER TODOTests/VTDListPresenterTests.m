//
// VTDListPresenterTests.m
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
#import <OCMock/OCMock.h>
#import "VTDListPresenter.h"
#import "VTDListViewInterface.h"
#import "VTDUpcomingItem.h"
#import "VTDUpcomingDisplayData.h"
#import "VTDUpcomingDisplaySection.h"
#import "VTDUpcomingDisplayItem.h"
#import "NSCalendar+CalendarAdditions.h"


@interface VTDListPresenterTests : XCTestCase

@property (nonatomic, strong)   VTDListPresenter*   presenter;
@property (nonatomic, strong)   id                  ui;
@property (nonatomic, strong)   id                  wireframe;

@end


@implementation VTDListPresenterTests

- (void)setUp
{
    [super setUp];
    
    self.presenter = [[VTDListPresenter alloc] init];
    self.ui = [OCMockObject mockForProtocol:@protocol(VTDListViewInterface)];
    self.wireframe = [OCMockObject mockForClass:[VTDListWireframe class]];

    self.presenter.userInterface = self.ui;
    self.presenter.listWireframe = self.wireframe;
}


- (void)tearDown
{
    [self.ui verify];
    [self.wireframe verify];
    
    [super tearDown];
}


- (void)testFoundZeroUpcomingItemsDisplaysNoContentMessage
{
    [[self.ui expect] showNoContentMessage];
    
    [self.presenter foundUpcomingItems:@[]];
}


- (void)testFoundUpcomingItemForTodayDisplaysUpcomingDataWithNoDay
{
    VTDUpcomingDisplayData *displayData = [self displayDataWithSectionName:@"Today"
                                                          sectionImageName:@"check"
                                                                 itemTitle:@"Get a haircut"
                                                                itemDueDay:@""];
    [[self.ui expect] showUpcomingDisplayData:displayData];
    
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDate *dueDate = [calendar dateWithYear:2014 month:5 day:29];
    VTDUpcomingItem *haircut = [VTDUpcomingItem upcomingItemWithDateRelation:VTDNearTermDateRelationToday dueDate:dueDate title:@"Get a haircut"];
    
    [self.presenter foundUpcomingItems:@[haircut]];
}


- (void)testFoundUpcomingItemForTomorrowDisplaysUpcomingDataWithDay
{
    VTDUpcomingDisplayData *displayData = [self displayDataWithSectionName:@"Tomorrow"
                                                          sectionImageName:@"alarm"
                                                                 itemTitle:@"Buy groceries"
                                                                itemDueDay:@"Thursday"];
    [[self.ui expect] showUpcomingDisplayData:displayData];
    
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    NSDate *dueDate = [calendar dateWithYear:2014 month:5 day:29];
    VTDUpcomingItem *groceries = [VTDUpcomingItem upcomingItemWithDateRelation:VTDNearTermDateRelationTomorrow
                                                                       dueDate:dueDate
                                                                         title:@"Buy groceries"];
    
    [self.presenter foundUpcomingItems:@[groceries]];
}


- (void)testAddNewToDoItemActionPresentsAddToDoUI
{
    [[self.wireframe expect] presentAddInterface];
    
    [self.presenter addNewEntry];
}


#pragma mark -

- (VTDUpcomingDisplayData *)displayDataWithSectionName:(NSString *)sectionName
                                     sectionImageName:(NSString *)sectionImageName
                                            itemTitle:(NSString *)itemTitle
                                           itemDueDay:(NSString *)itemDueDay
{
    VTDUpcomingDisplayItem *displayItem = [VTDUpcomingDisplayItem upcomingDisplayItemWithTitle:itemTitle dueDay:itemDueDay];
    VTDUpcomingDisplaySection *todaySection = [VTDUpcomingDisplaySection upcomingDisplaySectionWithName:sectionName imageName:sectionImageName items:@[displayItem]];
    
    return [VTDUpcomingDisplayData upcomingDisplayDataWithSections:@[todaySection]];
}

@end
