//
//  NSDate+Helpers.m
//  Memorize
//
//  Created by Nick Shelley on 5/3/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

+ (NSDate *)threeAMToday {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSInteger hour = [[calendar components:NSCalendarUnitHour fromDate:date] hour];
    NSInteger secondsToSubtract = hour < 3 ? 60 * 60 * 24 : 0;
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    return [[calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]] dateByAddingTimeInterval:(60 * 60 * 3 - secondsToSubtract)];
}

@end
