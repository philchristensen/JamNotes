//
//  HPBEventPhotosCollectionViewCell.h
//  JamNotes
//
//  Created by Phil Christensen on 2/12/19.
//  Copyright © 2019 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPBEventPhotosCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* representedAssetIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView* imageView;

@end

NS_ASSUME_NONNULL_END