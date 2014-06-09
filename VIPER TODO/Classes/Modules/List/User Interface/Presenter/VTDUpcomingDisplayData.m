//
// VTDUpcomingDisplayData.m
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

#import "VTDUpcomingDisplayData.h"


@interface VTDUpcomingDisplayData()
@property (nonatomic, copy) NSArray*    sections;
@end


@implementation VTDUpcomingDisplayData

+ (instancetype)upcomingDisplayDataWithSections:(NSArray *)sections
{
    VTDUpcomingDisplayData* data = [[VTDUpcomingDisplayData alloc] init];
    
    data.sections = sections;
    
    return data;
}


- (BOOL)isEqualToUpcomingDisplayData:(VTDUpcomingDisplayData *)data
{
    if (!data)
    {
        return NO;
    }
    
    BOOL hasEqualSections = [self.sections isEqualToArray:data.sections];
    
    return hasEqualSections;
}


- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:[VTDUpcomingDisplayData class]])
    {
        return NO;
    }
    
    return [self isEqualToUpcomingDisplayData:object];
}


- (NSUInteger)hash
{
    return [self.sections hash];
}

@end
