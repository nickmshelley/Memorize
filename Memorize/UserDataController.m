//
//  UserDataController.m
//  Memorize
//
//  Created by Heather Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "UserDataController.h"
#import <YapDatabase/YapDatabase.h>
#import "Card.h"
#import "ReviewState.h"
#import "NSDate+Helpers.h"

NSString *const kCardsCollection = @"Cards";

@interface UserDataController ()

@property (nonatomic, strong) YapDatabase *database;
@property (nonatomic, strong) YapDatabaseConnection *connection;

@end

@implementation UserDataController

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(UserDataController, sharedController);

- (instancetype)init {
    self = [super init];
    if (self) {
        self.database = [[YapDatabase alloc] initWithPath:[self databasePath]];
        self.connection = [self.database newConnection];
    }
    
    return self;
}

- (void)importInitialData {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"existingCards" ofType:@"json"]];
    NSArray *existingCards = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        for (NSDictionary *cardDict in existingCards) {
            Card *card = [[Card alloc] init];
            card.question = cardDict[@"question"];
            card.answer = cardDict[@"answer"];
            [transaction setObject:card forKey:card.cardID inCollection:kCardsCollection];
        }
    }];
}

- (NSArray *)allCards {
    NSMutableArray *cards = [NSMutableArray array];
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        [transaction enumerateKeysAndObjectsInCollection:kCardsCollection usingBlock:^(NSString *key, id object, BOOL *stop) {
            [cards addObject:object];
        }];
    }];
    
    return [cards sortedArrayUsingComparator:^NSComparisonResult(Card *card1, Card *card2) {
        return [card1.question caseInsensitiveCompare:card2.question];
    }];
}

- (NSArray *)reviewingCards {
    return [[self allCards] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReviewing = %@", @YES]];
}

- (NSArray *)notReviewingCards {
    return [[self allCards] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isReviewing = %@", @NO]];
}

- (NSArray *)todaysNormalReviewCards {
    NSArray *cards = [[self reviewingCards] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"normalReviewState.nextReviewDate <= %@", [NSDate date]]];
    NSInteger cardsLeft = 30;
    if ([self isFirstNormalReviewToday]) {
        [self updateLastNormalRefresh];
        NSInteger numberOfCardsToAdd = 0;
        if (cards.count < 10) {
            numberOfCardsToAdd = 3;
        } else if (cards.count < 20) {
            numberOfCardsToAdd = 2;
        } else if (cards.count < 30) {
            numberOfCardsToAdd = 1;
        }
        for (int i = 0; i < numberOfCardsToAdd; i++) {
            Card *card = [self randomNonReviewingCard];
            [card updateIsReviewing:YES];
            if (card) {
                cards = [cards arrayByAddingObject:card];
            }
        }
    } else {
        cardsLeft -= [self normalCardsReviewedToday];
    }
    
    if (cards.count > cardsLeft) {
        cards = [cards sortedArrayUsingComparator:^NSComparisonResult(Card *card1, Card *card2) {
            NSInteger firstNumber = card1.normalReviewState.numSuccesses * 2 - abs([NSDate daysBetweenDate:card1.normalReviewState.nextReviewDate andDate:[NSDate date]]);
            if (!card1.normalReviewState.nextReviewDate) {
                firstNumber = -1000;
            }
            NSInteger secondNumber = card2.normalReviewState.numSuccesses * 2 - abs([NSDate daysBetweenDate:card2.normalReviewState.nextReviewDate andDate:[NSDate date]]);
            if (!card2.normalReviewState.nextReviewDate) {
                secondNumber = -1000;
            }
            return [@(firstNumber) compare:@(secondNumber)];
        }];
        
        cards = [cards subarrayWithRange:NSMakeRange(0, cardsLeft)];
    }
    
    return cards;
}

- (NSArray *)todaysReverseReviewCards {
    NSArray *cards = [[self reviewingCards] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"reverseReviewState.nextReviewDate <= %@", [NSDate date]]];
    NSInteger cardsLeft = 30;
    if (![self isFirstReverseReviewToday]) {
        cardsLeft -= [self reverseCardsReviewedToday];
    } else {
        [self updateLastReverseRefresh];
    }
    if (cards.count > cardsLeft) {
        cards = [cards sortedArrayUsingComparator:^NSComparisonResult(Card *card1, Card *card2) {
            NSInteger firstNumber = card1.reverseReviewState.numSuccesses * 2 - abs([NSDate daysBetweenDate:card1.reverseReviewState.nextReviewDate andDate:[NSDate date]]);
            if (!card1.reverseReviewState.nextReviewDate) {
                firstNumber = -1000;
            }
            NSInteger secondNumber = card2.reverseReviewState.numSuccesses * 2 - abs([NSDate daysBetweenDate:card2.reverseReviewState.nextReviewDate andDate:[NSDate date]]);
            if (!card2.reverseReviewState.nextReviewDate) {
                secondNumber = -1000;
            }
            return [@(firstNumber) compare:@(secondNumber)];
        }];
        
        cards = [cards subarrayWithRange:NSMakeRange(0, cardsLeft)];
    }
    
    return cards;
}

- (BOOL)isFirstNormalReviewToday {
    __block NSDate *lastRefresh = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        lastRefresh = [transaction objectForKey:@"lastNormalReviewRefresh" inCollection:nil];
    }];
    
    BOOL isFirst = YES;
    if (lastRefresh && ([lastRefresh compare:[NSDate threeAMToday]] == NSOrderedDescending)) {
        isFirst = NO;
    }
    
    return isFirst;
}

- (BOOL)isFirstReverseReviewToday {
    __block NSDate *lastRefresh = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        lastRefresh = [transaction objectForKey:@"lastReverseReviewRefresh" inCollection:nil];
    }];
    
    BOOL isFirst = YES;
    if (lastRefresh && ([lastRefresh compare:[NSDate threeAMToday]] == NSOrderedDescending)) {
        isFirst = NO;
    }
    
    return isFirst;
}

- (void)updateLastNormalRefresh {
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:[NSDate date] forKey:@"lastNormalReviewRefresh" inCollection:nil];
        [transaction setObject:@(0) forKey:@"normalCardsReviewedToday" inCollection:nil];
    }];
}

- (void)updateLastReverseRefresh {
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:[NSDate date] forKey:@"lastReverseReviewRefresh" inCollection:nil];
        [transaction setObject:@(0) forKey:@"reverseCardsReviewedToday" inCollection:nil];
    }];
}

- (NSInteger)normalCardsReviewedToday {
    __block NSInteger cardsReviewed = 0;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        cardsReviewed = [[transaction objectForKey:@"numberOfNormalCardsReviewedToday" inCollection:nil] integerValue];
    }];
    
    return cardsReviewed;
}

- (NSInteger)reverseCardsReviewedToday {
    __block NSInteger cardsReviewed = 0;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        cardsReviewed = [[transaction objectForKey:@"numberOfReverseCardsReviewedToday" inCollection:nil] integerValue];
    }];
    
    return cardsReviewed;
}

- (Card *)randomNonReviewingCard {
    Card *card = nil;
    NSArray *notReviewingCards = self.notReviewingCards;
    if (notReviewingCards.count > 0) {
        card = notReviewingCards[arc4random_uniform(notReviewingCards.count)];
    }
    
    return card;
}

- (NSString *)databasePath {
    NSURL *URL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [URL.path stringByAppendingPathComponent:@"data"];
}

- (void)updateCard:(Card *)card {
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:card forKey:card.cardID inCollection:kCardsCollection];
    }];
}

@end
