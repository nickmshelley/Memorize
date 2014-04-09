//
//  AppDelegate.m
//  Memorize
//
//  Created by Heather Shelley on 9/28/13.
//  Copyright (c) 2013 Mine. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/heather/Downloads/view-stats.json"];
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
