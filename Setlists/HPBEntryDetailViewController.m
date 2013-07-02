//
//  HPBEntryDetailViewController.m
//  Setlists
//
//  Created by Phil Christensen on 7/2/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBEntryDetailViewController.h"
#import "Event.h"

@interface HPBEntryDetailViewController ()

@end

@implementation HPBEntryDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM d"];
    
    NSString* date = [format stringFromDate:[self.entryEvent valueForKey:@"creationDate"]];
    NSString* venue = [[[self.detailItem valueForKey:@"event"] valueForKey:@"venue"] valueForKey:@"name"];
    NSString* datedVenueText = [NSString stringWithFormat:@"%@ \xc2\x96 %@", date, venue];
    
    self.nameCell.textLabel.text = [[self.detailItem valueForKey:@"song"] valueForKey:@"name"];
    self.nameCell.detailTextLabel.text = datedVenueText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
