//
//  HPBCollectionViewCell.m
//  JamNotes
//
//  Created by Phil Christensen on 2/12/19.
//  Copyright © 2019 Phil Christensen. All rights reserved.
//

#import "HPBCollectionViewCell.h"

@implementation HPBCollectionViewCell

@synthesize thumbnailImage;
@synthesize livePhotoBadgeImage;

- (void) setThumbnailImage:(UIImage*)thumbnailImage {
    self.imageView.image = thumbnailImage;
}

- (UIImage*) thumbnailImage {
    return self.imageView.image;
}

- (void) setLivePhotoBadgeImage:(UIImage*)livePhotoBadgeImage {
    self.livePhotoBadgeImageView.image = livePhotoBadgeImage;
}

- (UIImage*) livePhotoBadgeImage {
    return self.livePhotoBadgeImageView.image;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.livePhotoBadgeImageView.image = nil;
}


@end
