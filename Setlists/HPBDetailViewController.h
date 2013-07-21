//
//  HPBDetailViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBBandSearchViewController.h"
#import "HPBVenueSearchViewController.h"
#import "HPBSongSearchViewController.h"
#import "TDDatePickerController.h"
#import "ATSDragToReorderTableViewController.h"

@class Event;

@interface HPBDetailViewController : ATSDragToReorderTableViewController <UISplitViewControllerDelegate,UIActionSheetDelegate,ATSDragToReorderTableViewControllerDelegate,HPBBandSearchViewControllerDelegate,HPBVenueSearchViewControllerDelegate,HPBSongSearchViewControllerDelegate>

@property (strong, nonatomic) Event* detailItem;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) NSIndexPath* movingFromIndexPath;

- (IBAction) showDatePicker:(id)sender;
- (IBAction)addNewItem:(id)sender;

- (void)datePickerSetDate:(TDDatePickerController*)viewController;
- (void)datePickerClearDate:(TDDatePickerController*)viewController;
- (void)datePickerCancel:(TDDatePickerController*)viewController;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
