//
//  Venue.h
//  NurseDeals
//
//  Created by Evan Latner on 6/2/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Venue : NSObject

@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) PFGeoPoint *venueLocation;
@property (nonatomic, strong) NSMutableArray *venueImagesArray;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueDescription;
@property (nonatomic, strong) NSString *venueOffer;
@property (nonatomic, strong) NSString *proMemberOffer;

@end
