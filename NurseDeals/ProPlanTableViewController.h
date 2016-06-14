//
//  ProPlanTableViewController.h
//  NurseDeals
//
//  Created by Evan Latner on 6/2/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Stripe/Stripe.h>
#import "TSMessageView.h"

@interface ProPlanTableViewController : UITableViewController <TSMessageViewProtocol, NSURLConnectionDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *cellOne;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTwo;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellThree;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFour;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *expTextfield;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextfield;

@end
