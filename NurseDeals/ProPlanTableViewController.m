//
//  ProPlanTableViewController.m
//  NurseDeals
//
//  Created by Evan Latner on 6/2/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import "ProPlanTableViewController.h"
#import "ProgressHUD.h"

@interface ProPlanTableViewController ()


@end

@implementation ProPlanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TSMessage setDefaultViewController:self];
    [TSMessage setDelegate:self];
    
    self.cardNumberTextfield.delegate = self;
    self.expTextfield.delegate = self;
    self.cvcTextfield.delegate = self;
    
    self.title = @"Upgrade to Pro Plan";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:(UIImage *) [[UIImage imageNamed:@"backButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissViewControllerAnimated:completion:)];
    
    self.tableView.tableFooterView = [UIView new];
    
    CALayer *btn1 = [self.completeButton layer];
    [btn1 setMasksToBounds:YES];
    [btn1 setCornerRadius:20.0f];
    [btn1 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0].CGColor];
    self.completeButton.alpha = 0.9;
    [self.completeButton addTarget:self action:@selector(savePaymentInfo) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[PFUser currentUser] objectForKey:@"lastFourCC"]) {
        self.cardNumberTextfield.text = [NSString stringWithFormat:@"************%@", [[PFUser currentUser] objectForKey:@"lastFourCC"]];
        self.cardNumberTextfield.enabled = false;
        self.expTextfield.text = [[PFUser currentUser] objectForKey:@"fakeExpCode"];
        self.expTextfield.enabled = false;
        self.cvcTextfield.text = [[PFUser currentUser] objectForKey:@"fakeCvvCode"];
        self.cvcTextfield.enabled = false;
        [self.completeButton.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:16]];
        [self.completeButton setTitle:@"Cancel Subscription" forState:UIControlStateNormal];
        [self.completeButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.27 blue:0.27 alpha:1.0]];
        [self.completeButton removeTarget:self action:@selector(savePaymentInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.completeButton addTarget:self action:@selector(cancelSubscriptionTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    
    if (_fromDetailView) {
        [self.dvc updateProOfferDetails];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([self.cardNumberTextfield isFirstResponder]) {
        
        if([string length]>0){
            if([textField.text length]>15 && [string characterAtIndex:0]!=5){
                NSLog(@"Here: %@", string);
                return NO;
            }
        }
    }
    
    if ([self.expTextfield isFirstResponder]) {
        
        if([string length]>0){
            if([textField.text length]>4 && [string characterAtIndex:0]!=5){
                NSLog(@"Here: %@", string);
                return NO;
            }
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
        
        NSUInteger length = decimalString.length;
        
        NSUInteger index = 0;
        NSMutableString *formattedString = [NSMutableString string];
        
        if (length - index > 2) {
            NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 2)];
            [formattedString appendFormat:@"%@/",areaCode];
            index += 2;
        }
        
        NSString *remainder = [decimalString substringFromIndex:index];
        [formattedString appendString:remainder];
        
        textField.text = formattedString;
        return NO;
        
    }
    
    if ([self.cvcTextfield isFirstResponder]) {
        
        if([string length]>0){
            if([textField.text length]>3 && [string characterAtIndex:0]!=5){
                NSLog(@"Here: %@", string);
                return NO;
            }
        }
    }
    
    
    return YES;
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [self.cardNumberTextfield becomeFirstResponder];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    [self.cardNumberTextfield resignFirstResponder];
    [self.expTextfield resignFirstResponder];
    [self.cvcTextfield resignFirstResponder];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        _cellOne.separatorInset = UIEdgeInsetsMake(0.f, 10000.0f, 0.f, 0.0f);
    }
    if (indexPath.row == 0) return _cellOne;
    if (indexPath.row == 1) return _cellTwo;
    if (indexPath.row == 2) return _cellThree;
    if (indexPath.row == 3) {
        _cellFour.separatorInset = UIEdgeInsetsMake(0.f, 10000.0f, 0.f, 0.0f);
    }
    if (indexPath.row == 3) return _cellFour;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 96;
    }
    if (indexPath.row == 3) {
        return 150;
    }
    return 56;
}

