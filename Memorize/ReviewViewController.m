//
//  ReviewViewController.m
//  Memorize
//
//  Created by Heather Shelley on 10/2/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewTabViewController.h"
#import "NSDate+Helpers.h"
#import "Card.h"
#import "UserDataController.h"
#import "CardViewerViewController.h"

@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIButton *questionButton;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (strong, nonatomic) IBOutlet UIButton *correctButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *missedButton;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) Card *currentCard;

@end

@implementation ReviewViewController


- (void)viewDidLoad {
    switch (self.reviewType) {
        case ReviewTypeNormal:
            self.cards = [[[UserDataController sharedController] todaysNormalReviewCards] mutableCopy];
            break;
        case ReviewTypeReverse:
            self.cards = [[[UserDataController sharedController] todaysReverseReviewCards] mutableCopy];
            break;
    }
    
    [self updateCurrentCard];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateUI];
}

- (void)updateUI {
    switch (self.reviewType) {
        case ReviewTypeNormal:
            self.questionButton.enabled = NO;
            self.answerTextView.hidden = YES;
            self.answerTextView.text = self.currentCard.answer;
            break;
        case ReviewTypeReverse:
            self.answerButton.enabled = NO;
            self.questionLabel.hidden = YES;
            self.answerTextView.text = [[self.currentCard.answer componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] componentsJoinedByString:@" "];
            break;
    }
    self.remainingLabel.text = [NSString stringWithFormat:@"Remaining: %@", @(self.cards.count)];
    self.questionLabel.text = self.currentCard.question;
    self.editButton.enabled = self.currentCard ? YES : NO;
    self.correctButton.enabled = NO;
    self.missedButton.enabled = NO;
}

- (IBAction)questionPressed:(id)sender {
    self.questionLabel.hidden = NO;
    self.correctButton.enabled = YES;
    self.missedButton.enabled = YES;
}

- (IBAction)answerPressed:(id)sender {
    self.answerTextView.hidden = NO;
    self.correctButton.enabled = YES;
    self.missedButton.enabled = YES;
}

- (IBAction)correctPressed:(id)sender {
    [self.currentCard updateCorrectForReviewType:self.reviewType];
    [self.cards removeObject:self.currentCard];
    [self updateCurrentCard];
}

- (IBAction)missedPressed:(id)sender {
    [self.currentCard updateMissedForReviewType:self.reviewType];
    [self updateCurrentCard];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CardViewerViewController class]]) {
        [segue.destinationViewController setExistingCard:self.currentCard];
    }
}

- (void)updateCurrentCard {
    if (self.cards.count > 0) {
        self.currentCard = self.cards[arc4random_uniform(self.cards.count)];
    } else {
        self.currentCard = nil;
    }
    
    [self updateUI];
}

@end
