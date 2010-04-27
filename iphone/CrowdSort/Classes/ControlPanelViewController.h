//
//  ControlPanelViewController.h
//  CrowdSort
//
//  Created by jd on 4/22/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ControlPanelViewController : UIViewController {
	
	IBOutlet UIButton *initNameListButton;
	IBOutlet UIButton *logOutButton;
	IBOutlet UIActivityIndicatorView *initIndicator;
	IBOutlet UIActivityIndicatorView *logOutIndicator;
}

@property (nonatomic, retain) UIButton *initNameListButton;
@property (nonatomic, retain) UIButton *logOutButton;
@property (nonatomic, retain) UIActivityIndicatorView *initIndicator;
@property (nonatomic, retain) UIActivityIndicatorView *logOutIndicator;


- (IBAction) initNameList: (id) sender;
- (IBAction) logout: (id) sender;

@end
