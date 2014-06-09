//
// MMTODOInteractor.m
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

#import "VTDListInteractor.h"
#import "VTDListDataManager.h"
#import "VTDClock.h"
#import "VTDTodoItem.h"
#import "VTDUpcomingItem.h"
#import "NSArray+HOM.h"
#import "NSCalendar+CalendarAdditions.h"


@interface VTDListInteractor()

@property (nonatomic, strong)   VTDListDataManager *dataManager;
@property (nonatomic, strong)   id<VTDClock>        clock;

@end


@implementation VTDListInteractor

- (instancetype)initWithDataManager:(VTDListDataManager *)dataManager clock:(id<VTDClock>)clock
{
    if ((self = [super init]))
    {
        _dataManager = dataManager;
        _clock = clock;
    }
    
    return self;
}


- (void)findUpcomingItems
{
    __weak typeof(self) welf = self;
    NSDate *today = [self.clock today];
    NSDate *endOfNextWeek = [[NSCalendar currentCalendar] dateForEndOfFollowingWeekWithDate:today];
    
    [self.dataManager todoItemsBetweenStartDate:today endDate:endOfNextWeek completionBlock:^(NSArray *todoItems) {
        [welf.output foundUpcomingItems:[welf upcomingItemsFromToDoItems:todoItems]];
    }];
}


- (NSArray *)upcomingItemsFromToDoItems:(NSArray *)todoItems
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSArray *validTodoItems = (todoItems != nil) ? todoItems : @[];
    
    return [validTodoItems arrayFromObjectsCollectedWithBlock:^id(VTDTodoItem *todoItem) {
        VTDNearTermDateRelation relation = [calendar nearTermRelationForDate:todoItem.dueDate relativeToToday:[self.clock today]];
        
        return [VTDUpcomingItem upcomingItemWithDateRelation:relation dueDate:todoItem.dueDate title:todoItem.name];
    }];
}

@end
