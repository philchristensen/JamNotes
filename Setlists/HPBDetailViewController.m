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
#import "HPBImportSetlistViewController.h"

#import "Event.h"
#import "Entry.h"
#import "Song.h"
#import "Venue.h"
#import "Band.h"
#import "SFSetlist.h"

#import "TDDatePickerController.h"

@interface HPBDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation HPBDetailViewController
@synthesize movingFromIndexPath;
@synthesize deletingSet;

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
    self.dragDelegate = self;
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

#pragma mark - Attendance Toggle
- (IBAction) toggleAttendance:(id)sender {
    self.detailItem.attended = [self.detailItem.attended isEqualToNumber:@(1)] ? @(0) : @(1);
    [self.context save:nil];
    [self.tableView reloadData];
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
    // tableView:moveRowAtIndexPath:toIndexPath: uses deletingSet to deal with moving the last entry out of a set
    return [self.detailItem totalSets] + (self.deletingSet ? 3 : 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
    // the add/import lines are in a different section
    else if(section > [self.detailItem totalSets]){
        return 2;
    }
    else {
        int total = [self.detailItem totalSongsInSet:section];
        return total;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        if(indexPath.item == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"bandCell" forIndexPath:indexPath];
            UILabel* attendeeToggle = [cell viewWithTag:1];
            if([[self.detailItem valueForKey:@"attended"] isEqualToNumber:@(1)]){
                [attendeeToggle setAlpha:1.0];
            }
            else{
                [attendeeToggle setAlpha:0.3];
            }
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
            cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1];
            if(! cell.textLabel.text){
                cell.textLabel.text = @"Select Venue...";
                cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.15];
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
    else if(indexPath.section > [self.detailItem totalSets]){
        if(indexPath.item == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"addSongCell" forIndexPath:indexPath];
            if([self.detailItem totalSongs] == 0){
                cell.textLabel.text = @"Select show opener...";
            }
            else {
                cell.textLabel.text = @"Add song...";
            }
        }
        else if([self.detailItem totalSongs] == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"importSetlistCell" forIndexPath:indexPath];
            Band* band = [self.detailItem band];
            if(band){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Search setlist.fm for any %@ shows on this date.", band.name];
            }
            else{
                cell.detailTextLabel.text = @"Search setlist.fm for any setlists from this date.";
            }
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"addSetCell" forIndexPath:indexPath];
        }
    }
    else {
        // this should pretty much never happen, but it's nice to know when there's a bug
        if([self.detailItem wouldBeEmptySet:indexPath]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];

            Entry* entry = [self.detailItem getEntryAtIndexPath:indexPath];
            
            @try{
                cell.textLabel.text = [entry.song.name stringByAppendingString:([entry.is_segue boolValue] ? @" >" : @"")];
                cell.detailTextLabel.text = entry.notes;
            }
            @catch (NSException* e) {
                cell.textLabel.text = [@"unknown" stringByAppendingString:([entry.is_segue boolValue] ? @" >" : @"")];
                cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.15];
                cell.detailTextLabel.text = @"The song record for this entry has been deleted.";
            }
            
            if([[entry valueForKey:@"is_encore"] boolValue]){
                cell.textLabel.text = [@"E: " stringByAppendingString:cell.textLabel.text];
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.item == 1){
        cell.backgroundColor = hex2UIColor(@"372172", 1.0);
    }
}

// Needed by the drag support for the proxy object used during drag
- (UITableViewCell*)cellIdenticalToCellAtIndexPath:(NSIndexPath*)indexPath forDragTableViewController:(ATSDragToReorderTableViewController*)tableViewController {
    Entry* entry = [self.detailItem getEntryAtIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [entry.song.name stringByAppendingString:([entry.is_segue boolValue] ? @" >" : @"")];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    if([[entry valueForKey:@"is_encore"] boolValue]){
        cell.textLabel.text = [@"E: " stringByAppendingString:cell.textLabel.text];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section > 0 && section <= [self.detailItem totalSets]){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        view.backgroundColor = hex2UIColor(@"372172", 1.0);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, tableView.frame.size.width, 21)];
        
        label.text = [NSString stringWithFormat:@"Set %d", section];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
        
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
    else if(section > [self.detailItem totalSets]){
        return 0;
    }
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 0) {
            return 48;
        }
        else if(indexPath.row < 3){
            return 34;
        }
        // make the extra lines of an empty setlist normal sized
        else {
            return 44;
        }
    }
    else {
        return 44;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return indexPath.section > 0 && indexPath.section <= [self.detailItem totalSets];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.detailItem deleteSongAtIndexPath:indexPath];
        //if that was the last entry, it's really easiest to just reload the table.
        if([self.detailItem totalSongs] == 0){
            [tableView reloadData];
        }
        //if we deleted the last entry in the set
        else if([self.detailItem wouldBeEmptySet:indexPath]){
            [self.detailItem decrementSetsAfter:indexPath.section];
            // delete the section
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                     withRowAnimation:UITableViewRowAnimationFade];
            // reload the later sets, since their numbers have changed
            [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.section, [self.detailItem totalSets] - indexPath.section + 1)]
                     withRowAnimation:UITableViewRowAnimationFade];
        }
        // otherwise just delete the row
        else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

