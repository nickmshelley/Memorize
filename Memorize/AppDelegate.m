//
//  AppDelegate.m
//  Memorize
//
//  Created by Heather Shelley on 9/28/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "Memorize-Swift.h"

#import "AppDelegate.h"
#import "UserDataController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasDoneInitialImport = [defaults boolForKey:@"initialImportDone"];
    if (!hasDoneInitialImport) {
        [[UserDataController sharedController] importInitialData];
    }
    
    [defaults setBool:YES forKey:@"initialImportDone"];
    [defaults synchronize];
    
    [SwiftTopLevel importSharedCards];
}

@end
