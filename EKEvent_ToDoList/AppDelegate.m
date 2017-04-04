//
//  AppDelegate.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-28.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "EZHCoreDataManager.h"
#import "EZHEventManager.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [EZHEventManager sharedManager];
  return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[EZHCoreDataManager sharedManager] saveContext];
}

@end
