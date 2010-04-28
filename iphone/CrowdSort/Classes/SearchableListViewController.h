//
//  SearchableListViewController.h
//  CrowdSort
//
//  Created by jd on 4/14/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController;

@interface SearchableListViewController : UITableViewController {
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	IBOutlet UISearchBar *searchBar;
	BOOL initialized;
	BOOL searching;
	BOOL letUserSelectRow;
	
	OverlayViewController *ovController;
}

- (void) initGuestList;
- (void) initializeView;
- (NSMutableArray *)nameListToGroups:(NSArray *)guestData;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
