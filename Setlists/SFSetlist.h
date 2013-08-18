//
//  SFSetlist.h
//  JamNotes
//
//  Created by Phil Christensen on 8/17/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSetlist : NSObject
@property (nonatomic, copy) NSMutableDictionary* setlist;
@property (nonatomic, copy) NSMutableDictionary* venue;
@property (nonatomic, copy) NSMutableDictionary* sets;
@end
