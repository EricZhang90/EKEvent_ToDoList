//
//  EZHHelper.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-04-03.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "EZHHelper.h"

@import UIKit;

@implementation EZHHelper

+(void)promtAlertWithMsg:(NSString *)msg {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  
  [alertController addAction:OK];
  
  UIWindow *window = [UIApplication sharedApplication].keyWindow;

  dispatch_async(dispatch_get_main_queue(), ^{
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
  });
}

@end
