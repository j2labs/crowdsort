//
//  LoginViewController.m
//  CrowdSort
//
//  Created by jd on 4/13/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "CrowdSortAppDelegate.h"
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
	
	NSLog(@"Starting auth");
	authenticated = [self checkLoginOnServer:serverAddr withUsername:username withPassword:password];
	
	NSLog(@"Completed auth");
	
	if(authenticated) {
		// yay
		NSLog(@"Authenticated: YES");
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		// boo!
		NSLog(@"Authentication failed");
		loginIndicator.hidden = TRUE;
		[loginIndicator stopAnimating];
		loginButton.enabled = TRUE;
	}
}


- (BOOL)checkLoginOnServer:(NSString *)serverAddr withUsername:(NSString *)username withPassword:(NSString *)password {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:kUsername];
	[defaults setObject:password forKey:kPassword];
	[defaults setObject:serverAddr forKey:kServerAddress];
	[defaults synchronize];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSDictionary *fields = [CrowdSortAppDelegate runSynchronousQuery:kURLLogin response:&response error:&error];
	NSLog(@"error: %@", error);
	if(error) {
		NSString *errorMsg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:errorMsg
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return NO;
	}
	NSString *responseUrl = [[response URL] absoluteString];
	NSLog(@"responseUrl: %@", responseUrl);
	if(responseUrl == nil) {
		NSString *errorMsg = [NSString stringWithFormat:@"Error: incorrect username and password"];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
															message:errorMsg
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return NO;
	}
	
	NSLog(@"checkLoginOnServer:withUsername:withPassword: %@", fields);
	if(fields) {
		return YES;
	}
	else {
		return NO;
	}
}


@end
