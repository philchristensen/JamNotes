//
//  HPBShowTableCell.h
//  Setlists
//
//  Created by Phil Christensen on 8/5/13.
//  Copyright (c) 2013 Phil Christensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPBShowTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* bandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* setlistLabel;
@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@end
