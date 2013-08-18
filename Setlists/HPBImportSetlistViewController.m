//
//  HPBImportSetlistViewController.m
//  JamNotes
//
//  Created by Phil Christensen on 8/17/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBImportSetlistViewController.h"
#import "HPBImportTableCell.h"
#import "SFSetlist.h"
#import "Event.h"
#import "Band.h"

#import <RestKit.h>

@interface HPBImportSetlistViewController ()

@end

@implementation HPBImportSetlistViewController

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
    [self querySetlistFm];
}

- (void)querySetlistFm {
    // GET a single Article from /articles/1234.json and map it into an object
    // JSON looks like {"article": {"title": "My Article", "author": "Blake", "body": "Very cool!!"}}
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SFSetlist class]];
    [mapping addAttributeMappingsFromArray:@[@"setlist", @"venue", @"sets"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yyyy"];
    
    NSString* date = [[format stringFromDate:self.detailItem.creationDate] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* artistName = [self.detailItem.band.name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString* basePath = @"/rest/0.1/search/setlists.json";
    NSURL* requestURL = [[NSURL alloc] initWithScheme:@"http"
                                                 host:@"api.setlist.fm"
                                                 path:[NSString stringWithFormat:@"%@?date=%@&artistName=%@", basePath, date, artistName]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:@"/rest/0.1/search/setlists.json" keyPath:@"setlists" statusCodes:statusCodes];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        SFSetlist *setlist = [result firstObject];
        NSLog(@"Mapped the setlist: %@", setlist);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPBImportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setlistCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
