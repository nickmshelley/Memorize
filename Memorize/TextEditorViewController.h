//
//  TextEditorViewController.h
//  Memorize
//
//  Created by Heather Shelley on 4/27/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEditorViewController : UIViewController

@property (nonatomic, copy) NSString *existingText;
@property (nonatomic, copy) void (^saveBlock)(NSString *text);

@end
