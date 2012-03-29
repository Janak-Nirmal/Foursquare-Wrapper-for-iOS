//
//  FoursquareWrapperViewController.h
//  FoursquareWrapper
//
//  Created by Jennis on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoursquareWrapper.h"

@interface FoursquareWrapperViewController : UIViewController <FSApiCallDelegate>
{

}

//User Aspect
-(IBAction)btnGetUserInfoTapped:(id)sender;
-(IBAction)btnGetCheckinsTapped:(id)sender;
-(IBAction)btnGetFriendsTapped:(id)sender;
-(IBAction)btnGetVenueHistoryTapped:(id)sender;

//Venue
-(IBAction)btnGetNearByPlacesTapped:(id)sender;
-(IBAction)btnAddPlaceTapped:(id)sender;

-(void)showAlert:(NSString*)pTitle withMessage:(NSString*)pMessage withDelegate:(id)pDelegate;

@end

