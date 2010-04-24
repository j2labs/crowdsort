//
//  GuestViewController.m
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "GuestViewController.h"
#import "JSON.h"


@implementation GuestViewController


@synthesize guestNameLabel;
@synthesize tableNumberLabel;
@synthesize emailAddressLabel;
@synthesize phoneNumberLabel;
@synthesize checkInButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// fetch the guest info here
	
	//Display the selected guest.
	[guestNameLabel setText:@"This is a potentially long name"];
	[tableNumberLabel setText:@"18"];
	[emailAddressLabel setText:@"jd@j2labs.net"];
	[phoneNumberLabel setText:@"212.272.3378"];
	
	//Set the title of the navigation bar
	self.navigationItem.title = [guestNameLabel text];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[guestNameLabel release];
	[tableNumberLabel release];
	[emailAddressLabel release];
	[phoneNumberLabel release];
	[checkInButton release];
    [super dealloc];
}



- (void) fetchGuestInfo {
	
	NSLog(@"Fetch guest info pressed");
}

- (IBAction) checkInGuest: (id) sender {
	
	NSLog(@"Checkin button pressed");
}


@end
