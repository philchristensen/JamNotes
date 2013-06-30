//
//  HPBVenueSearchViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Venue, Event;

@protocol HPBVenueSearchViewControllerDelegate <NSObject>
@optional
- (void)venueSelected:(Venue*)selectedVenue;
@end

@interface HPBVenueSearchViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet id<HPBVenueSearchViewControllerDelegate> delegate;

@property Event* detailItem;
@property NSString* searchText;
@property NSArray* results;

@end
