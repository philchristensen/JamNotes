//
//  HPBImportSetlistViewController.h
//  JamNotes
//
//  Created by Phil Christensen on 8/17/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "SFSetlist.h"
#import <RestKit.h>

@protocol HPBImportSetlistViewControllerDelegate <NSObject>
@optional
- (void)setlistDownloaded:(SFSetlist*)selectedSetlist;
@end

@interface HPBImportSetlistViewController : UITableViewController

@property (nonatomic, strong) Event* detailItem;
@property (nonatomic, strong) NSMutableArray* searchResults;
@property (nonatomic, strong) RKPaginator* paginator;
@property (nonatomic, strong) id<HPBImportSetlistViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* errorMessage;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
