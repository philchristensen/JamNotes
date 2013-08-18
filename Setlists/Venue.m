//
//  Venue.m
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "Venue.h"
#import "Event.h"

@implementation Venue

@dynamic creationDate;
@dynamic name;
@dynamic events;

+ (Venue*)venueNamed:(NSString*)venueName inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@", venueName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:request error:&error];
    Venue* selectedVenue;
    if(error){
        // Handle the error.
        NSLog(@"Error in fetch venue named '%@'", venueName);
        return nil;
    }
    
    if([results count] == 0){
        selectedVenue = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        selectedVenue.name = venueName;

        NSError *error = nil;
        if(![context save:&error]) {
            NSLog(@"Can't save new venue because of error: %@, %@", error, [error userInfo]);
            return nil;
        }
    }
    else{
        selectedVenue = results[0];
    }
    return selectedVenue;
}

@end
