//
//  UndoObject.h
//  Memorize
//
//  Created by Heather Shelley on 5/18/14.
//  Copyright (c) 2014 Mine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface UndoObject : NSObject

@property (nonatomic, strong) Card *card;
@property (nonatomic, assign) BOOL correct;

@end
