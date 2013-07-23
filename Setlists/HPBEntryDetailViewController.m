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
@synthesize parentController;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self reloadViewData];
}

- (void) reloadViewData {
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM d"];
    
    NSString* date = [format stringFromDate:[self.entryEvent valueForKey:@"creationDate"]];
    NSString* venue = [[[self.detailItem valueForKey:@"event"] valueForKey:@"venue"] valueForKey:@"name"];
    NSString* datedVenueText = [NSString stringWithFormat:@"%@ - %@", date, venue];
    
    self.nameCell.textLabel.text = [[self.detailItem valueForKey:@"song"] valueForKey:@"name"];
//    }
//    @catch (NSException* e) {
//        self.nameCell.textLabel.text = [@"unknown" stringByAppendingString:([self.detailItem.is_segue boolValue] ? @" >" : @"")];
//        self.nameCell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.15];
//    }

    if([[self.detailItem valueForKey:@"is_segue"] boolValue]){
        self.nameCell.textLabel.text = [self.nameCell.textLabel.text stringByAppendingString:@" >"];
    }
    if([[self.detailItem valueForKey:@"is_encore"] boolValue]){
        self.nameCell.textLabel.text = [@"E: " stringByAppendingString:self.nameCell.textLabel.text];
    }
    
    self.nameCell.detailTextLabel.text = datedVenueText;
    
    self.notesView.text = [self.detailItem valueForKey:@"notes"];
    [self.segueSwitch setOn:[[self.detailItem valueForKey:@"is_segue"] boolValue] animated:YES];
    [self.encoreSwitch setOn:[[self.detailItem valueForKey:@"is_encore"] boolValue] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView {
    self.detailItem.notes = self.notesView.text;
    
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil];
}

- (void)textViewDidEndEditing:(UITextView*)textView {
    [self.parentController.tableView reloadData];
}

- (IBAction)toggleSegue:(UISwitch*)sender {
    [self.detailItem setValue:[NSNumber numberWithBool:sender.on] forKey:@"is_segue"];
    
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil];

    [self reloadViewData];
    [self.parentController.tableView reloadData];
}

- (IBAction)toggleEncore:(UISwitch*)sender {
    [self.detailItem setValue:[NSNumber numberWithBool:sender.on] forKey:@"is_encore"];
    
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.managedObjectContext save:nil];
    
    [self reloadViewData];
    [self.parentController.tableView reloadData];
}

-(void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    if ([[segue identifier] isEqualToString:@"editEntrySong"]) {
        HPBSongSearchViewController* popupController = [segue destinationViewController];
        popupController.delegate = self;
        popupController.detailItem = self.entryEvent;
    }
}


#pragma mark - HPBSongSearchViewControllerDelegate
-(void)songSelected:(Song *)selectedSong asSetOpener:(BOOL)isSetOpener {
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.detailItem.song = selectedSong;
    [appDelegate.managedObjectContext save:nil];
    
    [self reloadViewData];
    [self.parentController.tableView reloadData];
}

@end
