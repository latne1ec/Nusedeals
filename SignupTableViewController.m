//
//  SignupTableViewController.m
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import "SignupTableViewController.h"
#import "ProgressHUD.h"
#import <Parse/Parse.h>
#import "FeedTableViewController.h"

@interface SignupTableViewController ()

@end

@implementation SignupTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TSMessage setDefaultViewController:self];
    [TSMessage setDelegate:self];
    
    self.title = @"Sign Up";
    self.tableView.tableFooterView = [UIView new];
    self.firstNameTextfield.delegate = self;
    self.lastNameTextfield.delegate = self;
    self.emailTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
    CALayer *btn1 = [self.signupButton layer];
    [btn1 setMasksToBounds:YES];
    [btn1 setCornerRadius:20.0f];
    [btn1 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0].CGColor];
    
    self.signupButton.alpha = 0.9;
    
    UIImage *buttonImage = [UIImage imageNamed:@"backButton"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(-36, 1000, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.termsOfServiceButton addTarget:self action:@selector(openTermsOfService) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)openTermsOfService {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://nursedeals.com/pages/terms-of-service"]];

}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(62.0, 0.0, (keyboardSize.height), 0.0);
    }
    
    self.tableView.contentInset = contentInsets;
    //self.tableView.scrollIndicatorInsets = contentInsets;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.passwordTextfield resignFirstResponder];
    self.tableView.contentInset = UIEdgeInsetsMake(62.0, 0.0, (keyboardSize.height), 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    //NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    //[self.tableView reloadData];
    
}

-(void)popBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
     self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.firstNameTextfield becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.firstNameTextfield resignFirstResponder];
    [self.lastNameTextfield resignFirstResponder];
    [self.emailTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return _cellOne;
    if (indexPath.row == 1) return _cellTwo;
    if (indexPath.row == 2) return _cellFour;
    if (indexPath.row == 3) return _cellSix;
    if (indexPath.row == 4) {
        _cellSeven.separatorInset = UIEdgeInsetsMake(0.f, 10000.0f, 0.f, 0.0f);
    }
    if (indexPath.row == 4) return _cellSeven;
    if (indexPath.row == 5) {
        _cellEight.separatorInset = UIEdgeInsetsMake(0.f, 10000.0f, 0.f, 0.0f);
    }
    if (indexPath.row == 5) return _cellEight;
    
    return nil;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    
    if([self.firstNameTextfield isFirstResponder]){
        [self.lastNameTextfield  becomeFirstResponder];
    }
    else if ([self.lastNameTextfield isFirstResponder]){
        [self.emailTextfield becomeFirstResponder];
    }
    else if ([self.emailTextfield isFirstResponder]){
        [self.passwordTextfield becomeFirstResponder];
    }
    else if ([self.passwordTextfield isFirstResponder]){
        [self.passwordTextfield resignFirstResponder];
        [self signup:self];
    }
    return YES;
}

- (IBAction)signup:(id)sender {
    
    [self.passwordTextfield resignFirstResponder];
    
    NSString *firstName = [self.firstNameTextfield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.lastNameTextfield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *email = [self.emailTextfield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextfield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([firstName length] == 0) {
        [TSMessage showNotificationInViewController:self.navigationController
                                              title:@"Error"
                                           subtitle:@"Please enter your name"
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:^{}
                                         atPosition:TSMessageNotificationPositionNavBarOverlay
                               canBeDismissedByUser:YES];
        
    }
    else if ([lastName length] == 0) {
        [TSMessage showNotificationInViewController:self.navigationController
                                              title:@"Error"
                                           subtitle:@"Please enter your name"
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:^{}
                                         atPosition:TSMessageNotificationPositionNavBarOverlay
                               canBeDismissedByUser:YES];
        
    }

    else if ([email length] == 0) {
        [TSMessage showNotificationInViewController:self.navigationController
                                              title:@"Error"
                                           subtitle:@"Please enter your email"
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:^{}
                                         atPosition:TSMessageNotificationPositionNavBarOverlay
                               canBeDismissedByUser:YES];
        
    }
    else if ([password length] == 0) {
        [TSMessage showNotificationInViewController:self.navigationController
                                              title:@"Error"
                                           subtitle:@"Please enter a password"
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:^{}
                                         atPosition:TSMessageNotificationPositionNavBarOverlay
                               canBeDismissedByUser:YES];
    }
    else if (!_termsSwitch.isOn) {
        [TSMessage showNotificationInViewController:self.navigationController
                                              title:@"Error"
                                           subtitle:@"Please accept the terms of service"
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
        
        [ProgressHUD show:nil Interaction:NO];
        PFUser *newUser = [PFUser user];
        newUser.username = email;
        newUser.password = password;
        newUser.email = email;
        
        [newUser setObject:firstName forKey:@"firstName"];
        [newUser setObject:lastName forKey:@"lastName"];
        [newUser setObject:@"false" forKey:@"proMember"];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                [currentInstallation saveInBackground];
                
                [ProgressHUD dismiss];
                FeedTableViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Feed"];
                
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                CATransition *transition = [CATransition animation];
                [transition setType:kCATransitionFade];
                [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
                [self.navigationController pushViewController:destViewController animated:NO];
                [CATransaction commit];
            }
        }];
    }
}

@end
