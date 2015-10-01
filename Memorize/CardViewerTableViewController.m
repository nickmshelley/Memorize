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
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count: %@", @(self.nodes.count));
    return self.nodes.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Card *card = self.nodes[indexPath.row];
        [[UserDataController sharedController] deleteCard:card];
        NSMutableArray *mutableNodes = [self.nodes mutableCopy];
        [mutableNodes removeObject:card];
        self.nodes = mutableNodes;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
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
