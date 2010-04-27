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
@synthesize searchableListViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// If username and password are saved, try logging in with them.
	
	[window addSubview:[tabBarController view]];

	[self loginScreen:tabBarController];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)loginScreen:(UIViewController *)viewController {
	LoginViewController *_loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:[NSBundle mainBundle]];
	self.loginViewController = _loginViewController;
	[_loginViewController release];
	[viewController presentModalViewController:self.loginViewController animated:YES];
}

- (void)initGuestList {
	NSLog(@"initGuestList got called");
	[searchableListViewController initGuestList];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


+ (NSDictionary *)runSynchronousQuery:(NSString *)queryUrl response:(NSURLResponse **)response error:(NSError **)error {
	int port = 8000;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *username = [defaults stringForKey:kUsername];
	NSString *password = [defaults stringForKey:kPassword];
	NSString *serverAddr = [defaults stringForKey:kServerAddress];
	NSString *urlString = [NSString stringWithFormat:@"http://%@:%@@%@:%d", username, password, serverAddr, port];
	if(queryUrl != nil) {
		urlString = [NSString stringWithFormat:@"%@%@", urlString, queryUrl];
	}
	NSLog(@"CrowdSortAppDelegate -- runSynchronousQuery:response:error: urlString :: %@", urlString);
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSArray *data = [parser objectWithString:jsonString error:nil];
	
	// Json strings from Django look like this:
	// [{"pk": 1, "model": "guestlist.guest", "fields": {"phone_number": "1231231234", "name": "Dennis, James"}}]
	NSDictionary *datum = [data objectAtIndex:0]; // {"pk": 1, "model": "guestlist.guest", "fields": {"phone_number": "1231231234", "name": "Dennis, James"}}
	NSDictionary *fields = [datum objectForKey:@"fields"]; // {"phone_number": "1231231234", "name": "Dennis, James"}
	
	return fields;
}


- (void)dealloc {
	[loginViewController release];
	[tabBarController release];
	[window release];
    [super dealloc];
}


@end
