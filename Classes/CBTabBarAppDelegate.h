//
//  CBTabBarAppDelegate.h
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright Christian Bader 2010. All rights reserved.
//

@class CBTabBarController;

@interface CBTabBarAppDelegate : NSObject <UIApplicationDelegate> {
	
	CBTabBarController *tabBarController;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

