//
//  SignupTableViewController.h
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMessageView.h"

@interface SignupTableViewController : UITableViewController <UITextFieldDelegate, TSMessageViewProtocol>

@property (weak, nonatomic) IBOutlet UITableViewCell *cellOne;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTwo;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFour;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSix;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellSeven;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellEight;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UISwitch *termsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)signup:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *termsOfServiceButton;


@end
