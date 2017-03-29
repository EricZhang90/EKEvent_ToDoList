//
//  EZHTableViewController.m
//  EKEvent_ToDoList
//
//  Created by Eric zhang on 2017-03-29.
//  Copyright © 2017 lei zhang. All rights reserved.
//

#import "EZHTableViewController.h"
#import "EZHCoreDataManager.h"
#import "EZHTableViewCell.h"

NSString *cellName = @"ToDoCell";

@interface EZHTableViewController () {
  EZHCoreDataManager *coreDataManager;
}

@property (nonatomic, strong) NSArray<ToDoItem *> *toDoItems;

@end

@implementation EZHTableViewController

#pragma mark - Getter/Setter

-(NSArray<ToDoItem *> *)toDoItems {
  if (!_toDoItems) {
    _toDoItems = [coreDataManager fetchAllToDoItems];
  }
  
  return _toDoItems;
}

#pragma mark - View Controller
- (void)viewDidLoad {
  [super viewDidLoad];
  
  coreDataManager = [EZHCoreDataManager sharedManager];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                            target:self
                                            action:@selector(addToDoItem)];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                            target:self
                                            action:@selector(deleteAllToDoItems)];
}

#pragma mark - add/delete core data entity

-(void)refreshTableViewCV {
  _toDoItems = [coreDataManager fetchAllToDoItems];
  [self.tableView reloadData];
}

-(void)addToDoItem {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add a ToDo item" message:@"" preferredStyle:UIAlertControllerStyleAlert];
  
  [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"Enter title here";
    textField.tag = 0;
  }];
  
  __weak EZHTableViewController *weakSelf = self;
  UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add"
                                      style:UIAlertActionStyleDefault
                                      handler:
                          ^(UIAlertAction * _Nonnull action) {
                              [[EZHCoreDataManager sharedManager]
                                    addToDoItemByTitle:alertController.textFields.firstObject.text
                                    complete:NO
                                    priority:5
                                    startDate:nil
                                    dueDate:nil];
                            [weakSelf refreshTableViewCV];
                          }
                        ];
  
  [alertController addAction:add];
  
  UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleCancel
                                         handler:nil];
  
  [alertController addAction:cancel];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

-(void)deleteAllToDoItems {
  [coreDataManager deleteAllToDoItems];
  [self refreshTableViewCV];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[coreDataManager fetchAllToDoItems] count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  EZHTableViewCell *cell = (EZHTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    
  cell.titleLb.text = self.toDoItems[indexPath.row].title;
  [cell.dateLb setHidden:YES];
  
  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
