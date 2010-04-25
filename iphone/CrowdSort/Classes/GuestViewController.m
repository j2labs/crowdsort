//
//  GuestViewController.m
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "CrowdSortAppDelegate.h"
#import "GuestViewController.h"
#import "JSON.h"
#import "AppConstants.h"


@implementation GuestViewController


@synthesize guestId;
@synthesize guestNameLabel;
@synthesize tableNumberLabel;
@synthesize emailAddressLabel;
@synthesize phoneNumberLabel;
@synthesize checkInButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	guestId = @"2";
	
	// fetch the guest info here
	NSDictionary *guestInfo = [self fetchGuestInfo];
	
	NSString *name = [guestInfo objectForKey:@"name"];
	NSString *table = [guestInfo objectForKey:@"table_name"];
	NSString *email = [guestInfo objectForKey:@"email"];
	NSString *phone = [guestInfo objectForKey:@"phone_number"];
	
	//Display the selected guest.
	[guestNameLabel setText:name];
	[tableNumberLabel setText:table];
	[emailAddressLabel setText:email];
	[phoneNumberLabel setText:phone];
	
	//Set the title of the navigation bar
	self.navigationItem.title = [guestNameLabel text];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[guestId release];
	[guestNameLabel release];
	[tableNumberLabel release];
	[emailAddressLabel release];
	[phoneNumberLabel release];
	[checkInButton release];
    [super dealloc];
}


- (NSDictionary*)fetchGuestInfo {
	NSString *url = [NSString stringWithFormat:@"%@%@/", kURLGuests, guestId];
	return [CrowdSortAppDelegate runSynchronousQuery:url];
}


- (IBAction)checkInGuest: (id) sender {
	NSString *url = [NSString stringWithFormat:@"%@%@/", kURLCheckin, guestId];
	[CrowdSortAppDelegate runSynchronousQuery:url];
}


@end
