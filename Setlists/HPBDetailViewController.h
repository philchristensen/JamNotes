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
#import "HPBImportSetlistViewController.h"

@class Event;

@interface HPBDetailViewController : ATSDragToReorderTableViewController <UISplitViewControllerDelegate,UIActionSheetDelegate,ATSDragToReorderTableViewControllerDelegate,HPBBandSearchViewControllerDelegate,HPBVenueSearchViewControllerDelegate,HPBSongSearchViewControllerDelegate,HPBImportSetlistViewControllerDelegate>

@property (strong, nonatomic) Event* detailItem;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) TDDatePickerController* datePickerController;
@property (strong, nonatomic) NSIndexPath* movingFromIndexPath;
@property (strong, nonatomic) UILabel* attendeeTogle;

@property BOOL deletingSet;

- (IBAction) showDatePicker:(id)sender;
- (IBAction) shareSetlist:(id)sender;
- (IBAction) toggleAttendance:(id)sender;

- (void)datePickerSetDate:(TDDatePickerController*)viewController;
- (void)datePickerClearDate:(TDDatePickerController*)viewController;
- (void)datePickerCancel:(TDDatePickerController*)viewController;

@end
