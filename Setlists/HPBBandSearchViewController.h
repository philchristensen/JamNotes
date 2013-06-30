//
//  HPBBandSearchViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Band.h"

@protocol HPBBandSearchViewControllerDelegate <NSObject>
@optional
- (void)bandSelected:(Band*)selectedBand;
@end

@interface HPBBandSearchViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet id<HPBBandSearchViewControllerDelegate> delegate;

@property id detailItem;
@property NSString* searchText;
@property NSArray* results;

@end
