//
//  SearchableListController.m
//  CrowdSort
//
//  Created by jd on 4/14/10.
//  Copyright 2010 J2 Labs LLC. All rights reserved.
//

#import "CrowdSortAppDelegate.h"
#import "SearchableListViewController.h"
#import "OverlayViewController.h"
#import "GuestViewController.h"
#import "AppConstants.h"

@implementation SearchableListViewController


- (NSDictionary *)initializeGuestList {
	NSString *url = [NSString stringWithFormat:kURLNames];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSDictionary *fields = [CrowdSortAppDelegate runSynchronousQuery:url response:&response error:&error];
	return fields;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	//Initialize the array.
	listOfItems = [[NSMutableArray alloc] init];
	
	NSArray *notCheckedInArray = [NSArray arrayWithObjects:@"Dennis, James", @"J2 Labs", nil];
	NSDictionary *notCheckedInDict = [NSDictionary dictionaryWithObject:notCheckedInArray forKey:@"Not checked in"];
	
	NSArray *checkedInArray = [NSArray arrayWithObjects:@"Darabi, Soraya", @"Greenwood, Steve", nil];
	NSDictionary *checkedInDict = [NSDictionary dictionaryWithObject:checkedInArray forKey:@"Checked in"];
	
	NSDictionary *results = [self initializeGuestList];
	NSLog(@"Results: %@", results);
	
	[listOfItems addObject:notCheckedInDict];
	[listOfItems addObject:checkedInDict];
	
	//Initialize the copy array.
	copyListOfItems = [[NSMutableArray alloc] init];
	
	//Set the title
	self.navigationItem.title = @"CrowdSort";
	
	//Add the search bar
	self.tableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (NSArray *) sectionGroups {
	return [NSArray arrayWithObjects:@"Not checked in", @"Checked in",  nil];
}


- (NSString *)keyForSection:(NSInteger)section {
	NSArray *sections = [self sectionGroups];
	if(section == 0) {
		return [sections objectAtIndex:0];
	}
	else {
		return [sections objectAtIndex:1];
	}
}

#pragma mark -
#pragma mark Table view methods

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	/*if(searching)
		return nil;
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"Y"];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"Y"];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"Y"];
	[tempArray addObject:@"N"];
	[tempArray addObject:@"Y"];
	return tempArray;*/
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	/*if(searching)
		return -1;
	
	return index % 2;*/
	return -1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(searching)
		return 1;
	else
		return [listOfItems count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(searching)
		return [copyListOfItems count];
	else {
		NSDictionary *dictionary = [listOfItems objectAtIndex:section];
		NSString *key = [self keyForSection:section];
		NSArray *array = [dictionary objectForKey:key];
		return [array count];
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(searching)
		return @"Search Results";
	
	return [self keyForSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	if(searching)
		[[cell textLabel] setText:[copyListOfItems objectAtIndex:indexPath.row]];
	else {
		//First get the dictionary object
		NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		NSArray *array = [dictionary objectForKey:[self keyForSection:indexPath.section]];
		NSString *cellValue = [array objectAtIndex:indexPath.row];
		[[cell textLabel] setText:cellValue];
	}
	
#ifdef __IPHONE_3_0
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#endif
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//Get the selected country
	
	NSString *guestName = nil;
	
	if(searching)
		guestName = [copyListOfItems objectAtIndex:indexPath.row];
	else {
		
		NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		NSArray *array = [dictionary objectForKey:[self keyForSection:indexPath.section]];
		guestName = [array objectAtIndex:indexPath.row];
	}
	
	//Initialize the detail view controller and display it.
	GuestViewController *gvController = [[GuestViewController alloc] initWithNibName:@"GuestView" bundle:[NSBundle mainBundle]];
	[[gvController guestNameLabel] setText:guestName];
	[self.navigationController pushViewController:gvController animated:YES];
	[gvController release];
	gvController = nil;
}


- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Search Bar 


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	if(searching)
		return;
	
	// Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	// Parameters x = origin on x-axis, y = origin on y-axis
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.slvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	// Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	// Remove all objects first
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	[self searchTableView];
}


-(void) searchTableView {
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	NSArray *sections = [self sectionGroups];
	for(NSDictionary *dictionary in listOfItems) {
		for(NSString *key in sections) {
			NSArray *array = [dictionary objectForKey:key];
			[searchArray addObjectsFromArray:array];
		}
	}
	
	for(NSString *sTemp in searchArray) {
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if(titleResultsRange.length > 0) 
			[copyListOfItems addObject:sTemp];
	}
	
	[searchArray release];
	searchArray = nil;
}


- (void) doneSearching_Clicked:(id)sender {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
}


- (void)dealloc {
	[ovController release];
	[copyListOfItems release];
	[searchBar release];
	[listOfItems release];
    [super dealloc];
}


@end

