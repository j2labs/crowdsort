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
#import "AppConstants.h"
#import "JSON.h"

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


+ (NSDictionary *)runSynchronousQuery:(NSString *)queryUrl {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSString *credentials = [defaults stringForKey:kCredentials];
	NSString *serverAddr = [defaults stringForKey:kServerAddress];
	NSString *urlString = [NSString stringWithFormat:@"http://%@%@", serverAddr, queryUrl];
	NSLog(urlString);
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSArray *data = [parser objectWithString:jsonString error:nil];
	NSDictionary *datum = [data objectAtIndex:0];
	NSDictionary *fields = [datum objectForKey:@"fields"];

	[parser release];
	[jsonString release];
	
	return fields;
}


- (void)dealloc {
	[tabBarController release];
	[tabBarController release];
	[window release];
    [super dealloc];
}


@end
