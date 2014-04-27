//
//  Card.m
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "Card.h"
#import "UserDataController.h"

@implementation Card

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

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

- (void)updateQuestion:(NSString *)question {
    self.question = question;
    [[UserDataController sharedController] updateCard:self];
}

- (void)updateAnswer:(NSString *)answer {
    self.answer = answer;
    [[UserDataController sharedController] updateCard:self];
}

- (void)updateIsReviewing:(BOOL)isReviewing {
    self.isReviewing = isReviewing;
    [[UserDataController sharedController] updateCard:self];
}

@end
