//
// NSCalendar+CalendarAdditions.m
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

#import "NSCalendar+CalendarAdditions.h"


@implementation NSCalendar (CalendarAdditions)

+ (NSCalendar *)gregorianCalendar
{
	return [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
}


- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:12];
    
    return [self dateFromComponents:components];
}


- (NSDate *)dateForTomorrowRelativeToToday:(NSDate *)today
{
	// tomorrow is 1 day after today
	
	// create components for 1 day
	NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
	[tomorrowComponents setDay:1];
	
	// add the offset (1 day) to today
	return [self dateByAddingComponents:tomorrowComponents toDate:today options:0];
}


- (NSDate *)dateForEndOfWeekWithDate:(NSDate *)date
{
	NSInteger daysRemainingThisWeek = [self daysRemainingInWeekWithDate:date];

	NSDateComponents *remainingDaysComponent = [[NSDateComponents alloc] init];
	[remainingDaysComponent setDay:daysRemainingThisWeek];
	
	return [self dateByAddingComponents:remainingDaysComponent toDate:date options:0];
}


- (NSDate *)dateForBeginningOfDay:(NSDate *)date
{
    NSDateComponents *components = [self components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    return [self dateFromComponents:components];
}


- (NSDate *)dateForEndOfDay:(NSDate *)date
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSDate *nextDay = [self dateByAddingComponents:dayComponent toDate:[self dateForBeginningOfDay:date] options:0];
    
    return [nextDay dateByAddingTimeInterval:-1];
}


- (NSInteger)daysRemainingInWeekWithDate:(NSDate *)date
{
	NSDateComponents *weekdayComponent = [self components:NSWeekdayCalendarUnit fromDate:date];
    NSRange daysRange = [self rangeOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
	NSInteger daysPerWeek = daysRange.length;
    
	return daysPerWeek - [weekdayComponent weekday];
}


- (NSDate *)dateForEndOfFollowingWeekWithDate:(NSDate *)date
{
    NSDate *endOfWeek = [self dateForEndOfWeekWithDate:date];
    
	NSDateComponents *nextWeekComponent = [[NSDateComponents alloc] init];
	[nextWeekComponent setWeek:1];
	
	return [self dateByAddingComponents:nextWeekComponent toDate:endOfWeek options:0];
}


- (BOOL)isDate:(NSDate *)date1 beforeYearMonthDay:(NSDate *)date2
{
    return ([self compareYearMonthDay:date1 toYearMonthDay:date2] == NSOrderedAscending);
}


- (BOOL)isDate:(NSDate *)date1 equalToYearMonthDay:(NSDate *)date2
{
    return ([self compareYearMonthDay:date1 toYearMonthDay:date2] == NSOrderedSame);
}


- (BOOL)isDate:(NSDate *)date1 duringSameWeekAsDate:(NSDate *)date2
{
    NSDateComponents *components1 = [self components:NSWeekCalendarUnit fromDate:date1];
    NSDateComponents *components2 = [self components:NSWeekCalendarUnit fromDate:date2];
    
    return ([components1 week] == [components2 week]);
}


- (BOOL)isDate:(NSDate *)date1 duringWeekAfterDate:(NSDate *)date2
{
    NSDate *nextWeek = [self dateForEndOfFollowingWeekWithDate:date2];
    
    NSDateComponents *components1 = [self components:NSWeekCalendarUnit fromDate:date1];
    NSDateComponents *nextWeekComponents = [self components:NSWeekCalendarUnit fromDate:nextWeek];
    
    return ([components1 week] == [nextWeekComponents week]);
}


- (NSComparisonResult)compareYearMonthDay:(NSDate *)date1 toYearMonthDay:(NSDate *)date2
{
	NSParameterAssert(date1 != nil);
	NSParameterAssert(date2 != nil);
	
    NSComparisonResult result;
	
	// get the day/month/year for each date
	NSDateComponents *date1Components = [self yearMonthDayCompomentsFromDate:date1];
	NSDateComponents *date2Components = [self yearMonthDayCompomentsFromDate:date2];
    
	// compare the years
    result = CompareInteger([date1Components year], [date2Components year]);
    
    if (result == NSOrderedSame)
    {
		// the years are equal
		// we need to compare the months
        result = CompareInteger([date1Components month], [date2Components month]);
        
        if (result == NSOrderedSame)
        {
			// the months and years are equal
			// we need to compare the days
            result = CompareInteger([date1Components day], [date2Components day]);
		}
    }
    
    return result;
}


- (NSDateComponents *)yearMonthDayCompomentsFromDate:(NSDate *)date
{
    return [self components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
}


NSComparisonResult CompareInteger(NSInteger lhs, NSInteger rhs)
{
    NSComparisonResult result;
    
	// compare the two integers for =, <, >
    if (lhs == rhs)
    {
        result = NSOrderedSame;
	}
    else if (lhs < rhs)
    {
        result = NSOrderedAscending;
	}
    else
    {
        result = NSOrderedDescending;
	}
	
    return result;
}


- (VTDNearTermDateRelation)nearTermRelationForDate:(NSDate *)date relativeToToday:(NSDate *)today
{
    VTDNearTermDateRelation relation = VTDNearTermDateRelationOutOfRange;
    
    if ([self isDate:date beforeYearMonthDay:today])
    {
        relation = VTDNearTermDateRelationOutOfRange;
    }
    else if ([self isDate:date equalToYearMonthDay:today])
    {
        relation = VTDNearTermDateRelationToday;
    }
    else if ([self isDate:date equalToYearMonthDay:[self dateForTomorrowRelativeToToday:today]])
    {
        if ([self isDate:today duringSameWeekAsDate:date])
        {
            relation = VTDNearTermDateRelationTomorrow;
        }
        else
        {
            relation = VTDNearTermDateRelationNextWeek;
        }
    }
    else if ([self isDate:date duringSameWeekAsDate:today])
    {
        relation = VTDNearTermDateRelationLaterThisWeek;
    }
    else if ([self isDate:date duringWeekAfterDate:today])
    {
        relation = VTDNearTermDateRelationNextWeek;
    }
    
    return relation;
}

@end
