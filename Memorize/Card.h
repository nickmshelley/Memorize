//
//  Card.h
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "ReviewType.h"

@class ReviewState;

@interface Card : NSObject <NSCoding>

@property (nonatomic, strong) NSString *cardID;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, assign) BOOL isReviewing;
@property (nonatomic, strong) ReviewState *normalReviewState;
@property (nonatomic, strong) ReviewState *reverseReviewState;

- (void)updateQuestion:(NSString *)question;
- (void)updateAnswer:(NSString *)answer;
- (void)updateIsReviewing:(BOOL)isReviewing;
- (void)updateCorrectForReviewType:(ReviewType)reviewType;
- (void)updateMissedForReviewType:(ReviewType)reviewType;

@end
