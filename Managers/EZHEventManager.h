//
//  EZHEventManager.h
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-29.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem+CoreDataProperties.h"

@import EventKit;

NS_ASSUME_NONNULL_BEGIN

typedef void (^EZHFetchRemindersCompletionBlock)(NSArray<EKReminder *>* _Nullable reminders);


@interface EZHEventManager : NSObject

+(id)sharedManager;

@property (nonatomic, strong) EKEventStore *eventStore;

@property (nonatomic, strong) EKCalendar *calendar;

@property (nonatomic, assign) BOOL isAccessToEventStoreGranted;

-(void)fetchReminderWith:(nullable EZHFetchRemindersCompletionBlock)block;

-(void)addReminder:(ToDoItem *)toDoItem;

-(BOOL)itemHasReminder:(NSString *)toDoItemTitle;

-(void)deleteReminderByToDoItemTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
