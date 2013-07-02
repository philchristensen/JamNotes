//
//  HPBEntryDetailViewController.h
//  Setlists
//
//  Created by Phil Christensen on 7/2/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBEntryDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextView* notesView;
@property (weak, nonatomic) IBOutlet UITableViewCell* nameCell;
@property (weak, nonatomic) IBOutlet UISwitch* segueSwitch;
@property (weak, nonatomic) IBOutlet UISwitch* encoreSwitch;

@end
