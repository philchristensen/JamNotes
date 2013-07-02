//
//  HPBDetailViewController.m
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBDetailViewController.h"
#import "HPBBandSearchViewController.h"
#import "HPBSongSearchViewController.h"
#import "HPBEntryDetailViewController.h"
#import "HPBVenueSearchViewController.h"
#import "HPBAppDelegate.h"

#import "Event.h"
#import "Entry.h"
#import "Song.h"

#import "TDDatePickerController.h"

@interface HPBDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation HPBDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.formTableView deselectRowAtIndexPath:[self.formTableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.songTableView setEditing:editing animated:animated];
}

#pragma mark - Date Picker

- (IBAction) showDatePicker:(id)sender {
    self.datePickerController = [[TDDatePickerController alloc]
                                              initWithNibName:@"TDDatePickerController"
                                              bundle:nil];
    self.datePickerController.delegate = self;
    self.datePickerController.datePicker.date = self.detailItem.creationDate;
    [self presentSemiModalViewController:self.datePickerController];
}

- (void)datePickerSetDate:(TDDatePickerController*)viewController {
    self.detailItem.creationDate = viewController.datePicker.date;
    [self.context save:nil];
    [self.formTableView reloadData];
    [self dismissSemiModalViewController:viewController];
}

- (void)datePickerClearDate:(TDDatePickerController*)viewController {
    [self.datePickerController.datePicker setDate:self.detailItem.creationDate animated:YES];
}

- (void)datePickerCancel:(TDDatePickerController*)viewController {
    [self dismissSemiModalViewController:viewController];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.formTableView){
        return 1;
    }
    else if(tableView == self.songTableView){
        return [self.detailItem totalSets];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.formTableView){
        return 3;
    }
    else if(tableView == self.songTableView){
        int total = [self.detailItem totalSongsInSet:section+1];
        if(total == 0 && self.editing){
            total = 1;
        }
        return total;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == self.formTableView){
        if(indexPath.item == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"bandCell" forIndexPath:indexPath];
            cell.textLabel.text = [[self.detailItem valueForKey:@"band"] valueForKey:@"name"];
        }
        else if(indexPath.item == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
            NSDateFormatter* format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM dd, yyyy"];
            
            NSDate* date = [self.detailItem valueForKey:@"creationDate"];
            if(date == nil){
                date = [[NSDate alloc] init];
            }
            cell.textLabel.text = [format stringFromDate:date];
            
            UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
            [cell addGestureRecognizer:recognizer];
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
            cell.textLabel.text = [[self.detailItem valueForKey:@"venue"] valueForKey:@"name"];
        }
    }
    else if(tableView == self.songTableView){
        if([self.detailItem wouldBeEmptySet:indexPath]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];

            Entry* entry = [self.detailItem getEntryAtIndexPath:indexPath];
            cell.textLabel.text = [entry.song.name stringByAppendingString:([entry.is_segue boolValue] ? @" >" : @"")];
        }
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.songTableView){
        return [NSString stringWithFormat:@"Set %d", section + 1];
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.formTableView){
        if (indexPath.row == 0) {
            return 66;
        }
        else {
            return 33;
        }
    }
    else {
        return 44;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return tableView == self.songTableView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.detailItem deleteSongAtIndexPath:indexPath];
        if([tableView numberOfRowsInSection:indexPath.section] < 2){
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] 
                     withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Segue control
-(void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    if ([[segue identifier] isEqualToString:@"selectBand"]) {
        HPBBandSearchViewController* popupController = [segue destinationViewController];
        popupController.delegate = self;
        popupController.detailItem = self.detailItem;
    }
    else if ([[segue identifier] isEqualToString:@"selectVenue"]) {
        HPBVenueSearchViewController* popupController = [segue destinationViewController];
        popupController.delegate = self;
        popupController.detailItem = self.detailItem;
    }
    else if ([[segue identifier] isEqualToString:@"selectSong"]) {
        HPBSongSearchViewController* popupController = [segue destinationViewController];
        popupController.delegate = self;
        popupController.detailItem = self.detailItem;
    }
    else if ([[segue identifier] isEqualToString:@"selectSetOpener"]) {
        HPBSongSearchViewController* popupController = [segue destinationViewController];
        popupController.delegate = self;
        popupController.detailItem = self.detailItem;
        popupController.isSetOpener = YES;
    }
    else if ([[segue identifier] isEqualToString:@"editEntry"]) {
        HPBEntryDetailViewController* popupController = [segue destinationViewController];
        popupController.detailItem = [self.detailItem getEntryAtIndexPath:self.songTableView.indexPathForSelectedRow];
        popupController.entryEvent = self.detailItem;
    }
}

#pragma mark - HPBBandSearchViewControllerDelegate
-(void)bandSelected:(Band *)selectedBand {
    [self.detailItem setValue:selectedBand forKey:@"band"];
    [self.context save:nil];
    [self.formTableView reloadData];
}

#pragma mark - HPBVenueSearchViewControllerDelegate
-(void)venueSelected:(Venue *)selectedVenue {
    [self.detailItem setValue:selectedVenue forKey:@"venue"];
    [self.context save:nil];
    [self.formTableView reloadData];
}

#pragma mark - HPBSongSearchViewControllerDelegate
-(void)songSelected:(Song *)selectedSong asSetOpener:(BOOL)isSetOpener {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    int setNumber = [self.detailItem totalSets];
    if(setNumber == 0){
        isSetOpener = YES;
    }
    if(isSetOpener){
        setNumber++;
    }
    
    Entry* newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.context];
    newManagedObject.song = selectedSong;
    newManagedObject.event = self.detailItem;
    newManagedObject.set_index = @(setNumber - 1);
    newManagedObject.order = @([self.detailItem totalSongs]);
    newManagedObject.is_encore = NO;
    
    // Save the context.
    NSError *error = nil;
    if (![self.context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    
    [self.songTableView reloadData];
}

@end
