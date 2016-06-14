//
//  FeedTableCell.h
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *venueImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;


@end
