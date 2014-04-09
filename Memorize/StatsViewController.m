//
//  StatsViewController.m
//  Memorize
//
//  Created by Heather Shelley on 9/30/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Category" forIndexPath:indexPath];
            UILabel *left = (UILabel *)[cell viewWithTag:1];
            left.text = @"Cards Ready to Review:";
            UILabel *right = (UILabel *)[cell viewWithTag:3];
            right.text = @"1000";
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BigTable" forIndexPath:indexPath];
            UILabel *left = (UILabel *)[cell viewWithTag:1];
            left.text = @"Review Level";
            UILabel *middle = (UILabel *)[cell viewWithTag:2];
            middle.text = @"Total";
            UILabel *right = (UILabel *)[cell viewWithTag:3];
            right.text = @"Needs Review";
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SmallTable" forIndexPath:indexPath];
            UILabel *left = (UILabel *)[cell viewWithTag:1];
            left.text = @"Day Difference";
            UILabel *right = (UILabel *)[cell viewWithTag:3];
            right.text = @"Total";
            break;
        }
    }
    
    return cell;
}

@end
