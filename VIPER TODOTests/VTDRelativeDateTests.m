//
// VTDRelativeDateTests.m
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
#import "NSCalendar+CalendarAdditions.h"


@interface VTDRelativeDateTests : XCTestCase

@property (nonatomic, strong)   NSCalendar* calendar;

@end


@implementation VTDRelativeDateTests

- (void)setUp
{
    [super setUp];
    
    self.calendar = [NSCalendar gregorianCalendar];
}


- (void)testDateBeforeTodayIsOutOfBounds
{
    NSDate *date = [self.calendar dateWithYear:2000 month:1 day:1];
    NSDate *today = [self.calendar dateWithYear:2000 month:1 day:2];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationOutOfRange, @"%@ should be out of range", date);
}


- (void)testTodayRelatesAsToday
{
    NSDate *date = [self.calendar dateWithYear:2000 month:1 day:1];
    NSDate *today = [self.calendar dateWithYear:2000 month:1 day:1];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationToday, @"%@ should be today", date);
}


- (void)testTomorrowDuringTheSameWeekAsTodayRelatesAsTomorrow
{
    NSDate *date = [self.calendar dateWithYear:2004 month:1 day:3];
    NSDate *today = [self.calendar dateWithYear:2004 month:1 day:2];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationTomorrow, @"%@ should be tomorrow", date);
}


- (void)testTomorrowDuringNextWeekRelatesAsNextWeek
{
    NSDate *date = [self.calendar dateWithYear:2004 month:10 day:10];
    NSDate *today = [self.calendar dateWithYear:2004 month:10 day:9];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationNextWeek, @"%@ should be next week", date);
}


- (void)testDateAfterTomorrowButDuringTheSameWeekAsTodayRelatesAsLaterThisWeek
{
    NSDate *date = [self.calendar dateWithYear:2004 month:3 day:6];
    NSDate *today = [self.calendar dateWithYear:2004 month:3 day:2];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationLaterThisWeek, @"%@ should be later this week", date);
}


- (void)testDateDuringWeekAfterTodayRelatesAsNextWeek
{
    NSDate *date = [self.calendar dateWithYear:2004 month:7 day:11];
    NSDate *today = [self.calendar dateWithYear:2004 month:7 day:6];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationNextWeek, @"%@ should be next week", date);
}


- (void)testDateDuringWeekAfterTodayThatFallsInNextYearRelatesAsNextWeek
{
    NSDate *date = [self.calendar dateWithYear:2006 month:1 day:2];
    NSDate *today = [self.calendar dateWithYear:2005 month:12 day:29];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationNextWeek, @"%@ should be next week", date);
}


- (void)testDateBeyondNextWeekRelatesAsOutOfRange
{
    NSDate *date = [self.calendar dateWithYear:2005 month:9 day:25];
    NSDate *today = [self.calendar dateWithYear:2005 month:9 day:14];
    XCTAssertEqual([self.calendar nearTermRelationForDate:date relativeToToday:today], VTDNearTermDateRelationOutOfRange, @"%@ should be next week", date);
}


@end
