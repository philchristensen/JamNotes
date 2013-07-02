//
//  Entry.h
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Song;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * set_index;
@property (nonatomic, retain) NSNumber * is_encore;
@property (nonatomic, retain) NSNumber * is_segue;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Song *song;
@property (nonatomic, retain) NSString* notes;

@end
