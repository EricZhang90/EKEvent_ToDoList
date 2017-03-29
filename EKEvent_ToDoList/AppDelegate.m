//
//  AppDelegate.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-28.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "EZHCoreDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[EZHCoreDataManager sharedManager] saveContext];
}

@end
