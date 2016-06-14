//
//  FeedTableViewController.h
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FeedTableCell.h"
#import "Venue.h"
#import "DetailTableViewController.h"

@interface FeedTableViewController : UITableViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableArray *venues;
@property (nonatomic, strong) PFGeoPoint *currentLocation;

@end