// support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.detailItem moveEntryFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
    // if we deleted the last entry in the *last* set, prepare to delete the set's table section
    if([self.detailItem wouldBeEmptySet:fromIndexPath] && fromIndexPath.section > [self.detailItem totalSets]){
        // this will get the tableview's datasource to pretend there's an extra set for a second
        self.deletingSet = YES;
    }
}

// support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return indexPath.section > 0 && indexPath.section <= [self.detailItem totalSets];
}

#pragma mark - Draggable table view
- (void)dragTableViewController:(ATSDragToReorderTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow {
    // we don't know yet if we're removing the last row in a section
    self.deletingSet = NO;
    // save the origin index path, because the dragDelegate methods don't have it
    self.movingFromIndexPath = dragRow;
}

- (void)dragTableViewController:(ATSDragToReorderTableViewController*)dragTableViewController didEndDraggingToRow:(NSIndexPath*)toIndexPath {
    if([self.detailItem wouldBeEmptySet:self.movingFromIndexPath] && self.movingFromIndexPath.section < [self.detailItem totalSets]){
        [self.detailItem decrementSetsAfter:self.movingFromIndexPath.section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.movingFromIndexPath.section]
                 withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.movingFromIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    if(self.deletingSet){
        self.deletingSet = NO;
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.movingFromIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Sharing
- (void)shareSetlist:(id)sender {
    //if (_postImage.image != nil) {
    //    activityItems = @[_postText.text, _postImage.image];
    //} else {
    //    activityItems = @[_postText.text];
    //}
    NSArray *activityItems = @[[self.detailItem generatePlainTextSetlist]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Segue control
-(void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    if ([[segue identifier] isEqualToString:@"selectBand"]) {
        HPBBandSearchViewController* vc = [segue destinationViewController];
        vc.delegate = self;
        vc.detailItem = self.detailItem;
    }
    else if ([[segue identifier] isEqualToString:@"selectVenue"]) {
        HPBVenueSearchViewController* vc = [segue destinationViewController];
        vc.delegate = self;
        vc.detailItem = self.detailItem;
    }
    else if ([[segue identifier] isEqualToString:@"editEntry"]) {
        HPBEntryDetailViewController* vc = [segue destinationViewController];
        vc.detailItem = [self.detailItem getEntryAtIndexPath:self.tableView.indexPathForSelectedRow];
        vc.entryEvent = self.detailItem;
        vc.parentController = self;
    }
    else if ([[segue identifier] isEqualToString:@"addSong"]) {
        HPBSongSearchViewController* vc = [segue destinationViewController];
        vc.delegate = self;
        vc.detailItem = self.detailItem;
        vc.isSetOpener = NO;
    }
    else if ([[segue identifier] isEqualToString:@"addSet"]) {
        HPBSongSearchViewController* vc = [segue destinationViewController];
        vc.delegate = self;
        vc.detailItem = self.detailItem;
        vc.isSetOpener = YES;
    }
    else if ([[segue identifier] isEqualToString:@"importSetlist"]) {
        HPBImportSetlistViewController* vc = [segue destinationViewController];
        vc.delegate = self;
        vc.detailItem = self.detailItem;
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
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
}

#pragma mark - HPBImportSetlistViewControllerDelegate
- (void)setlistDownloaded:(SFSetlist*)selectedSetlist {
    self.detailItem.venue = [Venue venueNamed:selectedSetlist.venue[@"name"] inContext:self.context];
    self.detailItem.band = [Band bandNamed:selectedSetlist.artist[@"name"] inContext:self.context];
    
    int set_index = 0;
    NSArray* sets = selectedSetlist.sets[@"set"];
    if([ sets respondsToSelector:@selector(objectForKey:)]){
        sets = @[sets];
    }
    for(NSDictionary* set in sets){
        BOOL is_encore = [set[@"encore"] boolValue];
        NSArray* songs = set[@"song"];
        NSDictionary* singleSong = (NSDictionary*)songs;
        if([singleSong respondsToSelector:@selector(objectForKey:)] && [singleSong objectForKey:@"name"] != nil){
            songs = @[singleSong];
        }
        for(__strong NSDictionary* song in songs){
            if([song respondsToSelector:@selector(isEqualToString:)]){
                continue;
            }
            NSString* songName = song[@"name"];
            Entry* newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.context];
            newManagedObject.song = [Song songBy:self.detailItem.band named:songName inContext:self.context];
            
            NSString* infoText = song[@"info"] ? song[@"info"][@"text"] : @"";
            if([infoText isEqualToString:@">"]){
                newManagedObject.is_segue = @(1);
            }
            else{
                if([infoText hasSuffix:@">"]){
                    newManagedObject.is_segue = @(1);
                }
                newManagedObject.notes = infoText;
            }
            newManagedObject.event = self.detailItem;
            newManagedObject.set_index = @(set_index);
            newManagedObject.order = @([self.detailItem totalSongsInSet:set_index + 1] - 1);
            newManagedObject.is_encore = @(is_encore);
            
        }
        set_index++;
    }
    
    [self.context save:nil];
    [self.tableView reloadData];
}


@end
