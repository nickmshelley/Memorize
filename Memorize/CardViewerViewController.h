//
//  CardViewerViewController.h
//  Memorize
//
//  Created by Heather Shelley on 4/20/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

typedef NS_ENUM(NSInteger, ViewType) {
    ViewTypeReviewing,
    ViewTypeNotReviewing
};

@interface CardViewerViewController : UITableViewController

@property (nonatomic, assign) ViewType viewType;

@end
