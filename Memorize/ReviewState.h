//
//  ReviewState.h
//  Memorize
//
//  Created by Nick Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

@interface ReviewState : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger numSuccesses;
@property (nonatomic, strong) NSDate *lastSuccess;
@property (nonatomic, strong) NSDate *nextReviewDate;

- (BOOL)needsReview;
- (void)updateCorrect;
- (void)updateMissed;
- (NSInteger)dayDifference;

@end
