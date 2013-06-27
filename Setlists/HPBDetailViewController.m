//
//  HPBDetailViewController.m
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "HPBDetailViewController.h"

@interface HPBDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation HPBDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.formTableView){
        return 1;
    }
    else if(tableView == self.songTableView){
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.formTableView){
        return 3;
    }
    else if(tableView == self.songTableView){
        if(section == 0) {
            return 3;
        }
        else{
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == self.formTableView){
        if(indexPath.item == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"bandCell" forIndexPath:indexPath];
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
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
        }
    }
    else if(tableView == self.songTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
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

@end
