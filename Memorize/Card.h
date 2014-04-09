//
//  Card.h
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

@class ReviewState;

@interface Card : NSObject

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) ReviewState *normalReviewState;
@property (nonatomic, strong) ReviewState *reverseReviewState;

@end
