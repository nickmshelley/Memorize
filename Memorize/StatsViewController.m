//
//  StatsViewController.m
//  Memorize
//
//  Created by Heather Shelley on 9/30/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "StatsViewController.h"
#import "ThreeColumnTableViewCell.h"
#import "Card.h"
#import "ReviewState.h"
#import "UserDataController.h"

@interface StatsViewController ()

@property (nonatomic, strong) NSDictionary *reviewLevel;
@property (nonatomic, strong) NSArray *reviewLevelOrderedKeys;
@property (nonatomic, strong) NSDictionary *reviewDay;
@property (nonatomic, strong) NSArray *reviewDayOrderedKeys;
@property (nonatomic, assign) NSInteger readyCards;
@property (nonatomic, assign) NSInteger totalCards;
@property (nonatomic, assign) double averagePerDay;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self processCards];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self processCards];
    [self.tableView reloadData];
}

- (void)processCards {
    NSMutableDictionary *reviewLevel = [NSMutableDictionary dictionary];
    NSMutableDictionary *reviewDay = [NSMutableDictionary dictionary];
    NSArray *reviewingCards = [[UserDataController sharedController] reviewingCards];
    NSInteger readyCards = 0;
    double reviewPerDay = 0;
    for (Card *card in reviewingCards) {
        ReviewState *reviewState = nil;
        switch (self.reviewType) {
            case ReviewTypeNormal:
                reviewState = card.normalReviewState;
                break;
            case ReviewTypeReverse:
                reviewState = card.reverseReviewState;
                break;
        }
        
        NSMutableDictionary *levelDict = reviewLevel[@(reviewState.numSuccesses)];
        if (!levelDict) {
            levelDict = [@{@"total": @(0), @"needsReview": @(0)} mutableCopy];
        }
        levelDict[@"total"] = @([levelDict[@"total"] integerValue] + 1);
        
        NSMutableDictionary *dayDict = reviewDay[@([reviewState dayDifference])];
        if (!dayDict) {
            dayDict = [@{@"total": @(0), @"needsReview": @(0)} mutableCopy];
        }
        dayDict[@"total"] = @([dayDict[@"total"] integerValue] + 1);
        
        if ([reviewState needsReview]) {
            readyCards += 1;
            levelDict[@"needsReview"] = @([levelDict[@"needsReview"] integerValue] + 1);
            dayDict[@"needsReview"] = @([dayDict[@"needsReview"] integerValue] + 1);
        }
        
        reviewLevel[@(reviewState.numSuccesses)] = levelDict;
        reviewDay[@([reviewState dayDifference])] = dayDict;
        reviewPerDay += 1.0 / (double)[reviewState dayDifference];
    }
    
    self.reviewLevel = reviewLevel;
    self.reviewLevelOrderedKeys = [self.reviewLevel.allKeys sortedArrayUsingSelector:@selector(compare:)];
    self.reviewDay = reviewDay;
    self.reviewDayOrderedKeys = [self.reviewDay.allKeys sortedArrayUsingSelector:@selector(compare:)];
    self.readyCards = readyCards;
    self.totalCards = reviewingCards.count;
    self.averagePerDay = reviewPerDay;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return self.reviewLevel.count + 1;
            break;
        case 2:
            return self.reviewDay.count + 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreeColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    cell.leftLabel.text = @"Total Cards:";
                    cell.middleLabel.text = @"";
                    cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(self.totalCards)];
                    break;
                case 1:
                    cell.leftLabel.text = @"Cards Ready to Review:";
                    cell.middleLabel.text = @"";
                    cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(self.readyCards)];
                    break;
                case 2:
                    cell.leftLabel.text = @"Average per Day:";
                    cell.middleLabel.text = @"";
                    cell.rightLabel.text = [NSString stringWithFormat:@"%.2lf", self.averagePerDay];
            }
            if (indexPath.row == 0) {
                
            } else {
                
            }
            
            break;
        }
        case 1: {
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"Review Level";
                cell.middleLabel.text = @"Total";
                cell.rightLabel.text = @"Needs Review";
            } else {
                NSNumber *reviewLevel = self.reviewLevelOrderedKeys[indexPath.row - 1];
                NSNumber *total = self.reviewLevel[reviewLevel][@"total"] ?: @(0);
                NSNumber *needsReview = self.reviewLevel[reviewLevel][@"needsReview"] ?: @(0);
                cell.leftLabel.text = [NSString stringWithFormat:@"%@", reviewLevel];
                cell.middleLabel.text = [NSString stringWithFormat:@"%@", total];
                cell.rightLabel.text = [NSString stringWithFormat:@"%@", needsReview];
            }
            break;
        }
        case 2: {
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"Day Difference";
                cell.middleLabel.text = @"Total";
                cell.rightLabel.text = @"Needs Review";
            } else {
                NSNumber *dayDifference = self.reviewDayOrderedKeys[indexPath.row - 1];
                NSNumber *total = self.reviewDay[dayDifference][@"total"] ?: @(0);
                NSNumber *needsReview = self.reviewDay[dayDifference][@"needsReview"] ?: @(0);
                cell.leftLabel.text = [NSString stringWithFormat:@"%@", dayDifference];
                cell.middleLabel.text = [NSString stringWithFormat:@"%@", total];
                cell.rightLabel.text = [NSString stringWithFormat:@"%@", needsReview];
            }
            break;
        }
    }
    
    return cell;
}

@end
