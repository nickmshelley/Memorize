//
//  ReviewViewController.m
//  Memorize
//
//  Created by Heather Shelley on 10/2/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewTabViewController.h"

@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation ReviewViewController


- (void)viewDidLoad {
    switch (self.reviewType) {
        case ReviewTypeNormal:
            self.answerLabel.hidden = YES;
            break;
        case ReviewTypeReverse:
            self.questionLabel.hidden = YES;
            break;
    }
    self.answerLabel.text = @"This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long. This is really long.";
}

- (IBAction)questionPressed:(id)sender {
    self.questionLabel.hidden = NO;
}

- (IBAction)answerPressed:(id)sender {
    self.answerLabel.hidden = NO;
}

- (IBAction)correctPressed:(id)sender {
    
}

- (IBAction)missedPressed:(id)sender {
    
}

@end
