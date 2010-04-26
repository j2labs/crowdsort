//
//  CrowdSortAppDelegate.h
//  CrowdSort
//
//  Created by jd on 4/13/10.
//  Copyright J2 Labs LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface CrowdSortAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	LoginViewController *loginViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) LoginViewController *loginViewController;

@end

