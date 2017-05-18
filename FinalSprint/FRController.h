//
//  FRController.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/15/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface FRController : NSManagedObject
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *myTableView;

-(id) initWithContext:(NSManagedObjectContext *)moc fetchedResultController:(NSFetchedResultsController *)myFRController tableView:(UITableView *)tableView;
- (NSFetchedResultsController *)fetchedResultsController;
@end
