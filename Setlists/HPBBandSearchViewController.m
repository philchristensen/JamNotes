//
//  HPBBandSearchViewController.m
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBBandSearchViewController.h"
#import "HPBAppDelegate.h"
#import "Band.h"

@interface HPBBandSearchViewController ()

@end

@implementation HPBBandSearchViewController

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
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"addBandCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Add \"%@\"...", self.searchBar.text];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    return ![cell.reuseIdentifier isEqualToString:@"addBandCell"];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.managedObjectContext deleteObject:self.results[indexPath.row]];
        [self.results removeObjectAtIndex:indexPath.row];
        
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        if(error){
            NSLog(@"Error in tableView:commitEditingStyle:forRowAtIndexPath: %@", error);
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Band* selectedBand;
    if(indexPath.item < [self.results count]){
        selectedBand = self.results[indexPath.item];
    }
    else {
        HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
        selectedBand = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Band"
                             inManagedObjectContext:appDelegate.managedObjectContext];
        selectedBand.name = self.searchBar.text;
        
        NSError *error = nil;
        [appDelegate.managedObjectContext save:nil];
        if(error){
            NSLog(@"Error in save new item: %@", error);
        }
    }
    [self.delegate bandSelected:selectedBand];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Search bar delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Band" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    if([text length] > 0){
        // Set example predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
        [request setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray* results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    self.results = [NSMutableArray arrayWithArray:results];
    [self.tableView reloadData];
}
@end
