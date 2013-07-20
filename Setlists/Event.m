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
    if(error){
        // Handle the error.
        NSLog(@"Error in totalSets: %@", error);
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
    if(error){
        // Handle the error.
        NSLog(@"Error in totalSongs: %@", error);
    }
    
    return [results count];
}

- (NSArray*)songsInSet:(int)setNumber {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index == %d)", self, setNumber - 1];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];

    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (results == nil) {
        // Handle the error.
        NSLog(@"Error in songsInSet: %@", error);
    }
    return results;
}

- (int)totalSongsInSet:(int)setNumber {
    NSArray* results = [self songsInSet:setNumber];
    return [results count];
}

- (Entry*)getEntryAtIndexPath:(NSIndexPath*)indexPath {
    NSArray* results = [self songsInSet:indexPath.section];
    return results[indexPath.row];
}

- (BOOL)wouldBeEmptySet:(NSIndexPath*)indexPath {
    return [self totalSongsInSet:indexPath.section] == 0;
}

- (void)deleteSongAtIndexPath:(NSIndexPath*)indexPath {
    NSArray* results = [self songsInSet:indexPath.section];
    if([results count]){
        [self.managedObjectContext deleteObject:results[indexPath.row]];
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if(error){
            NSLog(@"Error in deleteSongAtIndexPath: %@", error);
        }
    }
}

- (void)decrementSetsAfter:(int)startSet {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@) and (set_index > %d)", self, startSet - 1];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    [self.managedObjectContext save:&error];
    if(error){
        // Handle the error.
        NSLog(@"Error in decrementSetsAfter: %@", error);
    }
    
    for(Entry* entry in results){
        entry.set_index = @([entry.set_index intValue] - 1);
    }
    error = nil;
    [self.managedObjectContext save:&error];
    if(error){
        // Handle the error.
        NSLog(@"Error in decrementSetsAfter: %@", error);
    }
}

- (void)moveEntryFromIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
    // if we're moving within the same set
    if(toIndexPath.section == fromIndexPath.section){
        NSArray* results = [self songsInSet:toIndexPath.section];
        // get moving item, set new set_index and order
        Entry* movingEntry = (Entry*)results[fromIndexPath.item];
        movingEntry.order = @(toIndexPath.item);
        
        // if we moved to an earlier position
        if(toIndexPath.item < fromIndexPath.item){
            // increment order of all items greater than current order and less than old order
            for(int i = toIndexPath.item; i < fromIndexPath.item; i++){
                Entry* current = (Entry*)results[i];
                current.order = @([current.order intValue] + 1);
            }
        }
        // we moved to a later position
        else{
            // decrement order of all items greater than old order and less than current order
            for(int i = fromIndexPath.item + 1; i <= toIndexPath.item; i++){
                Entry* current = (Entry*)results[i];
                current.order = @([current.order intValue] - 1);
            }
        }
    }
    // we're moving between sets
    else {
        NSArray* oldSet = [self songsInSet:fromIndexPath.section];
        NSArray* newSet = [self songsInSet:toIndexPath.section];
        
        // get moving item, set new set_index and order
        Entry* movingEntry = (Entry*)oldSet[fromIndexPath.item];
        Entry* destinationEntry = (Entry*)newSet[toIndexPath.item];
        NSNumber* savedOrder = destinationEntry.order;
        NSNumber* savedSetIndex = destinationEntry.set_index;

        // decrement order of all items in old set greater than old order
        for(int i = fromIndexPath.item + 1; i < [oldSet count]; i++){
            Entry* current = (Entry*)oldSet[i];
            current.order = @([current.order intValue] - 1);
        }

        // increment order of all items in new set greater than new order
        for(int i = toIndexPath.item; i < [newSet count]; i++){
            Entry* current = (Entry*)newSet[i];
            current.order = @([current.order intValue] + 1);
        }

        movingEntry.order = savedOrder;
        movingEntry.set_index = savedSetIndex;
    }

    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if(error){
        NSLog(@"Error in moveEntryFromIndexPath: %@", error);
    }
}

@end
