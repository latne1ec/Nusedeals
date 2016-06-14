//
//  LoginTableViewController.h
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMessageView.h"

@interface LoginTableViewController : UITableViewController <UITextFieldDelegate, TSMessageViewProtocol>

@property (weak, nonatomic) IBOutlet UITableViewCell *cellOne;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTwo;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellThree;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFour;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)login:(id)sender;

@end
