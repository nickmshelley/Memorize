//
//  Card.m
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "Card.h"

@implementation Card

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.cardID = [aDecoder decodeObjectForKey:@"cardID"];
        self.question = [aDecoder decodeObjectForKey:@"question"];
        self.isReviewing = [aDecoder decodeBoolForKey:@"isReviewing"];
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
        self.normalReviewState = [aDecoder decodeObjectForKey:@"normalReviewState"];
        self.reverseReviewState = [aDecoder decodeObjectForKey:@"reverseReviewState"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cardID forKey:@"cardID"];
    [aCoder encodeObject:self.question forKey:@"question"];
    [aCoder encodeBool:self.isReviewing forKey:@"isReviewing"];
    [aCoder encodeObject:self.answer forKey:@"answer"];
    [aCoder encodeObject:self.normalReviewState forKey:@"normalReviewState"];
    [aCoder encodeObject:self.reverseReviewState forKey:@"reverseReviewState"];
}

@end
