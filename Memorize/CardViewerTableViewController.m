//
//  CardViewerTableViewController.m
//  Memorize
//
//  Created by Heather Shelley on 4/20/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "CardViewerTableViewController.h"
#import "UserDataController.h"
#import "Card.h"
#import "CardViewerViewController.h"

@interface CardViewerTableViewController ()

@property (nonatomic, strong) NSArray *nodes;

@end

@implementation CardViewerTableViewController

- (void)viewDidLoad {
    switch (self.viewType) {
        case ViewTypeReviewing:
            self.nodes = [[UserDataController sharedController] reviewingCards];
            break;
        case ViewTypeNotReviewing:
            self.nodes = [[UserDataController sharedController] notReviewingCards];
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Card *card = self.nodes[indexPath.row];
    cell.textLabel.text = card.question;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ViewCardFromTable" sender:self.nodes[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ViewCardFromTable"]) {
        [[segue destinationViewController] setExistingCard:sender];
    }
}

@end
