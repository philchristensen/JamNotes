//
//  HPBBandSearchViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Band, Event;

@protocol HPBBandSearchViewControllerDelegate <NSObject>
@optional
- (void)bandSelected:(Band*)selectedBand;
@end

@interface HPBBandSearchViewController : UITableViewController

@property (strong, nonatomic) UILabel* firstRunHelpLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet id<HPBBandSearchViewControllerDelegate> delegate;

@property Event* detailItem;
@property NSString* searchText;
@property NSMutableArray* results;

@end
