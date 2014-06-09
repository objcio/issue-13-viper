//
// VTDListInteractorTests.m
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
#import "VTDListInteractor.h"
#import "VTDListDataManager.h"
#import "VTDClock.h"
#import "VTDTodoItem.h"
#import "VTDUpcomingItem.h"
#import "NSCalendar+CalendarAdditions.h"
#import <OCMock/OCMock.h>


@interface VTDListInteractorTests : XCTestCase

@property (nonatomic, strong)   VTDListInteractor*  interactor;
@property (nonatomic, strong)   id                  dataManager;
@property (nonatomic, strong)   id                  clock;
@property (nonatomic, strong)   id                  output;
@property (nonatomic, strong)   NSDate*             today;
@property (nonatomic, strong)   NSDate*             endOfNextWeek;

@end


@implementation VTDListInteractorTests

- (void)setUp
{
    [super setUp];
    
    self.dataManager = [OCMockObject mockForClass:[VTDListDataManager class]];
    self.clock = [OCMockObject mockForProtocol:@protocol(VTDClock)];
    self.interactor = [[VTDListInteractor alloc] initWithDataManager:self.dataManager clock:self.clock];

    self.output = [OCMockObject mockForProtocol:@protocol(VTDListInteractorOutput)];
    self.interactor.output = self.output;
    
    NSCalendar *calendar = [NSCalendar gregorianCalendar];
    self.today = [calendar dateWithYear:2014 month:5 day:21];
    self.endOfNextWeek = [calendar dateWithYear:2014 month:5 day:31];
    
    [[[self.clock stub] andReturn:self.today] today];
}


- (void)tearDown
{
    [self.dataManager verify];
    [self.output verify];
    
    [super tearDown];
}


- (void)testFindingUpcomingItemsRequestsAllToDoItemsFromTodayThroughEndOfNextWeek
{
    [[self.dataManager expect] todoItemsBetweenStartDate:self.today endDate:self.endOfNextWeek completionBlock:OCMOCK_ANY];
    
    [self.interactor findUpcomingItems];
}


- (void)testFindingUpcomingItemsWithNilToDoItemsReturnsEmptyList
{
    [self dataStoreWillReturnToDoItems:nil];
    [self expectUpcomingItems:@[]];
    
    [self.interactor findUpcomingItems];
}


- (void)testFindingUpcomingItemsWithEmptyToDoItemsReturnsEmptyList
{
    [self dataStoreWillReturnToDoItems:@[]];
    [self expectUpcomingItems:@[]];
    
    [self.interactor findUpcomingItems];
}


- (void)testFindingUpcomingItemsWithOneItemDueTodayReturnsOneUpcomingItemsForToday
{
    NSArray *todoItems = @[[VTDTodoItem todoItemWithDueDate:self.today name:@"Item 1"]];
    [self dataStoreWillReturnToDoItems:todoItems];
    
    NSArray *upcomingItems = @[[VTDUpcomingItem upcomingItemWithDateRelation:VTDNearTermDateRelationToday dueDate:self.today title:@"Item 1"]];
    [self expectUpcomingItems:upcomingItems];
    
    [self.interactor findUpcomingItems];
}


#pragma mark -

- (void)dataStoreWillReturnToDoItems:(NSArray *)todoItems
{
    [[[self.dataManager stub]
      andDo:^(NSInvocation *invocation) {
          void (^completionBlock)(NSArray *todoItems) = NULL;
          [invocation getArgument:&completionBlock atIndex:4];
          completionBlock(todoItems);
      }]
     todoItemsBetweenStartDate:OCMOCK_ANY endDate:OCMOCK_ANY completionBlock:OCMOCK_ANY];
}


- (void)expectUpcomingItems:(NSArray *)upcomingItems
{
    [[self.output expect] foundUpcomingItems:upcomingItems];
}

@end
