//
//  Band.m
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import "Band.h"
#import "Event.h"
#import "Song.h"


@implementation Band

@dynamic creationDate;
@dynamic name;
@dynamic events;
@dynamic songs;

+ (Band*)bandNamed:(NSString*)bandName inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Band" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@", bandName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    Band* selectedBand;
    if(error){
        // Handle the error.
        NSLog(@"Error in fetch band named '%@'", bandName);
        return nil;
    }
    
    if([results count] == 0){
        selectedBand = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        selectedBand.name = bandName;
        
        NSError *error = nil;
        if(![context save:&error]) {
            NSLog(@"Can't save new band because of error: %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    else{
        selectedBand = results[0];
    }
    return selectedBand;
}

+(int) totalBandsInContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Band" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    if(error){
        // Handle the error.
        NSLog(@"Error in totalBandsInContext: %@", error);
    }
    
    return [results count];
}

@end
