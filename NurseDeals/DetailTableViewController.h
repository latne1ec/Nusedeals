//
//  DetailTableViewController.h
//  NurseDeals
//
//  Created by Evan Latner on 6/2/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Venue.h"
#import "AFImageViewer.h"

@interface DetailTableViewController : UITableViewController <UIScrollViewDelegate>

@property (nonatomic, strong) Venue *venue;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) PFGeoPoint *venueLocation;
@property (nonatomic, strong) UIImage *initialImage;
@property (nonatomic, strong) NSMutableArray *venueImagesArray;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueDescription;
@property (nonatomic, strong) PFGeoPoint *userLocation;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellOne;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTwo;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellThree;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFour;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFive;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *venueAddressLabel;
@property (weak, nonatomic) IBOutlet UITextView *venueDescriptionTextview;
@property (weak, nonatomic) IBOutlet UIImageView *imageFade;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet AFImageViewer *imageViewer;

//Offer
@property (weak, nonatomic) IBOutlet UILabel *bannerOfferLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *proMembersButton;
@property (weak, nonatomic) IBOutlet UIButton *claimOfferButton;

-(void)updateProOfferDetails;

@end

