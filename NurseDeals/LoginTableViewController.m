//
//  LoginTableViewController.m
//  NurseDeals
//
//  Created by Evan Latner on 6/1/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import "LoginTableViewController.h"
#import "ProgressHUD.h"
#import <Parse/Parse.h>
#import "FeedTableViewController.h"

@interface LoginTableViewController ()

@property (nonatomic) BOOL loggingIn;

@end

@implementation LoginTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loggingIn = false;
    
//    [TSMessage setDefaultViewController:self];
//    [TSMessage setDelegate:self];
    
    self.tableView.tableFooterView = [UIView new];
    self.usernameTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
       
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userIcon"]];
    view.frame = CGRectMake(-100, 0, 34, 34);
    view.contentMode = UIViewContentModeCenter;
    self.usernameTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTextfield.leftView = view;
   
    self.usernameTextfield.layer.cornerRadius = 16;
    [self.usernameTextfield setBackgroundColor:[UIColor whiteColor]];
    [self.usernameTextfield.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.usernameTextfield.layer setBorderWidth:1.0];
   
    
    UIImageView *view2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"key"]];
    view2.frame = CGRectMake(-100, 0, 34, 34);
    view2.contentMode = UIViewContentModeCenter;
    self.passwordTextfield.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextfield.leftView = view2;
    
    self.passwordTextfield.layer.cornerRadius = 16;
    [self.passwordTextfield setBackgroundColor:[UIColor whiteColor]];
    [self.passwordTextfield.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.passwordTextfield.layer setBorderWidth:1.0];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    
    CALayer *btn1 = [self.loginButton layer];
    [btn1 setMasksToBounds:YES];
    [btn1 setCornerRadius:20.0f];
    [btn1 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0].CGColor];
    
    self.loginButton.alpha = 1.0;
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.84 alpha:1.0];
    self.tableView.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.84 alpha:1.0];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    //Table View Background Image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBkg"]];
    imageView.alpha = 0.162;
    [self.tableView setBackgroundView:imageView];
    
    if([UIScreen mainScreen].bounds.size.height <= 568.0) {
    } else if ([UIScreen mainScreen].bounds.size.height == 667){
        [self.tableView setContentInset:UIEdgeInsetsMake(22,0,0,0)];
    } else {
        [self.tableView setContentInset:UIEdgeInsetsMake(64,0,0,0)];
    }
}

-(void)dismissKeyboard {
    
    [self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(50.0, 0.0, (keyboardSize.height), 0.0);
    }
    
    self.tableView.contentInset = contentInsets;
    //self.tableView.scrollIndicatorInsets = contentInsets;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];

}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    //[TSMessage dismissActiveNotification];
    
   //[TSMessage setDefaultViewController:nil];
    
    if (_loggingIn) {
        NSLog(@"loggin in!");
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController.navigationBar setHidden:false];
        self.navigationController.navigationBarHidden = NO;
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    
    if([self.usernameTextfield isFirstResponder]){
        [self.passwordTextfield  becomeFirstResponder];
    }
    else if ([self.passwordTextfield isFirstResponder]){
        [self.passwordTextfield resignFirstResponder];
        [self login:self];
    }
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) return _cellOne;
    if (indexPath.row == 1) return _cellTwo;
    if (indexPath.row == 2) return _cellThree;
    if (indexPath.row == 3) return _cellFour;
    
    return nil;
}

- (IBAction)login:(id)sender {
    
    [self.usernameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    
    NSString *username = [self.usernameTextfield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextfield.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0) {
        [ProgressHUD dismiss];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
          }
    else if ([password length] == 0) {
        [ProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    else {
        [ProgressHUD show:nil];
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                
                [ProgressHUD dismiss];
                if (error.userInfo.count >= 3) {
                    NSLog(@"Here");
                    if ([[error.userInfo objectForKey:@"error"] isEqualToString:@"invalid login parameters"]) {
                        [ProgressHUD dismiss];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid username/password combination" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                    }
                    else {
                        [ProgressHUD dismiss];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An unknown error occured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
                else {
                    [ProgressHUD dismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An unknown error occured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
            }
            else {
                
                _loggingIn = true;
                
                [ProgressHUD dismiss];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                [currentInstallation saveInBackground];
                
                /////Pop To Main View Controller
                FeedTableViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Feed"];
                UINavigationController *navigationController =
                [[UINavigationController alloc] initWithRootViewController:destViewController];
                UIBarButtonItem *newBackButton =
                [[UIBarButtonItem alloc] initWithTitle:@""
                                                 style:UIBarButtonItemStylePlain
                                                target:nil
                                                action:nil];
                
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                CATransition *transition = [CATransition animation];
                [transition setType:kCATransitionFade];
                [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
                
                [[navigationController navigationItem] setBackBarButtonItem:newBackButton];
                
                [self.navigationController.navigationBar setHidden:false];
                
                [self.navigationController pushViewController:destViewController animated:NO];
                
                [CATransaction commit];
            }
        }];
    }
}
@end
