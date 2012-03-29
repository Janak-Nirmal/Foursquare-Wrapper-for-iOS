//
//  FoursquareWrapper.h
//  FoursquareWrapper
//
//  Created by Jennis on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BZFoursquare.h"

#error Please enter your ClientID and CallBackURL here Register on foursquare.com
#error Also make one more change in plist file add your urlscheme handler.

#define kClientID       @"YourClientID"
#define kCallbackURL    @"YourAppURL://foursquare"
#define kSingleSignOn	1


@protocol FSApiCallDelegate;

typedef enum FSApiCallType
{
	FSApiCallNone = 0,
	FSApiCallGetUserInfo = 1,
	FSApiCallGetCheckIns = 2,
	FSApiCallGetFriends = 3,
	FSApiCallGetVenueHistory = 4,
	
	FSApiCallGetLocations = 5,
	FSApiCallAddLocation = 6
	
} FSApiCallType;

@interface FoursquareWrapper : NSObject <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>
{
    BZFoursquare        *foursquare_;
    BZFoursquareRequest *request_;

	id<FSApiCallDelegate> apiCallDelegate_;
	
	NSMutableDictionary *parameters_;
	FSApiCallType currentApiCallType;
}

@property (nonatomic,retain) BZFoursquare *foursquare;
@property (nonatomic,retain) BZFoursquareRequest *request;

@property (nonatomic,assign) FSApiCallType currentApiCallType;

@property (nonatomic,assign) NSMutableDictionary *parameters;
@property (nonatomic,retain) id<FSApiCallDelegate> apiCallDelegate;

+ (FoursquareWrapper *)sharedInstance;
- (void)initFoursquare;
- (NSString*)getAccessToken;

//After login redirect to appropriate request
-(void)checkCallForCurrentRequest;

//After request processing redirect to appropriate delegate
-(void)checkCallForSuccessResponse:(BZFoursquareRequest *)request;
-(void)checkCallForFailureResponse:(NSError *)error;

//Foursquare Methods

//Users - Aspects
-(void)getUserInfo; //Returns profile information for a given user
-(void)getCheckins; //Returns a history of checkins for the user. 
-(void)getFriends; //Returns an array of a user's friends. 
-(void)getVenueHistory; //Returns a list of all venues visited

//Venues
-(void)addNewVenue; //Allows users to add a new venue. 
-(void)getNearByVenues; //Returns a list of venues near the current location, optionally matching the search term. 

@end

@protocol FSApiCallDelegate <NSObject>

@optional

//Get User Info Delegate
-(void)finishUserInfoResponse:(id)result;
-(void)failedUserInfoResponse:(NSError *)error;

-(void)finishGetCheckinsResponse:(id)result;
-(void)failedGetCheckinsResponse:(NSError *)error;

-(void)finishGetFriendsResponse:(id)result;
-(void)failedGetFriendsResponse:(NSError *)error;

-(void)finishGetVenueHistoryResponse:(id)result;
-(void)failedGetVenueHistoryResponse:(NSError *)error;

//Get Nearby locations Delegate
-(void)finishGettingNearbyPlaceResponse:(id)result;
-(void)failedGettingNearbyPlaceResponse:(NSError *)error;

//Add new location Delegate
-(void)finishAddingPlaceResponse:(id)result;
-(void)failedAddingPlaceResponse:(NSError *)error;

@end