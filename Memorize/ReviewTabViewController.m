//
//  ReviewControllerViewController.m
//  Memorize
//
//  Created by Heather Shelley on 9/28/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "ReviewTabViewController.h"
#import "ReviewViewController.h"
#import "StatsViewController.h"

@interface ReviewTabViewController ()

@end

@implementation ReviewTabViewController

- (void)setReviewType:(ReviewType)reviewType {
    if (_reviewType != reviewType) {
        _reviewType = reviewType;
        [self configureView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView {
    switch (self.reviewType) {
        case ReviewTypeNormal:
            self.navigationItem.title = @"Review";
            [(ReviewViewController *)self.viewControllers[0] setReviewType:ReviewTypeNormal];
            [(StatsViewController *)self.viewControllers[1] setReviewType:ReviewTypeNormal];
            break;
        case ReviewTypeReverse:
            self.navigationItem.title = @"Review Reverse";
            [(ReviewViewController *)self.viewControllers[0] setReviewType:ReviewTypeReverse];
            [(StatsViewController *)self.viewControllers[1] setReviewType:ReviewTypeReverse];
            break;
    }
}

@end
