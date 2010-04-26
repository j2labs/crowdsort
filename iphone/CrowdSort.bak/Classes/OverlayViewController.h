//
//  OverlayView.h
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchableListViewController;

@interface OverlayViewController : UIViewController {
	SearchableListViewController *slvController;
}

@property (nonatomic, retain) SearchableListViewController *slvController;

@end
