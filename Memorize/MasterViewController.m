//
//  MasterViewController.m
//  Memorize
//
//  Created by Heather Shelley on 9/28/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "MasterViewController.h"
#import "ReviewTabViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Normal"]) {
        [[segue destinationViewController] setReviewType:ReviewTypeNormal];
    } else {
        [[segue destinationViewController] setReviewType:ReviewTypeReverse];
    }
}

@end
