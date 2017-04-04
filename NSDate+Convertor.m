//
//  NSDate+Convertor.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-04-03.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "NSDate+Convertor.h"

@implementation NSDate (Convertor)

-(NSDateComponents *)dateComponents {
  
  NSCalendar *gregorian = [[NSCalendar alloc]
                           initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
  
  return [gregorian components:unitFlags fromDate:self];
}

@end
