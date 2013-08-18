//
//  Song.h
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band, Entry;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Band *band;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Song (CoreDataGeneratedAccessors)

+ (Song*)songBy:(Band*)band named:(NSString*)songName inContext:(NSManagedObjectContext*)context;

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
