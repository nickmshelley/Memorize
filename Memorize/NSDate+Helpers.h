//
//  NSDate+Helpers.h
//  Memorize
//
//  Created by Heather Shelley on 5/3/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

+ (NSDate *)threeAMToday;
+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

@end
