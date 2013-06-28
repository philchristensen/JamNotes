//
//  HPBDetailViewController.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBBandSearchViewController.h"
#import "HPBVenueSearchViewController.h"
#import "HPBSongSearchViewController.h"

@interface HPBDetailViewController : UIViewController <UISplitViewControllerDelegate,HPBBandSearchViewControllerDelegate,HPBVenueSearchViewControllerDelegate,HPBSongSearchViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext* context;

@property (weak, nonatomic) IBOutlet UITableView* formTableView;
@property (weak, nonatomic) IBOutlet UITableView* songTableView;

@end
