//
//  ToDoItem+CoreDataProperties.h
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-28.
//  Copyright © 2017 lei zhang. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ToDoItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ToDoItem (CoreDataProperties)

+ (NSFetchRequest<ToDoItem *> *)fetchRequest;

@property (nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *dueDate;
@property (nonatomic) BOOL isCompleted;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nonatomic) int16_t priority;

@end

NS_ASSUME_NONNULL_END
