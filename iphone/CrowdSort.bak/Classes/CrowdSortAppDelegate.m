//
//  CrowdSortAppDelegate.m
//  CrowdSort
//
//  Created by jd on 4/13/10.
//  Copyright J2 Labs LLC 2010. All rights reserved.
//

#import "CrowdSortAppDelegate.h"
#import "SearchableListViewController.h"
#import "LoginViewController.h"

@implementation CrowdSortAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize loginViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// If username and password are saved, try logging in with them.
	
	[window addSubview:[tabBarController view]];

	LoginViewController *_loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:[NSBundle mainBundle]];
	self.loginViewController = _loginViewController;
	[_loginViewController release];
	[tabBarController presentModalViewController:self.loginViewController animated:YES];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[tabBarController release];
	[tabBarController release];
	[window release];
    [super dealloc];
}


@end
