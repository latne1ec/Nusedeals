//
//  AppDelegate.m
//  NurseDeals
//
//  Created by Evan Latner on 5/31/16.
//  Copyright © 2016 NurseDeals. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Stripe/Stripe.h>


NSString * const StripePublishableKey = @"pk_live_QsWMJxhZQR2a46HwWN9laWV3";
NSString * const StripeTestKey = @"pk_test_KUDRIYhPLVu3TQaxOSWuh6WK";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize Parse.
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"HWKUXwgoZqbWTfHhbedfwGpGlJZD3ueD8dPONtdC";
        configuration.server = @"https://nursedeals.herokuapp.com/parse";
    }]];
    
    //Stripe Keys
    [Stripe setDefaultPublishableKey:StripeTestKey];

    
    //Nav Bar Back Button Color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Nav Bar Title
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.21 alpha:1.0]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, .0);
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          shadow, NSShadowAttributeName,
                                                          [UIFont fontWithName:@"MyriadPro-Regular" size:19], NSFontAttributeName, nil]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
