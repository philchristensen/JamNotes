//
//  Song.h
//  Setlists
//
//  Created by Phil Christensen on 6/27/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Band;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) Band *band;

@end
