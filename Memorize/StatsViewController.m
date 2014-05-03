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
@property (nonatomic, strong) NSDictionary *reviewDay;
@property (nonatomic, assign) NSInteger readyCards;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [self processCards];
}

- (void)processCards {
    NSMutableDictionary *reviewLevel = [NSMutableDictionary dictionary];
    NSMutableDictionary *reviewDay = [NSMutableDictionary dictionary];
    NSInteger readyCards = 0;
    for (Card *card in [[UserDataController sharedController] reviewingCards]) {
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
        
        NSMutableDictionary *dayDict = reviewDay[@(reviewState.numSuccesses)];
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
        reviewLevel[@(reviewState.numSuccesses)] = dayDict;
    }
    
    self.reviewLevel = reviewLevel;
    self.reviewDay = reviewDay;
    self.readyCards = readyCards;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [[self.reviewLevel.allKeys valueForKeyPath:@"@max.self"] intValue];
            break;
        case 2:
            return [[self.reviewDay.allKeys valueForKeyPath:@"@max.self"] intValue];;
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
            cell.leftLabel.text = @"Cards Ready to Review:";
            cell.middleLabel.text = @"";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@", @(self.readyCards)];
            break;
        }
        case 1: {
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"Review Level";
                cell.middleLabel.text = @"Total";
                cell.rightLabel.text = @"Needs Review";
            } else {
                NSNumber *reviewLevel = @(indexPath.row - 1);
                NSNumber *total = self.reviewLevel[reviewLevel][@"total"] ?: @(0);
                NSNumber *needsReview = self.reviewLevel[reviewLevel][@"needsReview"] ?: @(0);
                cell.leftLabel.text = [NSString stringWithFormat:@"%@", reviewLevel];
                cell.middleLabel.text = [NSString stringWithFormat:@"%@", total];
                cell.rightLabel.text = [NSString stringWithFormat:@"%@", needsReview];
            }
        }
        case 2: {
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"Day Difference";
                cell.middleLabel.text = @"Total";
                cell.rightLabel.text = @"Needs Review";
            } else {
                NSNumber *dayDifference = @(indexPath.row);
                NSNumber *total = self.reviewDay[dayDifference][@"total"] ?: @(0);
                NSNumber *needsReview = self.reviewDay[dayDifference][@"needsReview"] ?: @(0);
                cell.leftLabel.text = [NSString stringWithFormat:@"%@", dayDifference];
                cell.middleLabel.text = [NSString stringWithFormat:@"%@", total];
                cell.rightLabel.text = [NSString stringWithFormat:@"%@", needsReview];
            }
        }
    }
    
    return cell;
}

@end
