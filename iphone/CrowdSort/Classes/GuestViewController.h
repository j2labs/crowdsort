//
//  GuestViewController.h
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GuestViewController : UIViewController {
	
	IBOutlet UILabel *lblText;
	NSString *selectedCountry;
	
}

@property (nonatomic, retain) NSString *selectedCountry;

@end
