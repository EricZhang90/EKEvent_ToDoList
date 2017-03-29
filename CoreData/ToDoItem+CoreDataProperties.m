//
//  ToDoItem+CoreDataProperties.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-28.
//  Copyright © 2017 lei zhang. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ToDoItem+CoreDataProperties.h"

@implementation ToDoItem (CoreDataProperties)

+ (NSFetchRequest<ToDoItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ToDoItem"];
}

@dynamic title;
@dynamic dueDate;
@dynamic isCompleted;
@dynamic startDate;
@dynamic priority;

@end
