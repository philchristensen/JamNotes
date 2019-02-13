//
//  HPBImportTableCell.h
//  JamNotes
//
//  Created by Phil Christensen on 8/17/13.
//  Copyright (c) 2013-2019 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBImportTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* bandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@end
