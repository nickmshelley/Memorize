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

@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) Card *currentCard;

@end

@implementation ReviewViewController


- (void)viewDidLoad {
    switch (self.reviewType) {
        case ReviewTypeNormal:
            self.answerTextView.hidden = YES;
            self.cards = [[UserDataController sharedController] todaysNormalReviewCards];
            break;
        case ReviewTypeReverse:
            self.questionLabel.hidden = YES;
            self.cards = [[UserDataController sharedController] todaysReverseReviewCards];
            break;
    }
    
    if (self.cards.count > 0) {
        self.currentCard = self.cards[arc4random_uniform(self.cards.count)];
    }
    
    self.remainingLabel.text = [NSString stringWithFormat:@"Remaining: %d", self.cards.count];
    self.questionLabel.text = self.currentCard.question;
    self.answerTextView.text = self.currentCard.answer;
}

- (IBAction)questionPressed:(id)sender {
    self.questionLabel.hidden = NO;
}

- (IBAction)answerPressed:(id)sender {
    self.answerTextView.hidden = NO;
}

- (IBAction)correctPressed:(id)sender {
    
}

- (IBAction)missedPressed:(id)sender {
    
}

@end
