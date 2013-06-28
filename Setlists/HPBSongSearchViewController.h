//
//  HPBSongSearchViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@protocol HPBSongSearchViewControllerDelegate <NSObject>
@optional
- (void)songSelected:(Song*)selectedVenue;
@end

@interface HPBSongSearchViewController : UITableViewController

@end
