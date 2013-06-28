//
//  HPBVenueSearchViewController.m
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBVenueSearchViewController.h"
#import "HPBAppDelegate.h"
#import "Venue.h"

@interface HPBVenueSearchViewController ()

@end

@implementation HPBVenueSearchViewController
@synthesize searchText;

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
    
    [self searchBar:self.searchBar textDidChange:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.results count] + ([self.searchBar.text length] ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.item < [self.results count]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
        cell.textLabel.text = [self.results[indexPath.item] name];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addVenueCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Add \"%@\"...", self.searchBar.text];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Venue* selectedVenue;
    if(indexPath.item < [self.results count]){
        selectedVenue = self.results[indexPath.item];
    }
    else {
        HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
        selectedVenue = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Venue"
                        inManagedObjectContext:appDelegate.managedObjectContext];
        selectedVenue.name = self.searchBar.text;
        
        NSError *error = nil;
        [appDelegate.managedObjectContext save:nil];
        if(error){
            NSLog(@"Error in save new item: %@", error);
        }
    }
    [self.delegate venueSelected:selectedVenue];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    if([text length] > 0){
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
        [request setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    self.results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (self.results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    [self.tableView reloadData];
}

@end
