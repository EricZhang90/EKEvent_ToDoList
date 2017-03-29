//
//  EZHCoreDataManager.h
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-28.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "ToDoItem+CoreDataProperties.h"


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const toDoItemName;

@interface EZHCoreDataManager : NSObject 

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (readonly, strong) NSManagedObjectContext *moc;


+(id)sharedManager;

-(NSArray<ToDoItem *> *)fetchAllToDoItems;

-(void)addToDoItemByTitle:(NSString *)title complete:(BOOL)isComplete priority:( NSUInteger)priority startDate:(nullable NSDate *)startDate dueDate:(nullable NSDate *)dueDate;

-(void)deleteToDoItemByTitle:(NSString *)itemTitle;

- (void)saveContext;

NS_ASSUME_NONNULL_END

@end
