//
//  HPBSongSearchViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Song, Event;

@protocol HPBSongSearchViewControllerDelegate <NSObject>
@optional
- (void)songSelected:(Song*)selectedVenue asSetOpener:(BOOL)isSetOpener;
@end

@interface HPBSongSearchViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet id<HPBSongSearchViewControllerDelegate> delegate;

@property Event* detailItem;
@property NSString* searchText;
@property NSMutableArray* results;

@property BOOL isSetOpener;

@end
