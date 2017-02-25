//
//  ThreeColumnTableViewCell.h
//  Memorize
//
//  Created by Nick Shelley on 4/27/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeColumnTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end
