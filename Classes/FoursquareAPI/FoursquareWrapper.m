//
//  FoursquareWrapper.m
//  FoursquareWrapper
//
//  Created by Jennis on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FoursquareWrapper.h"


@implementation FoursquareWrapper

@synthesize foursquare = foursquare_;
@synthesize request = request_;

@synthesize apiCallDelegate = apiCallDelegate_;
@synthesize parameters = parameters_;

@synthesize currentApiCallType;

static FoursquareWrapper *singletonManager = nil;

#pragma mark -
#pragma mark Singleton Instance for wrapper

+ (FoursquareWrapper *)sharedInstance 
{
	@synchronized(self) 
	{
		if (singletonManager == nil) 
			[[FoursquareWrapper alloc] init]; // assignment not done here
	}
	return singletonManager;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (singletonManager == nil) 
		{
			singletonManager = [super allocWithZone:zone];
			return singletonManager;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}
- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX;  // denotes an object that cannot be released
}

#pragma mark -
#pragma mark Memory Management

- (void)cancelRequest 
{
    if (request_) 
	{
        request_.delegate = nil;
        [request_ cancel];
        self.request = nil;
    }
}

-(void)dealloc
{
	[self cancelRequest];
	
	foursquare_.sessionDelegate = nil;
	[foursquare_ release];
	
	[parameters_ release];	
	
	[super dealloc];
}

#pragma mark -
#pragma mark Foursquare Initialization

-(void)initFoursquare
{
	if(!self.foursquare) //If null initalize 
	{
		self.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
		foursquare_.version = @"20111119";
		foursquare_.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
		foursquare_.sessionDelegate = self;
		
		NSString *tmpToken = [self getAccessToken];
		if(tmpToken)
			foursquare_.accessToken = tmpToken;
	}
}

-(NSString*)getAccessToken
{
	NSString *strToken = nil;
	NSUserDefaults *defaultsCenter = [NSUserDefaults standardUserDefaults];
	if([defaultsCenter objectForKey:@"accesstoken"]!=nil)
		strToken = [defaultsCenter objectForKey:@"accesstoken"];
	return strToken;
}

-(BOOL)isLoggedIn
{
	return [foursquare_ isSessionValid];
}

