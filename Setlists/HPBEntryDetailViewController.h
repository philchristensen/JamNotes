//
//  HPBEntryDetailViewController.h
//  Setlists
//
//  Created by Phil Christensen on 7/2/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@interface HPBEntryDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextView* notesView;
@property (weak, nonatomic) IBOutlet UITableViewCell* nameCell;
@property (weak, nonatomic) IBOutlet UISwitch* segueSwitch;
@property (weak, nonatomic) IBOutlet UISwitch* encoreSwitch;

@property Event* entryEvent;
@property Entry* detailItem;

- (IBAction)toggleSegue:(UISwitch*)sender;
- (IBAction)toggleEncore:(UISwitch*)sender;

@end