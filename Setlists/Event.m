//
//  Event.m
//  Setlists
//
//  Created by Phil Christensen on 6/30/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import "Event.h"
#import "Band.h"
#import "Entry.h"
#import "Venue.h"


@implementation Event

@dynamic creationDate;
@dynamic name;
@dynamic band;
@dynamic entries;
@dynamic venue;

- (int)totalSets {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event == %@", self];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"set_index" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    if([results count] == 0){
        return 0;
    }
    
    return [[results[0] valueForKey:@"set_index"] intValue] + 1;
}

- (int)totalSongs {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event == %@", self];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    return [results count];
}

- (int)totalSongsInSet:(int)setNumber {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index == %d)", self, setNumber - 1];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    return [results count];
}

- (Entry*)getEntryAtIndexPath:(NSIndexPath*)indexPath {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index == %d)", self , indexPath.section - 1];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    return results[indexPath.row];
}

- (BOOL)wouldBeEmptySet:(NSIndexPath*)indexPath {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index == %d)", self, indexPath.section - 1];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    return [results count] == 0;
}

- (void)deleteSongAtIndexPath:(NSIndexPath*)indexPath {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index == %d)", self, indexPath.section - 1];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error){
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    if([results count]){
        [self.managedObjectContext deleteObject:results[indexPath.row]];
        [self.managedObjectContext save:nil];
    }
    
    if([results count] < 2){
        // update all following sets by subtracting one from set_index
        [self decrementSets:indexPath.section + 1];
    }
}


- (void)decrementSets:(int)startSet {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index >= %d)", self, startSet];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error){
        // Handle the error.
        NSLog(@"error in fetch all bands");
    }
    
    for(Entry* entry in results){
        entry.set_index = @([entry.set_index intValue] - 1);
    }
    [self.managedObjectContext save:nil];
}

@end
