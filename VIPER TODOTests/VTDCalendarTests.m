//
// VTDCalendarTests.m
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


@interface VTDCalendarTests : XCTestCase

@property (nonatomic, strong)   NSCalendar* calendar;

@end


@implementation VTDCalendarTests

- (void)setUp
{
    [super setUp];
    
    self.calendar = [NSCalendar gregorianCalendar];
}


- (void)testEarlyYearMonthDayIsBeforeLaterYearMonthDay
{
    NSDate *earlyDate = [self.calendar dateWithYear:2004 month:2 day:29];
    NSDate *laterDate = [self.calendar dateWithYear:2004 month:3 day:1];
    
    XCTAssertTrue([self.calendar isDate:earlyDate beforeYearMonthDay:laterDate], @"%@ should be before %@", earlyDate, laterDate);
}


- (void)testYearMonthDayIsNotBeforeSameYearMonthDay
{
    NSDate *date1 = [self.calendar dateWithYear:2005 month:6 day:1];
    NSDate *date2 = [self.calendar dateWithYear:2005 month:6 day:1];
    
    XCTAssertFalse([self.calendar isDate:date1 beforeYearMonthDay:date2], @"%@ should not be before %@", date1, date2);
}


- (void)testLaterYearMonthDayIsNotBeforeEarlyYearMonthDay
{
    NSDate *earlyDate = [self.calendar dateWithYear:2006 month:4 day:15];
    NSDate *laterDate = [self.calendar dateWithYear:2006 month:4 day:16];
    
    XCTAssertFalse([self.calendar isDate:laterDate beforeYearMonthDay:earlyDate], @"%@ should not be before %@", laterDate, earlyDate);
}


- (void)testEqualYearMonthDaysCompareAsEqual
{
    NSDate *date1 = [self.calendar dateWithYear:2005 month:6 day:1];
    NSDate *date2 = [self.calendar dateWithYear:2005 month:6 day:1];
    
    XCTAssertTrue([self.calendar isDate:date1 equalToYearMonthDay:date2], @"%@ should equal %@", date1, date2);
}


- (void)testDifferentYearMonthDaysCompareAsNotEqual
{
    NSDate *date1 = [self.calendar dateWithYear:2005 month:6 day:1];
    NSDate *date2 = [self.calendar dateWithYear:2005 month:6 day:2];
    
    XCTAssertFalse([self.calendar isDate:date1 equalToYearMonthDay:date2], @"%@ should not equal %@", date1, date2);
}


- (void)testEndOfNextWeekDuringSameYear
{
    NSDate *date = [self.calendar dateWithYear:2005 month:8 day:2];
    NSDate *expectedNextWeek = [self.calendar dateWithYear:2005 month:8 day:13];
    
    NSDate *nextWeek = [self.calendar dateForEndOfFollowingWeekWithDate:date];
    
    XCTAssertTrue([self.calendar isDate:nextWeek equalToYearMonthDay:expectedNextWeek], @"next week should end on %@ (not %@)", expectedNextWeek, nextWeek);
}


- (void)testEndOfNextWeekDuringFollowingYear
{
    NSDate *date = [self.calendar dateWithYear:2005 month:12 day:27];
    NSDate *expectedNextWeek = [self.calendar dateWithYear:2006 month:1 day:7];
    
    NSDate *nextWeek = [self.calendar dateForEndOfFollowingWeekWithDate:date];
    
    XCTAssertTrue([self.calendar isDate:nextWeek equalToYearMonthDay:expectedNextWeek], @"next week should end on %@ (not %@)", expectedNextWeek, nextWeek);
}

@end
