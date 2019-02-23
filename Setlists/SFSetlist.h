//
//  SFSetlist.h
//  JamNotes
//
//  Created by Phil Christensen on 8/17/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSetlist : NSObject
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSDate* eventDate;
@property (nonatomic, copy) NSDictionary* artist;
@property (nonatomic, copy) NSDictionary* venue;
@property (nonatomic, copy) NSDictionary* sets;
@end
