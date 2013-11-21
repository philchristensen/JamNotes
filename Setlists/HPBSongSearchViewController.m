//
//  HPBSongSearchViewController.m
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBSongSearchViewController.h"
#import "HPBAppDelegate.h"
#import "Band.h"
#import "Song.h"
#import "Event.h"

@interface HPBSongSearchViewController ()

@end

@implementation HPBSongSearchViewController

@synthesize isSetOpener;

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
    if(self.isSetOpener){
        self.title = @"Select Set Opener";
    }
    [self.searchBar becomeFirstResponder];
    
    Band* band = [self.detailItem band];
    if([Song totalSongsByBand:band] == 0){
        NSMutableParagraphStyle* helpTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [helpTextStyle setAlignment: NSTextAlignmentCenter];
        [helpTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary* helpTextFontAttributes = @{
                                                 NSFontAttributeName:               [UIFont fontWithName: @"HelveticaNeue-Bold" size: 24],
                                                 NSForegroundColorAttributeName:    [UIColor grayColor],
                                                 NSParagraphStyleAttributeName:     helpTextStyle
                                                 };
        
        self.firstRunHelpLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 270, 270)];
        self.firstRunHelpLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"You haven't added any songs for %@ yet. To add a new song, type the name in the search field, and click to add.", [[self.detailItem band] name]] attributes:helpTextFontAttributes];
        self.firstRunHelpLabel.numberOfLines = 0;
        
        [self.view addSubview:self.firstRunHelpLabel];
        [self.view bringSubviewToFront:self.firstRunHelpLabel];
    }
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"addSongCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Add \"%@\"...", self.searchBar.text];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    return ![cell.reuseIdentifier isEqualToString:@"addSongCell"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Song* selectedSong;
    if(indexPath.item < [self.results count]){
        selectedSong = self.results[indexPath.item];
    }
    else {
        HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
        selectedSong = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Song"
                         inManagedObjectContext:appDelegate.managedObjectContext];
        selectedSong.name = self.searchBar.text;
        selectedSong.band = [self.detailItem band];
        
        NSError *error = nil;
        [appDelegate.managedObjectContext save:nil];
        if(error){
            NSLog(@"Error in save new item: %@", error);
        }
    }
    [self.delegate songSelected:selectedSong asSetOpener:self.isSetOpener];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    HPBAppDelegate* appDelegate = (HPBAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate* predicate;
    if([text length] > 0){
        predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@) and (band == %@)", text, [self.detailItem band]];
    }
    else{
        predicate = [NSPredicate predicateWithFormat:@"band == %@", [self.detailItem band]];
    }
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError* error = nil;
    NSArray* results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all songs");
    }
    self.results = [NSMutableArray arrayWithArray:results];
    [self.tableView reloadData];
}

@end
