//
//  CrowdSortAppDelegate.h
//  CrowdSort
//
//  Created by jd on 4/13/10.
//  Copyright J2 Labs LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class SearchableListViewController;

@interface CrowdSortAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	SearchableListViewController *searchableListViewController;
	LoginViewController *loginViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet SearchableListViewController *searchableListViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;

- (void)loginScreen:(UIViewController *)viewController;
- (void)initGuestList;
- (void)genUrlForAPI:(NSString *)apiKey;
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge vc:(UIViewController *)vc;
+ (NSObject *)runSynchronousQuery:(NSString *)queryUrl response:(NSURLResponse **)response error:(NSError **)error;

@end

