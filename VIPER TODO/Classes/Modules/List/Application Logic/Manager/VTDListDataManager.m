//
// MMTODODataManager.m
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

#import "VTDListDataManager.h"

#import "VTDManagedTodoItem.h"
#import "VTDCoreDataStore.h"
#import "VTDTodoItem.h"
#import "NSCalendar+CalendarAdditions.h"
#import "NSArray+HOM.h"


@implementation VTDListDataManager

- (void)todoItemsBetweenStartDate:(NSDate *)startDate
                          endDate:(NSDate *)endDate
                  completionBlock:(void (^)(NSArray *todoItems))completionBlock
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [calendar dateForBeginningOfDay:startDate], [calendar dateForEndOfDay:endDate]];
    NSArray *sortDescriptors = @[];
    
    __weak typeof(self) welf = self;
    [self.dataStore
     fetchEntriesWithPredicate:predicate
     sortDescriptors:sortDescriptors
     completionBlock:^(NSArray *entries) {
         if (completionBlock)
         {
             completionBlock([welf todoItemsFromDataStoreEntries:entries]);
         }
     }];
}


- (NSArray *)todoItemsFromDataStoreEntries:(NSArray *)entries
{
    return [entries arrayFromObjectsCollectedWithBlock:^id(VTDManagedTodoItem *todo) {
        return [VTDTodoItem todoItemWithDueDate:todo.date name:todo.name];
    }];
}

@end
