//
//  GuestViewController.m
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

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
	guestId = @"1";
	
	// fetch the guest info here
	[self fetchGuestInfo];
	NSLog(@"fetching guest data");
	
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
	[guestId release];
	[guestNameLabel release];
	[tableNumberLabel release];
	[emailAddressLabel release];
	[phoneNumberLabel release];
	[checkInButton release];
    [super dealloc];
}


- (void) runQuery:(NSString*) queryUrl {
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
	NSArray *statuses = [parser objectWithString:jsonString error:nil];
	for (NSDictionary *status in statuses) {
		NSLog(@"Status: %@", status);
		NSDictionary *fields = [status objectForKey:@"fields"];
		NSLog(@"Fields: %@", fields);
		NSString *email = [fields objectForKey:@"email"];
		NSLog(@"Email: %@", email);
	}
	
	//NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
	//											  cachePolicy:NSURLRequestUseProtocolCachePolicy
	//										  timeoutInterval:30.0];
		
	// create the connection with the request
	// and start loading the data
	//[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}	

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"connection:didReceiveAuthenticationChallenge:");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults stringForKey:kUsername];
	NSString *password = [defaults stringForKey:kPassword];
			
	NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
	NSLog(@"connection:didReceiveAuthenticationChallenge: protectionSpace: authenticationMethod = %@, host = %@, port = %d, protocol = %@, isProxy = %d, proxyType = %@, realm = %@, receivesCredentialSecurely = %d", [protectionSpace authenticationMethod], [protectionSpace host], [protectionSpace port], [protectionSpace protocol], [protectionSpace isProxy], [protectionSpace proxyType], [protectionSpace realm], [protectionSpace receivesCredentialSecurely]);
		
	NSURLCredential *urlCredential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceForSession];
	[[challenge sender] useCredential:urlCredential forAuthenticationChallenge:challenge];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"connection:didReceiveResponse:");
	
	if ([response respondsToSelector:@selector(statusCode)]) {
		int statusCode = [(NSHTTPURLResponse *)response statusCode];
		// ignore anything that doesn't come back as 200 (OK) -- mainly a 304 (Not Modified) or 400 (Bad Request = Rate limit exceeded)
		NSLog(@"IFTwitterConnection: connection:didReceiveResponse: statusCode = %d", statusCode);
		
		//statusCode = 400;
		
		if (statusCode == 200) {
			NSLog(@"IFTwitterConnection: connection:didReceiveResponse: response MIMEType = %@", [response MIMEType]);
			
			//if (! [[response MIMEType] isEqualToString:@"application/xml"]) {
			//	[self _setErrorType:@"FailedRetrievalInvalidMIMEType"];	
			//}
			//else {
			NSLog(@"MIMEType: %@", [response MIMEType]);
			//}
		}
		else {
			NSDictionary *userInfo = [NSDictionary
									  dictionaryWithObject:[NSString stringWithFormat:@"HTTP %d response", statusCode]
													forKey:NSLocalizedDescriptionKey];
			[NSError errorWithDomain:@"HTTPErrorDomain" code:statusCode userInfo:userInfo];
			
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
	NSLog(@"connection:didReceiveData: data = %@", jsonString);
	

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connectionDidFinishLoading");
}


- (void)fetchGuestInfo {
	NSString *url = [NSString stringWithFormat:@"%@%@/", kURLGuests, guestId];
	return [self runQuery:url];
}

- (IBAction)checkInGuest: (id) sender {
	NSString *url = [NSString stringWithFormat:@"%@%@/", kURLCheckin, guestId];
	[self runQuery:url];
}


@end
