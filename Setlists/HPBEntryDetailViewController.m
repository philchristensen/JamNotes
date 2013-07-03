//
//  HPBEntryDetailViewController.m
//  Setlists
//
//  Created by Phil Christensen on 7/2/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBEntryDetailViewController.h"
#import "HPBAppDelegate.h"
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
    NSString* datedVenueText = [NSString stringWithFormat:@"%@ - %@", date, venue];
    
    self.nameCell.textLabel.text = [[self.detailItem valueForKey:@"song"] valueForKey:@"name"];
    self.nameCell.detailTextLabel.text = datedVenueText;
    
    self.notesView.text = [self.detailItem valueForKey:@"notes"];
    [self.segueSwitch setOn:[[self.detailItem valueForKey:@"is_segue"] boolValue] animated:YES];
    [self.encoreSwitch setOn:[[self.detailItem valueForKey:@"is_encore"] boolValue] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView {
    self.detailItem.notes = self.notesView.text;
    
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil];
}

- (IBAction)toggleSegue:(UISwitch*)sender {
    self.detailItem.is_segue = @(sender.isOn);
    
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil];
}

- (IBAction)toggleEncore:(UISwitch*)sender {
    self.detailItem.is_encore = @(sender.isOn);
    
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil];
}


@end
