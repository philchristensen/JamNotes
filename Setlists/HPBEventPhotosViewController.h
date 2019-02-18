//
//  HPBEventPhotosViewController.h
//  JamNotes
//
//  Created by Phil Christensen on 2/13/19.
//  Copyright © 2019 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>

@import MediaBrowser;

#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPBEventPhotosViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong, nonatomic) Event* event;
@property (strong, nonatomic) PHFetchResult* fetchResult;

@property (strong, nonatomic) MediaBrowser* browser;

@end

NS_ASSUME_NONNULL_END
