//
//  EZHCoreDataManager.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-28.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "EZHCoreDataManager.h"

NSString *const toDoItemName = @"ToDoItem";

@implementation EZHCoreDataManager

#pragma mark - Singleton

+(id)sharedManager {
  static EZHCoreDataManager *sharedCoreDataManager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedCoreDataManager = [[self alloc] init];
  });
  
  return sharedCoreDataManager;
}

#pragma mark - fetch, add, delete

-(NSArray *)fetchAllToDoItems {
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  fetchRequest.entity = [NSEntityDescription entityForName:toDoItemName inManagedObjectContext:self.moc];
  fetchRequest.predicate = [NSPredicate predicateWithValue:YES];
  fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"idx" ascending:YES]];
  
  NSError *error = nil;
  NSArray<ToDoItem*> *fetchedObjects = [self.moc executeFetchRequest:fetchRequest error:&error];
  
  if (fetchedObjects == nil) {
    return @[];
  }
  
  return fetchedObjects;
}

-(int)getMaxIdx {
  NSArray<ToDoItem *> *items = [self fetchAllToDoItems];
  if (items) {
    return items.lastObject.idx;
  }
  else {
    return 1;
  }
    
}

-(void)addToDoItemByTitle:(NSString *)title complete:(BOOL)isComplete priority:(NSUInteger)priority startDate:(NSDate *)startDate dueDate:(NSDate *)dueDate{
  int idx = [self getMaxIdx] + 1;
  ToDoItem *entity = [NSEntityDescription insertNewObjectForEntityForName:toDoItemName inManagedObjectContext:self.moc];
  
  entity.title = title;
  entity.isCompleted = isComplete;
  entity.priority = priority;
  entity.startDate = startDate;
  entity.dueDate = dueDate;
  entity.idx = idx;
  
  [self saveContext];
}

-(void)deleteToDoItemByIdx:(int)itemIdx {
  NSFetchRequest *fetchDeleteItemRequest = [NSFetchRequest fetchRequestWithEntityName:toDoItemName];
  fetchDeleteItemRequest.predicate = [NSPredicate predicateWithFormat:@"idx = %d", itemIdx];

  NSError *err;
  NSArray <ToDoItem *> *results = [self.moc executeFetchRequest:fetchDeleteItemRequest error:&err];
  
  if (!err && [results count]) {
    [self.moc deleteObject:[results firstObject]];
    [self saveContext];
  }
}

-(void)deleteAllToDoItems {
  NSError *fetchError;
  
  NSArray<ToDoItem *> *allItems = [self.moc executeFetchRequest:[ToDoItem fetchRequest] error:&fetchError];
  
  if (!fetchError) {
    for(ToDoItem *item in allItems) {
      [self.moc deleteObject:item];
    }
  }
  [self saveContext];
}


#pragma mark - Core Data Stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
  // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
  @synchronized (self) {
    if (_persistentContainer == nil) {
      _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"EKEvent_ToDoList"];
      [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
          // Replace this implementation with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          
          /*
           Typical reasons for an error here include:
           * The parent directory does not exist, cannot be created, or disallows writing.
           * The persistent store is not accessible, due to permissions or data protection when the device is locked.
           * The device is out of space.
           * The store could not be migrated to the current model version.
           Check the error message to determine what the actual problem was.
           */
          NSLog(@"Unresolved error %@, %@", error, error.userInfo);
          abort();
        }
      }];
    }
  }
  
  return _persistentContainer;
}

@synthesize moc = _moc;

-(NSManagedObjectContext *)moc {
  if (!_moc) {
    _moc = self.persistentContainer.viewContext;
  }
  
  return _moc;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *context = self.persistentContainer.viewContext;
  NSError *error = nil;
  if ([context hasChanges] && ![context save:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }
}




@end
