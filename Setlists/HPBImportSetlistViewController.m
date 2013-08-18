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
#import "RKXMLReaderSerialization.h"

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
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/xml"];

    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yyyy"];
    NSString* date = [format stringFromDate:self.detailItem.creationDate];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"date":date}];
    if(self.detailItem.band) {
        params[@"artistName"] = self.detailItem.band.name;
    }

    NSURL* baseURL = [NSURL URLWithString:@"http://api.setlist.fm/rest/0.1"];
    NSString* methodPath = @"search/setlists";
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseURL];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SFSetlist class]];
    mapping.dateFormatters = @[format];
    mapping.preferredDateFormatter = format;
    [mapping addAttributeMappingsFromDictionary:@{
     @"eventDate" : @"eventDate",
     @"artist" : @"artist",
     @"venue" : @"venue",
     @"sets" : @"sets"
     }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:methodPath
                                                                                           keyPath:@"setlists.setlist"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [manager addResponseDescriptorsFromArray:@[responseDescriptor]]; //, errorDescriptor]];
    
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    [manager getObjectsAtPath:methodPath parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        self.searchResults = [result array];
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        [self.activityIndicator stopAnimating];
    }];
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
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPBImportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setlistCell" forIndexPath:indexPath];
    
    // Configure the cell...
    SFSetlist* setlist = self.searchResults[indexPath.item];
    cell.bandNameLabel.text = setlist.artist[@"name"];
    cell.venueNameLabel.text = setlist.venue[@"name"];

    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M/d/yyyy"];
    cell.dateLabel.text = [format stringFromDate:setlist.eventDate];

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
