//
//  GuestViewController.h
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GuestViewController : UIViewController {

	NSString *guestId;
	IBOutlet UILabel *guestNameLabel;
	IBOutlet UILabel *tableNumberLabel;
	IBOutlet UILabel *emailAddressLabel;
	IBOutlet UILabel *phoneNumberLabel;
	IBOutlet UIButton *checkInButton;
}


@property (nonatomic, retain) NSString *guestId;
@property (nonatomic, retain) UILabel *guestNameLabel;
@property (nonatomic, retain) UILabel *tableNumberLabel;
@property (nonatomic, retain) UILabel *emailAddressLabel;
@property (nonatomic, retain) UILabel *phoneNumberLabel;
@property (nonatomic, retain) UIButton *checkInButton;

- (void) fetchGuestInfo;
- (IBAction) checkInGuest: (id) sender;

@end
