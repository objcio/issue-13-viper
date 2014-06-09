//
// VTDUpcomingDisplayDataCollector.m
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

#import "VTDUpcomingDisplayDataCollector.h"
#import "VTDUpcomingItem.h"
#import "VTDUpcomingDisplayData.h"
#import "VTDUpcomingDisplaySection.h"
#import "VTDUpcomingDisplayItem.h"
#import "NSArray+HOM.h"


@interface VTDUpcomingDisplayDataCollector()

@property (nonatomic, strong)   NSDateFormatter*        dayFormatter;
@property (nonatomic, strong)   NSMutableDictionary*    sections;

@end


@implementation VTDUpcomingDisplayDataCollector

- (void)addUpcomingItems:(NSArray *)upcomingItems
{
    for (VTDUpcomingItem *upcomingItem in upcomingItems)
    {
        [self addUpcomingItem:upcomingItem];
    }
}


- (void)addUpcomingItem:(VTDUpcomingItem *)upcomingItem
{
    VTDUpcomingDisplayItem *displayItem = [self displayItemForUpcomingItem:upcomingItem];
    [self addDisplayItem:displayItem withDateRelation:upcomingItem.dateRelation];
}


- (VTDUpcomingDisplayItem *)displayItemForUpcomingItem:(VTDUpcomingItem *)upcomingItem
{
    NSString *formattedDay = [self formattedDay:upcomingItem.dueDate withDateRelation:upcomingItem.dateRelation];
    
    return [VTDUpcomingDisplayItem upcomingDisplayItemWithTitle:upcomingItem.title dueDay:formattedDay];
}


- (NSString *)formattedDay:(NSDate *)date withDateRelation:(VTDNearTermDateRelation)dateRelation
{
    return [self needsFormattedDayForDateRelation:dateRelation] ? [self.dayFormatter stringFromDate:date] : @"";
}


- (BOOL)needsFormattedDayForDateRelation:(VTDNearTermDateRelation)dateRelation
{
    return (dateRelation != VTDNearTermDateRelationToday);
}


- (void)addDisplayItem:(VTDUpcomingDisplayItem *)displayItem withDateRelation:(VTDNearTermDateRelation)dateRelation
{
    NSMutableArray *sectionItems = [self sectionItemsForDateRelation:dateRelation];
    [sectionItems addObject:displayItem];
}


- (NSMutableArray *)sectionItemsForDateRelation:(VTDNearTermDateRelation)dateRelation
{
    NSMutableDictionary *sections = self.sections;
    NSMutableArray *section = sections[@(dateRelation)];
    
    if (section == nil)
    {
        section = [NSMutableArray array];
        sections[@(dateRelation)] = section;
    }
    
    return section;
}


- (VTDUpcomingDisplayData *)collectedDisplayData
{
    NSArray *displaySections = [[self collectedSectionKeys] arrayFromObjectsCollectedWithBlock:^id(NSNumber *sectionKey) {
        return [self displaySectionForKey:sectionKey];
    }];
    
    return [VTDUpcomingDisplayData upcomingDisplayDataWithSections:displaySections];
}


- (NSArray *)collectedSectionKeys
{
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(compare:)];
}


- (VTDUpcomingDisplaySection *)displaySectionForKey:(NSNumber *)sectionKey
{
    VTDNearTermDateRelation dateRelation = [sectionKey unsignedIntegerValue];
    NSString *sectionTitle = [self sectionTitleForDateRelation:dateRelation];
    NSString *imageName = [self sectionImageNameForDateRelation:dateRelation];
    
    return [VTDUpcomingDisplaySection upcomingDisplaySectionWithName:sectionTitle
                                                           imageName:imageName
                                                               items:self.sections[sectionKey]];
}


- (NSString *)sectionImageNameForDateRelation:(VTDNearTermDateRelation)dateRelation
{
    switch (dateRelation)
    {
        case VTDNearTermDateRelationToday:
            return @"check";
            break;
            
        case VTDNearTermDateRelationTomorrow:
            return @"alarm";
            break;
            
        case VTDNearTermDateRelationLaterThisWeek:
            return @"circle";
            break;
            
        case VTDNearTermDateRelationNextWeek:
            return @"calendar";
            break;
            
        case VTDNearTermDateRelationOutOfRange:
            return @"paper";
            break;
    }
}


- (NSString *)sectionTitleForDateRelation:(VTDNearTermDateRelation)dateRelation
{
    switch (dateRelation)
    {
        case VTDNearTermDateRelationToday:
            return @"Today";
            break;

        case VTDNearTermDateRelationTomorrow:
            return @"Tomorrow";
            break;
            
        case VTDNearTermDateRelationLaterThisWeek:
            return @"Later This Week";
            break;
            
        case VTDNearTermDateRelationNextWeek:
            return @"Next Week";
            break;
            
        case VTDNearTermDateRelationOutOfRange:
            return @"Unknown";
            break;
    }
}


- (NSDateFormatter *)dayFormatter
{
    if (_dayFormatter == nil)
    {
        _dayFormatter = [[NSDateFormatter alloc] init];
        [_dayFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale autoupdatingCurrentLocale]]];
    }
    
    return _dayFormatter;
}


- (NSMutableDictionary *)sections
{
    if (_sections == nil)
    {
        _sections = [NSMutableDictionary dictionary];
    }
    
    return _sections;
}

@end