-(void)savePaymentInfo {
    
    if ([[PFUser currentUser] objectForKey:@"stripeToken"] != nil) {
        NSLog(@"Already set up payment info");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Saved" message:@"This card has already been saved to your Stockd account. You're good to go!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        
        if (self.cardNumberTextfield.text.length < 16) {
            
            [TSMessage showNotificationInViewController:self.navigationController
                                                  title:@"Error"
                                               subtitle:@"Invalid credit card number"
                                                  image:nil
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:^{}
                                             atPosition:TSMessageNotificationPositionNavBarOverlay
                                   canBeDismissedByUser:YES];
        }
        
        else if (self.expTextfield.text.length < 4) {
            
            [TSMessage showNotificationInViewController:self.navigationController
                                                  title:@"Error"
                                               subtitle:@"Invalid expiration date"
                                                  image:nil
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:^{}
                                             atPosition:TSMessageNotificationPositionNavBarOverlay
                                   canBeDismissedByUser:YES];
            
        }
        
        else if (self.cvcTextfield.text.length < 3) {
            
            [TSMessage showNotificationInViewController:self.navigationController
                                                  title:@"Error"
                                               subtitle:@"Invalid CVV"
                                                  image:nil
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:^{}
                                             atPosition:TSMessageNotificationPositionNavBarOverlay
                                   canBeDismissedByUser:YES];
        }
        
        else {
            
            [self.cardNumberTextfield resignFirstResponder];
            [self.expTextfield resignFirstResponder];
            [self.cvcTextfield resignFirstResponder];
            
            NSString *exp = self.expTextfield.text;
            
            [ProgressHUD show:nil Interaction:NO];
            STPCard *card = [[STPCard alloc] init];
            card.number = self.cardNumberTextfield.text;
            card.expMonth = [[exp substringToIndex:2] integerValue];
            card.expYear = [[exp substringFromIndex: [exp length] - 2] integerValue];
            card.cvc = self.cvcTextfield.text;
            [[STPAPIClient sharedClient] createTokenWithCard:card
                                                  completion:^(STPToken *token, NSError *error) {
                                                      if (error) {
                                                          
                                                          NSLog(@"Error 1: %@",error.localizedDescription);
                                                          [ProgressHUD dismiss];
                                                          [TSMessage showNotificationInViewController:self.navigationController
                                                                                                title:@"Error"
                                                                                             subtitle:@"Invalid credit card info"
                                                                                                image:nil
                                                                                                 type:TSMessageNotificationTypeError
                                                                                             duration:TSMessageNotificationDurationAutomatic
                                                                                             callback:nil
                                                                                          buttonTitle:nil
                                                                                       buttonCallback:^{}
                                                                                           atPosition:TSMessageNotificationPositionNavBarOverlay
                                                                                 canBeDismissedByUser:YES];
                                                          
                                                          
                                                          
                                                      } else {
                                                          //[ProgressHUD dismiss];
                                                          NSString *theToken = [NSString stringWithFormat:@"%@",token];
                                                          NSString *formattedToken = [theToken stringByReplacingOccurrencesOfString:@" (test mode)" withString:@""];
                                                          
                                                          [self saveUserTokenToParse:formattedToken];
                                                          
                                                      }
                                                  }];
        }
    }
}

-(void)saveUserTokenToParse:(NSString *)token {
    
    NSString *lastFourCC = [self.cardNumberTextfield.text substringFromIndex: [self.cardNumberTextfield.text length] - 4];
    NSString *expCode = @"****";
    NSString *cvcCode = @"***";
    
    [[PFUser currentUser] setObject:token forKey:@"stripeToken"];
    [[PFUser currentUser] setObject:lastFourCC forKey:@"lastFourCC"];
    [[PFUser currentUser] setObject:expCode forKey:@"fakeExpCode"];
    [[PFUser currentUser] setObject:cvcCode forKey:@"fakeCvvCode"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [ProgressHUD dismiss];
            [TSMessage showNotificationInViewController:self.navigationController
                                                  title:@"Error"
                                               subtitle:[error.userInfo objectForKey:@"error"]
                                                  image:nil
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:^{}
                                             atPosition:TSMessageNotificationPositionNavBarOverlay
                                   canBeDismissedByUser:YES];
            
            
        }
        else {
            [self createCustomerFromToken:token];
            //[parent paymentMessage];
        }
    }];
}

