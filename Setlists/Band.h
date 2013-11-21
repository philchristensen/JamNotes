//
//  Band.h
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Song;

@interface Band : NSManagedObject

@property (nonatomic, retain) NSString * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Band (CoreDataGeneratedAccessors)

+ (Band*)bandNamed:(NSString*)bandName inContext:(NSManagedObjectContext*)context;
+ (int)totalBandsInContext:(NSManagedObjectContext*)context;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
