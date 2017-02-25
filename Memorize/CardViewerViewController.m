//
//  CardViewerViewController.m
//  Memorize
//
//  Created by Nick Shelley on 4/20/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "CardViewerViewController.h"
#import "Card.h"
#import "TextEditorViewController.h"

@interface CardViewerViewController ()
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;

@end

@implementation CardViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *questionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questionTapped)];
    [questionTap setNumberOfTapsRequired:1];
    [self.questionTextView addGestureRecognizer:questionTap];
    
    UITapGestureRecognizer *answerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerTapped)];
    [answerTap setNumberOfTapsRequired:1];
    [self.answerTextView addGestureRecognizer:answerTap];
    
    self.questionTextView.text = self.existingCard.question ?: @"Touch to edit question.";
    self.answerTextView.text = self.existingCard.answer ?: @"Touch to edit answer.";
}

- (void)questionTapped {
    [self performSegueWithIdentifier:@"TextEditorSegue" sender:@"question"];
}

- (void)answerTapped {
    [self performSegueWithIdentifier:@"TextEditorSegue" sender:@"answer"];
}

- (void)editQuestion:(NSString *)text {
    if (!self.existingCard) {
        self.existingCard = [[Card alloc] init];
    }
    
    [self.existingCard updateQuestion:text];
    self.questionTextView.text = text;
}

- (void)editAnswer:(NSString *)text {
    if (!self.existingCard) {
        self.existingCard = [[Card alloc] init];
    }
    
    [self.existingCard updateAnswer:text];
    self.answerTextView.text = text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TextEditorSegue"]) {
        TextEditorViewController *editor = segue.destinationViewController;
        if ([sender isEqualToString:@"question"]) {
            editor.existingText = self.existingCard.question;
            editor.saveBlock = ^void(NSString *text) {
                [self editQuestion:text];
            };
        } else {
            editor.existingText = self.existingCard.answer;
            editor.saveBlock = ^void(NSString *text) {
                [self editAnswer:text];
            };
        }
    }
}

@end
