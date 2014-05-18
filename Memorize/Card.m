//
//  Card.m
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "Card.h"
#import "UserDataController.h"
#import "ReviewState.h"
#import "NSDate+Helpers.h"

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
    [self synchronize];
}

- (void)updateAnswer:(NSString *)answer {
    self.answer = answer;
    [self synchronize];
}

- (void)updateIsReviewing:(BOOL)isReviewing {
    self.isReviewing = isReviewing;
    if (isReviewing) {
        self.normalReviewState = [[ReviewState alloc] init];
        self.normalReviewState.nextReviewDate = [NSDate threeAMToday];
        self.reverseReviewState = [[ReviewState alloc] init];
        self.reverseReviewState.nextReviewDate = [NSDate threeAMToday];
    }
    [self synchronize];
}

- (void)updateCorrectForReviewType:(ReviewType)reviewType {
    switch (reviewType) {
        case ReviewTypeNormal:
            [self.normalReviewState updateCorrect];
            [[UserDataController sharedController] incrementNormalCardsReviewedToday];
            break;
        case ReviewTypeReverse:
            [self.reverseReviewState updateCorrect];
            [[UserDataController sharedController] incrementReverseCardsReviewedToday];
            break;
    }
    [self synchronize];
}

- (void)updateMissedForReviewType:(ReviewType)reviewType {
    switch (reviewType) {
        case ReviewTypeNormal:
            [self.normalReviewState updateMissed];
            break;
        case ReviewTypeReverse:
            [self.reverseReviewState updateMissed];
            break;
    }
    [self synchronize];
}

- (id)copyWithZone:(NSZone *)zone {
    Card *card = [[Card alloc] init];
    card.cardID = [self.cardID copy];
    card.question = [self.question copy];
    card.answer = [self.answer copy];
    card.isReviewing = self.isReviewing;
    card.normalReviewState = [self.normalReviewState copy];
    card.reverseReviewState = [self.reverseReviewState copy];
    return card;
}

- (void)synchronize {
    [[UserDataController sharedController] updateCard:self];
}

@end
