//
//  FoursquareWrapperViewController.m
//  FoursquareWrapper
//
//  Created by Jennis on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FoursquareWrapperViewController.h"

#define kSuccess @"Success"
#define kFailed @"Failed"

@implementation FoursquareWrapperViewController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Button tap events
#pragma mark -

#pragma mark Users Aspect

-(IBAction)btnGetUserInfoTapped:(id)sender
{
	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	[wrapper getUserInfo];
}

-(IBAction)btnGetCheckinsTapped:(id)sender
{
	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	[wrapper getCheckins];	
}

-(IBAction)btnGetFriendsTapped:(id)sender
{
	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	[wrapper getFriends];	
}

-(IBAction)btnGetVenueHistoryTapped:(id)sender
{
	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	[wrapper getVenueHistory];	
}

#pragma mark Venue

-(IBAction)btnGetNearByPlacesTapped:(id)sender
{
	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	wrapper.parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"23.012231,72.511569",@"ll",nil];
	[wrapper getNearByVenues];	
}

-(IBAction)btnAddPlaceTapped:(id)sender
{
	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	wrapper.parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"My Test Location", @"name", @"MyAddress of location", @"address", @"23.012231,72.511569",@"ll",@"4bf58dd8d48988d1d6941735",@"primaryCategoryId",nil];
	[wrapper addNewVenue];
}

#pragma mark -
#pragma mark Get user info delegate

-(void)finishUserInfoResponse:(id)result
{
	[self showAlert:kSuccess withMessage:@"Got user information." withDelegate:self];	
	NSLog(@"%@",result);
}

-(void)failedUserInfoResponse:(NSError *)error
{
	[self showAlert:kFailed withMessage:error.description withDelegate:self];	
}

#pragma mark -
#pragma mark Get Checkins

-(void)finishGetCheckinsResponse:(id)result
{
	[self showAlert:kSuccess withMessage:@"Got checkin information." withDelegate:self];	
	NSLog(@"%@",result);
}

-(void)failedGetCheckinsResponse:(NSError *)error
{
	[self showAlert:kFailed withMessage:error.description withDelegate:self];	
}

#pragma mark -
#pragma mark Get Venue history

-(void)finishGetVenueHistoryResponse:(id)result
{
	[self showAlert:kSuccess withMessage:@"Got venue history." withDelegate:self];	
	NSLog(@"%@",result);
}

-(void)failedGetVenueHistoryResponse:(NSError *)error
{
	[self showAlert:kFailed withMessage:error.description withDelegate:self];	
}

#pragma mark -
#pragma mark Get Checkins

-(void)finishGetFriendsResponse:(id)result
{
	[self showAlert:kSuccess withMessage:@"Got friends list." withDelegate:self];	
	NSLog(@"%@",result);
}

-(void)failedGetFriendsResponse:(NSError *)error
{
	[self showAlert:kFailed withMessage:error.description withDelegate:self];	
}

#pragma mark -
#pragma mark Get nearby place delegate

-(void)finishGettingNearbyPlaceResponse:(id)result
{
	[self showAlert:kSuccess withMessage:@"Got near by places" withDelegate:self];	
	NSLog(@"%@",result);
}

-(void)failedGettingNearbyPlaceResponse:(NSError *)error
{
	[self showAlert:kFailed withMessage:error.description withDelegate:self];
}

#pragma mark -
#pragma mark Add location

-(void)finishAddingPlaceResponse:(id)result
{
	[self showAlert:kSuccess withMessage:@"Place added." withDelegate:self];	
	NSLog(@"%@",result);	
}

-(void)failedAddingPlaceResponse:(NSError *)error
{
	[self showAlert:kFailed withMessage:error.description withDelegate:self];
}



-(void)showAlert:(NSString*)pTitle withMessage:(NSString*)pMessage withDelegate:(id)pDelegate
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pTitle message:pMessage delegate:pDelegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

@end
