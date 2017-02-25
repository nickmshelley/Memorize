//
//  TextEditorViewController.m
//  Memorize
//
//  Created by Nick Shelley on 4/27/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "TextEditorViewController.h"

@interface TextEditorViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TextEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.existingText ?: @"";
    [self.textView becomeFirstResponder];
}

- (IBAction)cancelPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed {
    if (self.saveBlock) {
        self.saveBlock(self.textView.text);
        self.saveBlock = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
