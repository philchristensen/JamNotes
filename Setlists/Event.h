//
//  Event.h
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band, Entry, Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Band *band;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) Venue *venue;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

- (int)totalSets;
- (int)totalSongs;
- (NSArray*)songsInSet:(int)setNumber;
- (int)totalSongsInSet:(int)setNumber;
- (Entry*)getEntryAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL)wouldBeEmptySet:(NSIndexPath*)indexPath;
- (void)deleteSongAtIndexPath:(NSIndexPath*)indexPath;
- (void)moveEntryFromIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath;
- (void)decrementSetsAfter:(int)startSet;

@end
