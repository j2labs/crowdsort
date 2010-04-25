//
//  LoginViewController.m
//  CrowdSort
//
//  Created by jd on 4/13/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "AppConstants.h"

@implementation LoginViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize serverAddrField;
@synthesize loginButton;
@synthesize loginIndicator;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[usernameField release];
	[passwordField release];
	[serverAddrField release];
	[loginButton release];
	[loginIndicator release];
    [super dealloc];
}


- (IBAction) login: (id) sender {
	BOOL authenticated = NO;
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	[serverAddrField resignFirstResponder];
	
	NSString *username = [usernameField text];
	NSString *password = [passwordField text];
	NSString *serverAddr = [serverAddrField text];
	
	loginIndicator.hidden = FALSE;
	[loginIndicator startAnimating];
	loginButton.enabled = FALSE;
	
	// TODO: Replace with real auth system
	NSLog(@"Server addr %s", [serverAddr UTF8String]);
	if([username isEqual:@"jd"] && [password isEqual:@"f00"]) {
		authenticated = YES;
	}
	
	if(authenticated) {
		// yay
		NSLog(@"Authenticated: YES");
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:username forKey:kUsername];
		[defaults setObject:password forKey:kPassword];
		[defaults setObject:serverAddr forKey:kServerAddress];
		[defaults synchronize];
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		// boo!
		NSLog(@"Authentication failed");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" 
														message:@"Login failed"
													   delegate:self 
											  cancelButtonTitle:@"Cancel" 
											  otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		loginIndicator.hidden = TRUE;
		[loginIndicator stopAnimating];
		loginButton.enabled = TRUE;
	}
}

@end
