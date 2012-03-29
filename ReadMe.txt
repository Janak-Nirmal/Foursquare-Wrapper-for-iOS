FoursquareWrapper is an easy to use wrapper around the Foursquare API that makes some of the more tedious aspects of communicating with Foursquare API easier. It is written in Objective-C and works in iOS applications.

You just need to import "FoursquareWrapper.h"

And write few lines

e.g. You want to get User's Detail who logged in write following 4 lines in your view controller. Thats it. 

	FoursquareWrapper *wrapper = [FoursquareWrapper sharedInstance];
	wrapper.apiCallDelegate = self;
	[wrapper initFoursquare];
	[wrapper getUserInfo];

Code is commented out perfectly please fill free to use. 

Initially code will throw errors. You need to provide 
1. YourClientID
2. CallBackURL
which you can get by registering at foursquare.com 