//
//  CardViewerViewController.m
//  Memorize
//
//  Created by Heather Shelley on 4/20/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import "CardViewerViewController.h"
#import "UserDataController.h"
#import "Card.h"

@interface CardViewerViewController ()

@property (nonatomic, strong) NSArray *nodes;

@end

@implementation CardViewerViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
