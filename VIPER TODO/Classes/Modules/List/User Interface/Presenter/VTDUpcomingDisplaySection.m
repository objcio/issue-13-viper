//
// VTDUpcomingDisplaySection.m
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

#import "VTDUpcomingDisplaySection.h"


@interface VTDUpcomingDisplaySection()

@property (nonatomic, copy) NSString*   name;
@property (nonatomic, copy) NSString*   imageName;
@property (nonatomic, copy) NSArray*    items;

@end


@implementation VTDUpcomingDisplaySection

+ (instancetype)upcomingDisplaySectionWithName:(NSString *)name
                                     imageName:(NSString *)imageName
                                         items:(NSArray *)items
{
    VTDUpcomingDisplaySection *section = [[VTDUpcomingDisplaySection alloc] init];
    
    section.name = name;
    section.imageName = imageName;
    section.items = items;
    
    return section;
}


- (BOOL)isEqualToUpcomingDisplaySection:(VTDUpcomingDisplaySection *)section
{
    if (!section)
    {
        return NO;
    }
    
    BOOL hasEqualNames = [self.name isEqualToString:section.name];
    BOOL hasEqualImageNames = [self.imageName isEqualToString:section.imageName];
    BOOL hasEqualItems = [self.items isEqualToArray:section.items];
    
    return hasEqualNames && hasEqualImageNames && hasEqualItems;
}


- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:[VTDUpcomingDisplaySection class]])
    {
        return NO;
    }
    
    return [self isEqualToUpcomingDisplaySection:object];
}


- (NSUInteger)hash
{
    return [self.name hash] ^ [self.imageName hash] ^ [self.items hash];
}

@end
