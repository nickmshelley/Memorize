//
//  UserDataController.m
//  Memorize
//
//  Created by Nick Shelley on 4/9/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "Memorize-Swift.h"

#import "UserDataController.h"
#import <YapDatabase/YapDatabase.h>
#import "Card.h"
#import "ReviewState.h"
#import "NSDate+Helpers.h"

NSString *const kCardsCollection = @"Cards";
NSString *const kNumberOfNormalCardsReviewedToday = @"numberOfNormalCardsReviewedToday";
NSString *const kNumberOfReverseCardsReviewedToday = @"numberOfReverseCardsReviewedToday";
NSString *const kLastNormalReviewRefresh = @"lastNormalReviewRefresh";
NSString *const kLastReverseReviewRefresh = @"lastReverseReviewRefresh";

const NSInteger kNumberOfNormalCardsToReview = 30;
const NSInteger kNumberOfReverseCardsToReview = 32;

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
    NSInteger cardsLeft = kNumberOfNormalCardsToReview;
    if ([self isFirstNormalReviewToday]) {
        [self updateLastNormalRefresh];
        NSInteger oneDayers = [self numberOfOneDayNormalReviewCardsFromCards:cards];
        if (oneDayers < 5) {
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
        cards = [self sampledCardsFromCards:cards sampleNumber:cardsLeft isNormalReview:YES];
    }
    
    return cards;
}

- (NSArray *)todaysReverseReviewCards {
    NSArray *cards = [[self reviewingCards] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"reverseReviewState.nextReviewDate <= %@", [NSDate date]]];
    NSInteger cardsLeft = kNumberOfReverseCardsToReview;
    if (![self isFirstReverseReviewToday]) {
        cardsLeft -= [self reverseCardsReviewedToday];
    } else {
        [self updateLastReverseRefresh];
    }
    if (cards.count > cardsLeft) {
        cards = [self sampledCardsFromCards:cards sampleNumber:cardsLeft isNormalReview:NO];
    }
    
    return cards;
}

- (BOOL)isFirstNormalReviewToday {
    __block NSDate *lastRefresh = nil;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        lastRefresh = [transaction objectForKey:kLastNormalReviewRefresh inCollection:nil];
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
        lastRefresh = [transaction objectForKey:kLastReverseReviewRefresh inCollection:nil];
    }];
    
    BOOL isFirst = YES;
    if (lastRefresh && ([lastRefresh compare:[NSDate threeAMToday]] == NSOrderedDescending)) {
        isFirst = NO;
    }
    
    return isFirst;
}

- (void)updateLastNormalRefresh {
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:[NSDate date] forKey:kLastNormalReviewRefresh inCollection:nil];
        [transaction setObject:@(0) forKey:kNumberOfNormalCardsReviewedToday inCollection:nil];
    }];
}

- (void)updateLastReverseRefresh {
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:[NSDate date] forKey:kLastReverseReviewRefresh inCollection:nil];
        [transaction setObject:@(0) forKey:kNumberOfReverseCardsReviewedToday inCollection:nil];
    }];
}

- (NSInteger)normalCardsReviewedToday {
    __block NSInteger cardsReviewed = 0;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        cardsReviewed = [[transaction objectForKey:kNumberOfNormalCardsReviewedToday inCollection:nil] integerValue];
    }];
    
    return cardsReviewed;
}

- (NSInteger)reverseCardsReviewedToday {
    __block NSInteger cardsReviewed = 0;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        cardsReviewed = [[transaction objectForKey:kNumberOfReverseCardsReviewedToday inCollection:nil] integerValue];
    }];
    
    return cardsReviewed;
}

- (void)incrementNormalCardsReviewedToday {
    NSInteger currentNumber = [self normalCardsReviewedToday];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:@(currentNumber + 1) forKey:kNumberOfNormalCardsReviewedToday inCollection:nil];
    }];
}

- (void)incrementReverseCardsReviewedToday {
    NSInteger currentNumber = [self reverseCardsReviewedToday];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:@(currentNumber + 1) forKey:kNumberOfReverseCardsReviewedToday inCollection:nil];
    }];
}

- (void)decrementNormalCardsReviewedToday {
    NSInteger currentNumber = [self normalCardsReviewedToday];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:@(currentNumber - 1) forKey:kNumberOfNormalCardsReviewedToday inCollection:nil];
    }];
}

- (void)decrementReverseCardsReviewedToday {
    NSInteger currentNumber = [self reverseCardsReviewedToday];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:@(currentNumber - 1) forKey:kNumberOfReverseCardsReviewedToday inCollection:nil];
    }];
}


- (Card *)randomNonReviewingCard {
    Card *card = nil;
    NSArray *notReviewingCards = self.notReviewingCards;
    if (notReviewingCards.count > 0) {
        card = notReviewingCards[arc4random_uniform((u_int32_t)notReviewingCards.count)];
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

- (void)deleteCard:(Card *)card {
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:nil forKey:card.cardID inCollection:kCardsCollection];
    }];
}

@end
