//
//  EZHEventManager.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-29.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "EZHEventManager.h"
#import "EZHHelper.h"
#import "NSDate+Convertor.h"

// add kvo for isAccess?

@interface EZHEventManager ()

@property (nonatomic, nonnull, strong) NSArray<EKReminder *> *reminders;

@property (nonatomic, nonnull, strong) EKEventStore *eventStore;

@property (nonatomic, nonnull, strong) EKCalendar *calendar;

@property (nonatomic, assign) BOOL isAccessToEventStoreGranted;

-(void)updateAuthorizationStatus;

@end

@implementation EZHEventManager

+(id)sharedManager {
  static EZHEventManager* sharedEventManager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedEventManager = [[EZHEventManager alloc] init];
  });
  
  [sharedEventManager updateAuthorizationStatus];
  
  return sharedEventManager;
}

#pragma mark - private methods
-(void)updateAuthorizationStatus {
  EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
  
  switch (status) {
    case EKAuthorizationStatusDenied:
    case EKAuthorizationStatusNotDetermined:{
      __weak EZHEventManager *weakSelf = self;
      [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        weakSelf.isAccessToEventStoreGranted = granted;
      }];
      break;
    }
    case EKAuthorizationStatusRestricted: {
      self.isAccessToEventStoreGranted = NO;
      [EZHHelper promtAlertWithMsg:@"This App is not allowed to access to your reminder."];
      break;
    }
    case EKAuthorizationStatusAuthorized:
      self.isAccessToEventStoreGranted = YES;
    default:
      break;
  }
}


#pragma mark - getter/setter
@synthesize eventStore = _eventStore;

-(EKEventStore *)eventStore {
  if (!_eventStore) {
    _eventStore = [[EKEventStore alloc] init];
  }
  return _eventStore;
}

@synthesize calendar = _calendar;

-(EKCalendar *)calendar {
  if(!_calendar) {
    NSArray<EKCalendar *> *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
    
    NSString *calendarTitle = @"EZHToDo";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
    
    NSArray<EKCalendar *> *filteredCalendars = [calendars filteredArrayUsingPredicate:predicate];
    
    if ([filteredCalendars count]) {
      _calendar = [filteredCalendars firstObject];
    }
    else { // create a new calendar
      _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
      _calendar.title = calendarTitle;
      _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
      
      NSError *err;
      if (![self.eventStore saveCalendar:_calendar commit:YES error:&err]) {
        [EZHHelper promtAlertWithMsg:err.localizedDescription];
      }
    }
  }
  
  return _calendar;
}

-(void)fetchReminderWith:(EZHFetchRemindersCompletionBlock)block {
  if (!self.isAccessToEventStoreGranted) {
    return;
  }
  
  NSPredicate *predicate = [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
  
  [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
    self.reminders = reminders;
    if (block) {
      block(reminders);
    }
  }];
}

-(void)addReminder:(ToDoItem *)toDoItem {
  if (!self.isAccessToEventStoreGranted) {
    return;
  }
  
  EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
  reminder.title = toDoItem.title;
  reminder.calendar = self.calendar;
  reminder.priority = toDoItem.priority;
  reminder.dueDateComponents = toDoItem.dueDate.dateComponents;
  reminder.startDateComponents = toDoItem.startDate.dateComponents;
  
  NSError *err;
  NSString *msg;
  if ([self.eventStore saveReminder:reminder commit:YES error:&err]) {
    msg = @"Reminder was successfully added!";
    NSLog(@"%@", err.localizedDescription);
  }
  else {
    msg = @"Failed to add reminder!";
  }
  
  [EZHHelper promtAlertWithMsg:msg];
}

-(BOOL)itemHasReminder:(NSString *)toDoItemTitle {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", toDoItemTitle];
  
  NSArray<EKReminder *> *filteredReminders = [self.reminders filteredArrayUsingPredicate:predicate];
  
  return (self.isAccessToEventStoreGranted && [filteredReminders count]);
}

-(void)deleteReminderByToDoItemTitle:(NSString *)title {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", title];
  
  NSArray<EKReminder *> *results = [self.reminders filteredArrayUsingPredicate:predicate];
  
  if ([results count]) {
    [results enumerateObjectsUsingBlock:^(EKReminder * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSError *err;
      if (![self.eventStore removeReminder:obj commit:NO error:&err]) {
        [EZHHelper promtAlertWithMsg:[NSString stringWithFormat:@"The item %@ cannot be removed.", obj.title]];
        *stop = YES;
      }
    }];
  }
  
  NSError *commitErr;
  if (![self.eventStore commit:&commitErr]){
    [EZHHelper promtAlertWithMsg:commitErr.localizedDescription];
  }
}

@end