#pragma mark -
#pragma mark Foursquare Login Delegates

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare 
{
    NSLog(@"Accesstoken->%@",[foursquare accessToken]);
    
	if(kSingleSignOn)
	{
		NSUserDefaults *defaultsCenter = [NSUserDefaults standardUserDefaults];
		[defaultsCenter setObject:[foursquare accessToken] forKey:@"accesstoken"];
		[defaultsCenter synchronize];
	}
	
	//Login Success redirect to appropriate request
	[self checkCallForCurrentRequest];
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo 
{	
	NSError *error = [NSError errorWithDomain:@"FoursquareAuthorization" code:1 userInfo:errorInfo];
	[self checkCallForFailureResponse:error];
}

#pragma mark -
#pragma mark Foursquare request delegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request 
{
	[self checkCallForSuccessResponse:request];
    self.request = nil;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error 
{
	NSLog(@"Failed");
	[self checkCallForFailureResponse:error];
    self.request = nil;
}

#pragma mark -
#pragma mark Foursquare Operations - User Aspects

//Returns profile information for a given user
-(void)getUserInfo
{
	currentApiCallType = FSApiCallGetUserInfo;
	if(![self isLoggedIn])
		[foursquare_ startAuthorization];
	else
	{
		[self cancelRequest];
		self.request = [foursquare_ requestWithPath:@"users/self" HTTPMethod:@"GET" parameters:nil delegate:self];
		[request_ start];		
	}	
}

//Returns a history of checkins for the user. 
-(void)getCheckins
{
	currentApiCallType = FSApiCallGetCheckIns;
	if(![self isLoggedIn])
		[foursquare_ startAuthorization];
	else
	{
		[self cancelRequest];
		self.request = [foursquare_ requestWithPath:@"users/self/checkins" HTTPMethod:@"GET" parameters:nil delegate:self];
		[request_ start];		
	}	
}

//Returns an array of a user's friends. 
-(void)getFriends
{
	currentApiCallType = FSApiCallGetFriends;
	if(![self isLoggedIn])
		[foursquare_ startAuthorization];
	else
	{
		[self cancelRequest];
		self.request = [foursquare_ requestWithPath:@"users/self/friends" HTTPMethod:@"GET" parameters:nil delegate:self];
		[request_ start];		
	}
}

//Returns a list of all venues visited
-(void)getVenueHistory
{
	currentApiCallType = FSApiCallGetVenueHistory;
	if(![self isLoggedIn])
		[foursquare_ startAuthorization];
	else
	{
		[self cancelRequest];
		self.request = [foursquare_ requestWithPath:@"users/self/venuehistory" HTTPMethod:@"GET" parameters:nil delegate:self];
		[request_ start];		
	}	
}

#pragma mark -
#pragma mark Foursquare Operations -  Venues 

//Allows users to add a new venue. 
-(void)addNewVenue
{
	currentApiCallType = FSApiCallAddLocation;
	if(![self isLoggedIn])
		[foursquare_ startAuthorization];
	else
	{
		[self cancelRequest];
		self.request = [foursquare_ requestWithPath:@"venues/add" HTTPMethod:@"POST" parameters:parameters_ delegate:self];
		[request_ start];		
	}
}

//Returns a list of venues near the current location, optionally matching the search term.
-(void)getNearByVenues
{
	currentApiCallType = FSApiCallGetLocations;

	if(![self isLoggedIn])
		[foursquare_ startAuthorization];
	else
	{
		[self cancelRequest];
		self.request = [foursquare_ requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters_ delegate:self];
		[request_ start];
	}
}

#pragma mark -
#pragma mark Redirection after processing login or request

-(void)checkCallForCurrentRequest
{
	switch(currentApiCallType)
	{
		case FSApiCallNone:
			break;
			
		case FSApiCallGetUserInfo:
			[self getUserInfo];
			break;			
		case FSApiCallGetCheckIns:
			[self getCheckins];
			break;			
		case FSApiCallGetFriends:
			[self getFriends];
			break;			
		case FSApiCallGetVenueHistory:
			[self getVenueHistory];
			break;			
			
		case FSApiCallGetLocations:
			[self getNearByVenues];
			break;
		case FSApiCallAddLocation:
			[self addNewVenue];
			break;
			
		default:
			break;
	}
}

-(void)checkCallForSuccessResponse:(BZFoursquareRequest *)request 
{
	switch(currentApiCallType)
	{
		case FSApiCallNone:
			break;
			
		case FSApiCallGetUserInfo:
			if([self.apiCallDelegate respondsToSelector:@selector(finishUserInfoResponse:)])
				[self.apiCallDelegate finishUserInfoResponse:request.response];
			break;
		case FSApiCallGetCheckIns:
			if([self.apiCallDelegate respondsToSelector:@selector(finishGetCheckinsResponse:)])
				[self.apiCallDelegate finishGetCheckinsResponse:request.response];
			break;
		case FSApiCallGetFriends:
			if([self.apiCallDelegate respondsToSelector:@selector(finishGetFriendsResponse:)])
				[self.apiCallDelegate finishGetFriendsResponse:request.response];
			break;
		case FSApiCallGetVenueHistory:
			if([self.apiCallDelegate respondsToSelector:@selector(finishGetVenueHistoryResponse:)])
				[self.apiCallDelegate finishGetVenueHistoryResponse:request.response];
			break;
			
		case FSApiCallGetLocations:
			if([self.apiCallDelegate respondsToSelector:@selector(finishGettingNearbyPlaceResponse:)])
				[self.apiCallDelegate finishGettingNearbyPlaceResponse:request.response];
			break;
		case FSApiCallAddLocation:
			if([self.apiCallDelegate respondsToSelector:@selector(finishAddingPlaceResponse:)])
				[self.apiCallDelegate finishAddingPlaceResponse:request.response];
			break;
			
		default:
			break;
	}
}

-(void)checkCallForFailureResponse:(NSError *)error
{
	switch(currentApiCallType)
	{
		case FSApiCallNone:
			break;
			
		case FSApiCallGetUserInfo:
			if([self.apiCallDelegate respondsToSelector:@selector(failedUserInfoResponse:)])
				[self.apiCallDelegate failedUserInfoResponse:error];
			break;
		case FSApiCallGetCheckIns:
			if([self.apiCallDelegate respondsToSelector:@selector(failedGetCheckinsResponse:)])
				[self.apiCallDelegate finishGetCheckinsResponse:error];
			break;
		case FSApiCallGetFriends:
			if([self.apiCallDelegate respondsToSelector:@selector(failedGetFriendsResponse:)])
				[self.apiCallDelegate finishGetFriendsResponse:error];
			break;
		case FSApiCallGetVenueHistory:
			if([self.apiCallDelegate respondsToSelector:@selector(failedGetVenueHistoryResponse:)])
				[self.apiCallDelegate finishGetVenueHistoryResponse:error];
			break;			
			
		case FSApiCallGetLocations:
			if([self.apiCallDelegate respondsToSelector:@selector(failedGettingNearbyPlaceResponse:)])
				[self.apiCallDelegate failedGettingNearbyPlaceResponse:error];
			break;
		case FSApiCallAddLocation:
			if([self.apiCallDelegate respondsToSelector:@selector(failedAddingPlaceResponse:)])
				[self.apiCallDelegate failedAddingPlaceResponse:error];
			break;
			
		default:
			break;
	}	
}

@end
