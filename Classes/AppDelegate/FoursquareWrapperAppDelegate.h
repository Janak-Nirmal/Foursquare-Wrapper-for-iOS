//
//  FoursquareWrapperAppDelegate.h
//  FoursquareWrapper
//
//  Created by Jennis on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoursquareWrapperViewController;

@interface FoursquareWrapperAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FoursquareWrapperViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FoursquareWrapperViewController *viewController;

@end

