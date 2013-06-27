//
//  Entry.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSManagedObject *song;

@end
