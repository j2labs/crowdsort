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

- (IBAction) initNameList: (id) sender {
	NSLog(@"Click initNameList button");
	
	[((CrowdSortAppDelegate *)[[UIApplication sharedApplication] delegate]) initGuestList];
}

- (IBAction) logout: (id) sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:kUsername];
	[defaults removeObjectForKey:kPassword];
	[defaults removeObjectForKey:kServerAddress];
	[defaults synchronize];
	
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
