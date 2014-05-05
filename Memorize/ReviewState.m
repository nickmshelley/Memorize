//
//  ReviewState.m
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "ReviewState.h"
#import "NSDate+Helpers.h"

@implementation ReviewState

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.numSuccesses = [aDecoder decodeIntegerForKey:@"numSuccesses"];
        self.lastSuccess = [aDecoder decodeObjectForKey:@"lastSuccess"];
        self.nextReviewDate = [aDecoder decodeObjectForKey:@"nextReviewDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.numSuccesses forKey:@"numSuccesses"];
    [aCoder encodeObject:self.lastSuccess forKey:@"lastSuccess"];
    [aCoder encodeObject:self.nextReviewDate forKey:@"nextReviewDate"];
}

- (BOOL)needsReview {
    return ([self.nextReviewDate compare:[NSDate date]] != NSOrderedDescending);
}

- (void)updateCorrect {
    self.numSuccesses = self.numSuccesses + 1;
    self.lastSuccess = [NSDate date];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSInteger daysToAdd = [self dayDifference];
    dayComponent.day = daysToAdd;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    self.nextReviewDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate threeAMToday] options:0];
}

- (void)updateMissed {
    self.numSuccesses = 0;
    self.nextReviewDate = [NSDate threeAMToday];
}

- (NSInteger)dayDifference {
    return (int)pow(1.5, self.numSuccesses);
}

@end
