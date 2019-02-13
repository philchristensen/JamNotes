//
//  HPBEventPhotosCollectionViewCell.m
//  JamNotes
//
//  Created by Phil Christensen on 2/12/19.
//  Copyright © 2019 Phil Christensen. All rights reserved.
//

#import "HPBEventPhotosCollectionViewCell.h"

@implementation HPBEventPhotosCollectionViewCell

@synthesize image;

- (void) setImage:(UIImage*)image {
    self.imageView.image = image;
}

- (UIImage*) image {
    return self.imageView.image;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
