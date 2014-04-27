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
