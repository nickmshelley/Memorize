//
//  ReviewState.m
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "ReviewState.h"

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

@end
