//
//  ControlPanelViewController.m
//  CrowdSort
//
//  Created by jd on 4/22/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "ControlPanelViewController.h"
#import "AppConstants.h"
#import "CrowdSortAppDelegate.h"


@implementation ControlPanelViewController

@synthesize initNameListButton;
@synthesize logOutButton;
@synthesize initIndicator;
@synthesize logOutIndicator;

- (IBAction) initNameList: (id) sender {
	
	initIndicator.hidden = FALSE;
	[initIndicator startAnimating];
	
	[self performSelectorOnMainThread:@selector(callInitGuestList) withObject:nil waitUntilDone:NO];

	initIndicator.hidden = TRUE;
	[initIndicator stopAnimating];
}


- (void) callInitGuestList {
	[((CrowdSortAppDelegate *)[[UIApplication sharedApplication] delegate]) initGuestList];
}


- (IBAction) logout: (id) sender {
  
	logOutIndicator.hidden = FALSE;
	[logOutIndicator startAnimating];
	
	NSString *url = [NSString stringWithFormat:@"%@", kURLLogout];
	NSURLResponse *response = nil;
	NSError *error = nil;

	[CrowdSortAppDelegate runSynchronousQuery:url response:&response error:&error];
  
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *serverAddr = [defaults stringForKey:kServerAddress];
	
	// first, clear any cookies
	NSLog(@"Clearing cookies");
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", serverAddr]]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
		NSLog(@"Cookie: %@", cookie);
    }
	NSLog(@"Done clearing cookies");
	
	[defaults removeObjectForKey:kUsername];
	[defaults removeObjectForKey:kPassword];
	[defaults removeObjectForKey:kServerAddress];
	[defaults synchronize];
	
	logOutIndicator.hidden = TRUE;
	[logOutIndicator stopAnimating];
	
	[(CrowdSortAppDelegate *)[[UIApplication sharedApplication] delegate] loginScreen:self];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
