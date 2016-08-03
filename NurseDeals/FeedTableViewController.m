//
//  FeedTableViewController.m
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import "FeedTableViewController.h"
#import "LoginTableViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ProPlanTableViewController.h"
#import "ProgressHUD.h"

@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Nearby";
    self.tableView.tableFooterView = [UIView new];
    
    if ([PFUser currentUser]) {
    } else {
        LoginTableViewController *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:wvc animated:NO];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pro Plan" style:UIBarButtonItemStylePlain target:self action:@selector(upgradeToProTapped)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pro Plan" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped)];
    
    [[PFUser currentUser] removeObjectForKey:@"claimedOfferIds"];
    [[PFUser currentUser] saveInBackground];
    
}


-(void)upgradeToProTapped {
    
    ProPlanTableViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProPlan"];
    
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

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.hidesBackButton = YES;
    
    if ([PFUser currentUser]) {
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (error) {
                NSLog(@"Location Error: %@", error.localizedDescription);
            }
            else {
                [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
                [[PFUser currentUser] saveInBackground];
                self.currentLocation = geoPoint;
                [self getAllVenues];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FeedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *object = [self.venues objectAtIndex:indexPath.row];
    
    PFGeoPoint *venueLocation = [object objectForKey:@"venueLocation"];
    CLLocationDegrees lat = venueLocation.latitude;
    CLLocationDegrees lon = venueLocation.longitude;
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = lat;
    coordinates.longitude = lon;
    CLLocation *venueLocationCoor = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLLocation *userLoca = [[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    CLLocationDistance distance = [userLoca distanceFromLocation:venueLocationCoor];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f miles away",(distance/1609.344)];
    [cell.distanceLabel setTextColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0]];
    cell.venueNameLabel.text = [object objectForKey:@"venueName"];
    
    NSString *offerString = [object objectForKey:@"venueOffer"];
    NSString *strippedString = [offerString stringByReplacingOccurrencesOfString:@"OFF" withString:@""];
    cell.offerLabel.text = [NSString stringWithFormat:@"-%@", strippedString];
    
    if ([[[PFUser currentUser] objectForKey:@"proMember"] isEqualToString:@"true"]) {
        NSString *offerString = [object objectForKey:@"proMemberOffer"];
        NSString *strippedString = [offerString stringByReplacingOccurrencesOfString:@"OFF" withString:@""];
        cell.offerLabel.text = [NSString stringWithFormat:@"-%@", strippedString];
    }
    
    NSArray *imageArray = [object objectForKey:@"venueImageArray"];
    NSString *imageUrlString = [imageArray objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:imageUrlString];
    [cell.venueImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

//*****************************
//Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow]; DetailTableViewController *destViewController = segue.destinationViewController;
            FeedTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            PFObject *object = [self.venues objectAtIndex:indexPath.row];
            Venue *venue = [[Venue alloc] init];
            venue.venueName = [object objectForKey:@"venueName"];
            venue.venueId = object.objectId;
            venue.venueDescription = [object objectForKey:@"venueDescription"];
            venue.venueLocation = [object objectForKey:@"venueLocation"];
            venue.venueAddress = [object objectForKey:@"venueAddress"];
            venue.venueImagesArray = [object objectForKey:@"venueImageArray"];
            venue.venueOffer = [object objectForKey:@"venueOffer"];
            venue.proMemberOffer = [object objectForKey:@"proMemberOffer"];
            destViewController.userLocation = self.currentLocation;
            destViewController.initialImage = cell.venueImageView.image;
            destViewController.venue= venue;
    }
}

-(void)getAllVenues {
    
    //[ProgressHUD show:nil Interaction:false];
    PFQuery *query = [PFQuery queryWithClassName:@"Venues"];
    [query whereKey:@"venueLocation" nearGeoPoint:self.currentLocation withinMiles:20];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            [ProgressHUD showError:@"Network Error"];
            NSLog(@"error: %@", error.localizedDescription);
        } else {
            [ProgressHUD dismiss];
            self.venues = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

-(void)logoutButtonTapped {
    
}

@end
