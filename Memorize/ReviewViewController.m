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
#import "UndoObject.h"

@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIButton *questionButton;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (strong, nonatomic) IBOutlet UIButton *correctButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIButton *missedButton;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) Card *currentCard;
@property (nonatomic, strong) NSMutableArray *undoStack;

@end

@implementation ReviewViewController


- (void)viewDidLoad {
    self.undoStack = [NSMutableArray array];
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
    BOOL hasCurrentCard = self.currentCard ? YES : NO;
    switch (self.reviewType) {
        case ReviewTypeNormal:
            self.title = [NSString stringWithFormat:@"Review (%@)", @(self.cards.count)];
            self.questionButton.enabled = NO;
            self.answerButton.enabled = hasCurrentCard;
            self.answerTextView.hidden = YES;
            self.answerTextView.text = self.currentCard.answer;
            break;
        case ReviewTypeReverse:
            self.title = [NSString stringWithFormat:@"Review Reverse (%@)", @(self.cards.count)];
            self.answerButton.enabled = NO;
            self.questionButton.enabled = hasCurrentCard;
            self.questionLabel.hidden = YES;
            self.answerTextView.text = [[self.currentCard.answer componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] componentsJoinedByString:@" "];
            break;
    }
    self.questionLabel.text = self.currentCard.question;
    self.editButton.enabled = hasCurrentCard;
    self.correctButton.enabled = NO;
    self.missedButton.enabled = NO;
    self.undoButton.enabled = (self.undoStack.count > 0);
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
    UndoObject *undo = [[UndoObject alloc] init];
    undo.card = [self.currentCard copy];
    undo.correct = YES;
    [self.undoStack addObject:undo];
    [self.currentCard updateCorrectForReviewType:self.reviewType];
    [self.cards removeObject:self.currentCard];
    [self updateCurrentCard];
}

- (IBAction)missedPressed:(id)sender {
    UndoObject *undo = [[UndoObject alloc] init];
    undo.card = [self.currentCard copy];
    undo.correct = NO;
    [self.undoStack addObject:undo];
    [self.currentCard updateMissedForReviewType:self.reviewType];
    [self updateCurrentCard];
}

- (IBAction)undoPressed {
    if (self.undoStack.count > 0) {
        UndoObject *undo = self.undoStack.lastObject;
        [self.undoStack removeObject:undo];
        Card *card = undo.card;
        [card synchronize];
        [self removeCardWithCardID:card.cardID];
        [self.cards addObject:card];
        self.currentCard = card;
        if (undo.correct) {
            switch (self.reviewType) {
                case ReviewTypeNormal:
                    [[UserDataController sharedController] decrementNormalCardsReviewedToday];
                    break;
                case ReviewTypeReverse:
                    [[UserDataController sharedController] decrementReverseCardsReviewedToday];
                    break;
            }
        }
        [self updateUI];
    }
}

- (void)removeCardWithCardID:(NSString *)cardID {
    for (Card *card in self.cards) {
        if ([card.cardID isEqualToString:cardID]) {
            [self.cards removeObject:card];
            break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CardViewerViewController class]]) {
        [segue.destinationViewController setExistingCard:self.currentCard];
    }
}

- (void)updateCurrentCard {
    if (self.cards.count > 0) {
        self.currentCard = self.cards[arc4random_uniform((u_int32_t)self.cards.count)];
    } else {
        self.currentCard = nil;
    }
    
    [self updateUI];
}

@end
