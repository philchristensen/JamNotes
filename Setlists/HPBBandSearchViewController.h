//
//  HPBBandSearchViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBBandSearchViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSString* searchText;
@property NSArray* results;

@end
