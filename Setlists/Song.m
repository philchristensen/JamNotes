//
//  Song.m
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import "Song.h"
#import "Band.h"
#import "Entry.h"


@implementation Song

@dynamic creationDate;
@dynamic name;
@dynamic band;
@dynamic entries;

+ (Song*)songBy:(Band*)band named:(NSString*)songName inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@ AND band == %@", songName, band];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    Song* selectedSong;
    if(error){
        // Handle the error.
        NSLog(@"Error in fetch song named '%@'", songName);
        return nil;
    }
    
    if([results count] == 0){
        selectedSong = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        selectedSong.name = songName;
        selectedSong.band = band;
        
        NSError *error = nil;
        if(![context save:&error]) {
            NSLog(@"Can't save new band because of error: %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    else{
        selectedSong = results[0];
    }
    return selectedSong;
}

+(int) totalSongsByBand:(Band*)band {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:band.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"band == %@", band];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [band.managedObjectContext executeFetchRequest:request error:&error];
    if(error){
        // Handle the error.
        NSLog(@"Error in totalSongsByBand: %@", error);
    }
    
    return [results count];
}

@end
