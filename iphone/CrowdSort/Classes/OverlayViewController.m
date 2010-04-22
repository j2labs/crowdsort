//
//  OverlayViewController.m
//  CrowdSort
//
//  Created by jd on 4/15/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "OverlayViewController.h"
#import "SearchableListViewController.h"


@implementation OverlayViewController

@synthesize slvController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[slvController doneSearching_Clicked:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[slvController release];
    [super dealloc];
}


@end
