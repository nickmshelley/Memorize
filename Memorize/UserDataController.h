//
//  UserDataController.h
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

@class Card;

#import <CWLSynthesizeSingleton/CWLSynthesizeSingleton.h>

@interface UserDataController : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(UserDataController, sharedController);

- (void)importInitialData;
- (NSArray *)allCards;
- (NSArray *)reviewingCards;
- (NSArray *)notReviewingCards;
- (NSArray *)todaysNormalReviewCards;
- (NSArray *)todaysReverseReviewCards;
- (void)updateCard:(Card *)card;
- (void)incrementNormalCardsReviewedToday;
- (void)incrementReverseCardsReviewedToday;
- (void)decrementNormalCardsReviewedToday;
- (void)decrementReverseCardsReviewedToday;

@end
