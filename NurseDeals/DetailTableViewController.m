//
//  DetailTableViewController.m
//  NurseDeals
//
//  Created by Evan Latner on 6/2/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import "DetailTableViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ProPlanTableViewController.h"
#import "ProgressHUD.h"

@interface DetailTableViewController ()

@property(nonatomic) float w, h;
@property (nonatomic) int imageIndex;

@end

@implementation DetailTableViewController

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
    self.venueId = self.venue.venueId;
    self.venueNameLabel.text = self.venue.venueName; //Changed to Directions
    self.venueDescriptionTextview.text = self.venue.venueDescription;
    self.venueLocation = self.venue.venueLocation;
    self.venueAddress = self.venue.venueAddress;
    self.venueImagesArray = self.venue.venueImagesArray;
    
    CLLocationDegrees lat = self.venueLocation.latitude;
    CLLocationDegrees lon = self.venueLocation.longitude;
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = lat;
    coordinates.longitude = lon;
    CLLocation *venueLocationCoor = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLLocation *userLoca = [[CLLocation alloc] initWithLatitude:self.userLocation.latitude longitude:self.userLocation.longitude];
    CLLocationDistance distance = [userLoca distanceFromLocation:venueLocationCoor];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f miles away",(distance/1609.344)];
    
    self.venueAddressLabel.text = self.venue.venueAddress;
    [self.venueAddressLabel setTextColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0]];
    self.venueAddressLabel.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps)];
    [self.venueAddressLabel addGestureRecognizer:tap];
    
    if([UIScreen mainScreen].bounds.size.height <= 568.0) {
        
    } else {
        [self.venueAddressLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:15.7]];
    }
    
    NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.venueImagesArray.count; i++) {
        NSString *urlString = [self.venueImagesArray objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:urlString];
        [imageUrls addObject:url];
    }
    
    self.imageViewer.loadingImage = self.initialImage;
    self.imageViewer.imagesUrls = imageUrls;
    [self.imageViewer setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageViewer bringSubviewToFront:self.bannerImageView];
    [self.imageViewer bringSubviewToFront:self.bannerOfferLabel];
    
    self.offerLabel.text = self.venue.venueOffer;
    NSString *offerString = self.venue.venueOffer;
    NSString *strippedString = [offerString stringByReplacingOccurrencesOfString:@"OFF" withString:@""];
    self.bannerOfferLabel.text = [NSString stringWithFormat:@"-%@", strippedString];
    self.offerLabel.hidden = YES;
    self.offerDetailsLabel.hidden = YES;
    self.proMembersButton.hidden = YES;
    
    
    if ([[[PFUser currentUser] objectForKey:@"proMember"] isEqualToString:@"true"]) {
        self.offerLabel.text = self.venue.proMemberOffer;
        NSString *offerString = self.venue.proMemberOffer;
        NSString *strippedString = [offerString stringByReplacingOccurrencesOfString:@"OFF" withString:@""];
        self.bannerOfferLabel.text = [NSString stringWithFormat:@"-%@", strippedString];
        [self.proMembersButton setTitle:@"Exclusive Pro Member Offer" forState:UIControlStateNormal];
        self.proMembersButton.enabled = false;
    }
    
    _cellFour.backgroundColor = [UIColor whiteColor];
    
    self.claimOfferButton.layer.cornerRadius = 18;
    self.claimOfferButton.alpha = 0.9;
    [self.claimOfferButton addTarget:self action:@selector(claimOfferTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonImage = [UIImage imageNamed:@"backButton"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(-36, 1000, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    [self.proMembersButton addTarget:self action:@selector(upgradeToProTapped) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)updateProOfferDetails {
    
    self.offerLabel.text = self.venue.proMemberOffer;
    NSString *offerString = self.venue.proMemberOffer;
    NSString *strippedString = [offerString stringByReplacingOccurrencesOfString:@"OFF" withString:@""];
    self.bannerOfferLabel.text = [NSString stringWithFormat:@"-%@", strippedString];
    [self.proMembersButton setTitle:@"Exclusive Pro Member Offer" forState:UIControlStateNormal];
    self.proMembersButton.enabled = false;
    
}

-(void)openMaps {
    
    CLLocationDegrees lat = self.venueLocation.latitude;
    CLLocationDegrees lon = self.venueLocation.longitude;
    CLLocationDegrees userlat = self.userLocation.latitude;
    CLLocationDegrees userlon = self.userLocation.longitude;
    
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",userlat, userlon, lat,lon];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

-(void)upgradeToProTapped {
    
    ProPlanTableViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProPlan"];
    
    destViewController.fromDetailView = true;
    destViewController.dvc = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:destViewController];
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Upgrade to Pro Plan"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[navigationController navigationItem] setBackBarButtonItem:newBackButton];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{
    }];
}

-(void)popBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

-(void)claimOfferTapped {
    
    NSArray *array = [[PFUser currentUser] objectForKey:@"claimedOfferIds"];
    if ([array containsObject:self.venueId]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already redeemed" message:@"You have already redeemed this offer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.claimOfferButton.transform = CGAffineTransformMakeScale(.92, .92);
        self.claimOfferButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        _cellFour.backgroundColor = [UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0];
        self.offerLabel.hidden = false;
        self.offerDetailsLabel.hidden = false;
        self.proMembersButton.hidden = false;

    }];
    
    [[PFUser currentUser] addUniqueObject:self.venueId forKey:@"claimedOfferIds"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [ProgressHUD showError:@"Network Error"];
        } else {
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    CGRect frame = self.pageControl.frame;
    //CGRect frame = CGRectMake(20, CGRectGetHeight(self.view.frame)-94, 50, 50);
    
    frame.origin.x = self.scrollView.contentOffset.y-24 + self.tableView.frame.size.height - self.pageControl.frame.size.height;
    self.pageControl.frame = frame;
    
    self.imageFade.center = self.scrollView.center;
    self.pageControl.center = self.scrollView.center;
    
    [self.view bringSubviewToFront:self.pageControl];
    
}

-(void)downloadAllPics {
    
    for (int i = 0; i < self.venueImagesArray.count; i++) {
        NSString *urlString = [self.venueImagesArray objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:urlString];
        SDWebImageManager *managerTwo = [SDWebImageManager sharedManager];
        
        if ([managerTwo cachedImageExistsForURL:url]) {
            //NSLog(@"already got em champ");
        } else {
            
            [managerTwo downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            }
                                   completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                       //NSLog(@"Image: %@", images);
                                       
                                   }];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return _cellOne;
    if (indexPath.row == 1) return _cellTwo;
    if (indexPath.row == 2) return _cellThree;
    if (indexPath.row == 3) return _cellFour;
    if (indexPath.row == 4) return _cellFive;

    return nil;
}

@end
