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
@synthesize cancelButton;
@synthesize responseData;
@synthesize baseURL;
@synthesize connectionToURL;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return NO;
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
	[cancelButton release];
	[responseData release];
	[baseURL release];
	[connectionToURL release];
    [super dealloc];
}


#pragma mark - 
#pragma mark Button functions


- (IBAction) login: (id) sender {
	
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	[serverAddrField resignFirstResponder];
	
	NSString *username = [usernameField text];
	NSString *password = [passwordField text];
	NSString *serverAddr = [serverAddrField text];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:kUsername];
	[defaults setObject:password forKey:kPassword];
	[defaults setObject:serverAddr forKey:kServerAddress];
	[defaults synchronize];
	
	[self disableUIControls];
	
	NSLog(@"Starting auth");
	NSString *apiURL = [CrowdSortAppDelegate genURLForAPI:kURLLogin];
	responseData = [[NSMutableData data] retain];
    baseURL = [[NSURL URLWithString:apiURL] retain];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
    connectionToURL = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}


- (IBAction) cancel: (id) sender {
	
	NSLog(@"Cancel button pressed");
	[connectionToURL cancel];
	[self reenableUIControls];
}


#pragma mark -
#pragma mark Callback / UI related functions


- (void) disableUIControls {
	
	loginIndicator.hidden = FALSE;
	[loginIndicator startAnimating];
	
	[cancelButton setHidden:FALSE];
	cancelButton.enabled = TRUE;
	
	loginButton.enabled = FALSE;
	usernameField.enabled = FALSE;
	passwordField.enabled = FALSE;
	serverAddrField.enabled = FALSE;
}

- (void) reenableUIControls {
	
	loginIndicator.hidden = TRUE;
	[loginIndicator stopAnimating];
	
	[cancelButton setHidden:TRUE];
	cancelButton.enabled = FALSE;
	
	loginButton.enabled = TRUE;
	usernameField.enabled = TRUE;
	passwordField.enabled = TRUE;
	serverAddrField.enabled = TRUE;
}


#pragma mark -
#pragma mark NSURLConnection callbacks


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Login error: %@", [error localizedDescription]);
	
	NSString *errorMsg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:errorMsg
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	[self reenableUIControls];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Having this method called means auth went through
	NSLog(@"connection: %@", connection);
	
	[self dismissModalViewControllerAnimated:YES];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
			 willSendRequest:(NSURLRequest *)request
			redirectResponse:(NSURLResponse *)redirectResponse
{
    [baseURL autorelease];
    baseURL = [[request URL] retain];
    return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"connection:didReceiveAuthenticationChallenge: %@", challenge);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults stringForKey:kUsername];
	NSString *password = [defaults stringForKey:kPassword];
	
	if ([challenge previousFailureCount] == 0)
	{
		[[challenge sender] useCredential:[NSURLCredential credentialWithUser:username
																	 password:password
																  persistence:NSURLCredentialPersistenceNone]
			   forAuthenticationChallenge:challenge];
	}
	else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];  
	}
	
	[self reenableUIControls];
}


@end
