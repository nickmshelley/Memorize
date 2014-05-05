//
//  NSDate+Helpers.m
//  Memorize
//
//  Created by Heather Shelley on 5/3/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

+ (NSDate *)threeAMToday {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    return [[calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]] dateByAddingTimeInterval:(60 * 60 * 3)];
}

+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
