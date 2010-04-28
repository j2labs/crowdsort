//
//  LoginViewController.h
//  CrowdSort
//
//  Created by jd on 4/13/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *serverAddrField;
	IBOutlet UIButton *loginButton;
	IBOutlet UIActivityIndicatorView *loginIndicator;
	IBOutlet UIButton *cancelButton;
	NSMutableData *responseData;
	NSURL *baseURL;
	NSURLConnection *connectionToURL;
}

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UITextField *serverAddrField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIActivityIndicatorView *loginIndicator;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSURLConnection *connectionToURL;

- (IBAction) login: (id) sender;
- (IBAction) cancel: (id) sender;
- (void) disableUIControls;
- (void) reenableUIControls;

@end
