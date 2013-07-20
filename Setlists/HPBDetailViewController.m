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

    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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
    [self.tableView reloadData];
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
    return [self.detailItem totalSets] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
    else {
        int total = [self.detailItem totalSongsInSet:section];
        //// whether to show a cell in an empty set or not
        //if(total == 0){
        //    total = 1;
        //}
        return total;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        if(indexPath.item == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"bandCell" forIndexPath:indexPath];
            cell.textLabel.text = [[self.detailItem valueForKey:@"band"] valueForKey:@"name"];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1];
            if(! cell.textLabel.text){
                cell.textLabel.text = @"Select Band...";
                cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.15];
            }
        }
        else if(indexPath.item == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
            cell.textLabel.text = [[self.detailItem valueForKey:@"venue"] valueForKey:@"name"];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1];
            if(! cell.textLabel.text){
                cell.textLabel.text = @"Select Venue...";
                cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.15];
            }
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
            NSDateFormatter* format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMMM d, yyyy"];
            
            NSDate* date = [self.detailItem valueForKey:@"creationDate"];
            if(date == nil){
                date = [[NSDate alloc] init];
            }
            cell.textLabel.text = [format stringFromDate:date];
            
            UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
            [cell addGestureRecognizer:recognizer];
        }
    }
    else {
        if([self.detailItem wouldBeEmptySet:indexPath]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];

            Entry* entry = [self.detailItem getEntryAtIndexPath:indexPath];
            cell.textLabel.text = [entry.song.name stringByAppendingString:([entry.is_segue boolValue] ? @" >" : @"")];
            if([[entry valueForKey:@"is_encore"] boolValue]){
                cell.textLabel.text = [@"E: " stringByAppendingString:cell.textLabel.text];
            }
        }
    }

    return cell;
}

- (UITableViewCell*)cellIdenticalToCellAtIndexPath:(NSIndexPath*)indexPath forDragTableViewController:(ATSDragToReorderTableViewController*)tableViewController {
    Entry* entry = [self.detailItem getEntryAtIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [entry.song.name stringByAppendingString:([entry.is_segue boolValue] ? @" >" : @"")];
    if([[entry valueForKey:@"is_encore"] boolValue]){
        cell.textLabel.text = [@"E: " stringByAppendingString:cell.textLabel.text];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section > 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        view.backgroundColor = hex2UIColor(@"372172", 1.0);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width, 21)];
        
        label.text = [NSString stringWithFormat:@"Set %d", section];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        
        [view addSubview:label];
        
        return view;
    }
    else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return 55;
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
    return indexPath.section > 0;
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

// support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [tableView beginUpdates];
    [self.detailItem moveEntryFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
    if([self.detailItem wouldBeEmptySet:fromIndexPath] && fromIndexPath.section < [self.detailItem totalSets]){
        [self.detailItem decrementSetsAfter:fromIndexPath.section];
    }
    [tableView endUpdates];
}


// support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return indexPath.section > 0;
}

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
- (IBAction)addNewItem:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"New Item"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"New Song", @"New Set", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    
    HPBSongSearchViewController *popupController = (HPBSongSearchViewController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"songSearchViewController"];
    popupController.delegate = self;
    popupController.detailItem = self.detailItem;
    popupController.isSetOpener = (buttonIndex == 1);

    [self.navigationController pushViewController:popupController animated:YES];
}


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
    else if ([[segue identifier] isEqualToString:@"editEntry"]) {
        HPBEntryDetailViewController* popupController = [segue destinationViewController];
        popupController.detailItem = [self.detailItem getEntryAtIndexPath:self.tableView.indexPathForSelectedRow];
        popupController.entryEvent = self.detailItem;
        popupController.parentController = self;
    }
}

#pragma mark - HPBBandSearchViewControllerDelegate
-(void)bandSelected:(Band *)selectedBand {
    [self.detailItem setValue:selectedBand forKey:@"band"];
    [self.context save:nil];
    [self.tableView reloadData];
}

#pragma mark - HPBVenueSearchViewControllerDelegate
-(void)venueSelected:(Venue *)selectedVenue {
    [self.detailItem setValue:selectedVenue forKey:@"venue"];
    [self.context save:nil];
    [self.tableView reloadData];
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
    newManagedObject.order = @([self.detailItem totalSongsInSet:setNumber] - 1);
    newManagedObject.is_encore = NO;
    
    // Save the context.
    NSError *error = nil;
    if (![self.context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    
    [self.tableView reloadData];
}

@end
