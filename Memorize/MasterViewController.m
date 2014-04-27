//
//  MasterViewController.m
//  Memorize
//
//  Created by Heather Shelley on 9/28/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "MasterViewController.h"
#import "ReviewTabViewController.h"
#import "CardViewerTableViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Normal"]) {
        [[segue destinationViewController] setReviewType:ReviewTypeNormal];
    } else if ([[segue identifier] isEqualToString:@"Reverse"]) {
        [[segue destinationViewController] setReviewType:ReviewTypeReverse];
    } else if ([[segue identifier] isEqualToString:@"Reviewing"]) {
        [[segue destinationViewController] setViewType:ViewTypeReviewing];
    } else if ([[segue identifier] isEqualToString:@"NotReviewing"]) {
        [[segue destinationViewController] setViewType:ViewTypeNotReviewing];
    }
}

@end
