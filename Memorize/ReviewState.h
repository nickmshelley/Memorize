//
//  ReviewState.h
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

@interface ReviewState : NSObject

@property (nonatomic, assign) NSUInteger numSuccesses;
@property (nonatomic, strong) NSDate *lastSuccess;
@property (nonatomic, strong) NSDate *nextReviewDate;

@end
