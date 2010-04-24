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
	IBOutlet UIButton *setCrowdSlideButton;
	IBOutlet UIButton *logOutButton;
}

@property (nonatomic, retain) UIButton *initNameListButton;
@property (nonatomic, retain) UIButton *setCrowdSlideButton;
@property (nonatomic, retain) UIButton *logOutButton;

- (IBAction) initNameList: (id) sender;
- (IBAction) setCrowdSlide: (id) sender;
- (IBAction) logout: (id) sender;

@end