-(void)createCustomerFromToken: (NSString *)token {
    
    NSString *urlString = [NSString stringWithFormat:@"https://warm-savannah-23418.herokuapp.com/?token=%@", token];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:30.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    
    NSString *customerId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *finalCustomerId = [customerId stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSLog(@"Customer Id: %@", finalCustomerId);
    [[PFUser currentUser] setObject:finalCustomerId forKey:@"customerID"];
    [[PFUser currentUser] setObject:@"true" forKey:@"proMember"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error 4: %@", error.localizedDescription);
        } else{
            NSLog(@"Successfully saved Customer ID");
            //[self createSubscriptionWithCustomer:finalCustomerId];
            [ProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];

}

-(void)createSubscriptionWithCustomer: (NSString *)customerId {
   
    NSString *urlString = [NSString stringWithFormat:@"http://smashfeed.co/subscribeCustomer.php?customerId=%@", customerId];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:30.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

}

-(void)cancelSubscriptionTapped {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cancel Subscription?" message:@"Are you sure you want to cancel your subscription? Your credit card on file will be removed and you will  no longer be charged the monthly subscription fee." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
    alertView.tag = 55;
    alertView.delegate = self;

}

//*********************************************
// Actions Methods For Logout Button

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
    if (alertView.tag == 55) {
        
        if (buttonIndex == 0) {
            
        }
        else if (buttonIndex == 1) {
            
            [self clearCardDetails];
            
        }
    }
}
//*********************************************

-(void)clearCardDetails {
    
    [ProgressHUD show:nil Interaction:false];
    [[PFUser currentUser] removeObjectForKey:@"lastFourCC"];
    [[PFUser currentUser] removeObjectForKey:@"stripeToken"];
    [[PFUser currentUser] removeObjectForKey:@"fakeExpCode"];
    [[PFUser currentUser] removeObjectForKey:@"fakeCvvCode"];
    [[PFUser currentUser] removeObjectForKey:@"customerID"];
    [[PFUser currentUser] removeObjectForKey:@"proMember"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            
            [ProgressHUD dismiss];
            [TSMessage showNotificationInViewController:self.navigationController
                                                  title:@"Error"
                                               subtitle:[error.userInfo objectForKey:@"error"]
                                                  image:nil
                                                   type:TSMessageNotificationTypeError
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:^{}
                                             atPosition:TSMessageNotificationPositionNavBarOverlay
                                   canBeDismissedByUser:YES];
            
        } else {
            
            [ProgressHUD dismiss];
            [TSMessage showNotificationInViewController:self.navigationController
                                                  title:@"Success"
                                               subtitle:@"Removed credit card information"
                                                  image:nil
                                                   type:TSMessageNotificationTypeSuccess
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:^{}
                                             atPosition:TSMessageNotificationPositionNavBarOverlay
                                   canBeDismissedByUser:YES];
            
            [self.tableView reloadData];
            self.cardNumberTextfield.text = nil;
            self.expTextfield.text = nil;
            self.cvcTextfield.text = nil;
            self.cardNumberTextfield.enabled = YES;
            self.expTextfield.enabled = YES;
            self.cvcTextfield.enabled = YES;
            
            [self.completeButton.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17]];
            [self.completeButton setTitle:@"Complete" forState:UIControlStateNormal];
            CALayer *btn1 = [self.completeButton layer];
            [btn1 setMasksToBounds:YES];
            [btn1 setCornerRadius:20.0f];
            [btn1 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0].CGColor];
            self.completeButton.alpha = 0.9;
            [self.completeButton removeTarget:self action:@selector(cancelSubscriptionTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.completeButton addTarget:self action:@selector(savePaymentInfo) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }];
}

@end
