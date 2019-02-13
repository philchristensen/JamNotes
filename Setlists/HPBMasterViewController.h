//
//  HPBMasterViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPBDetailViewController;

#import <CoreData/CoreData.h>

@interface HPBMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) HPBDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIButton* infoButton;

- (void)flipToAbout:(id)sender;

@end
