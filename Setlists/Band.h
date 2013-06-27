//
//  Band.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Song;

@interface Band : NSManagedObject

@property (nonatomic, retain) NSString * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Event *events;
@property (nonatomic, retain) Song *songs;

@end
