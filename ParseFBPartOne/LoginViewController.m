//
//  Copyright (c) 2013 Parse. All rights reserved.

#import "LoginViewController.h"
#import "UserDetailsViewController.h"
#import <Parse/Parse.h>

@implementation LoginViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Facebook Profile";
    
    // Check if user is cached and linked to Facebook, if so, bypass login    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
         // Create your settings view controller
         UserDetailsViewController *settingsVC = [[UserDetailsViewController alloc] initWithNibName:nil bundle:nil];
         
         // Create a tab bar item
         //UITabBarItem *settingsItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"Icon.png" tag:0];
         
         UITabBarItem *settingsItem = [[UITabBarItem alloc] init];
         
         settingsVC.tabBarItem = settingsItem;
         
         // Get the storyboard
         UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

         // Instantiate the Storyboard with your ViewController
         UITabBarController *tbC = [mystoryboard instantiateViewControllerWithIdentifier:@"TopTabView"];
        
         // Get the current view controllers in your tab bar
         NSMutableArray *currentItems = [NSMutableArray arrayWithArray:tbC.viewControllers];
         
         // Add your settings controller
         [currentItems addObject:settingsVC];
         tbC.viewControllers = [NSArray arrayWithArray:currentItems];

         // We don't want to move backwards to the LoginViewController sitting on the stack
         [self.navigationController setNavigationBarHidden:YES];
        
         [self.navigationController pushViewController:tbC animated:NO];
    }
}


#pragma mark - Login mehtods

/* Login to facebook method */
- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

@end
