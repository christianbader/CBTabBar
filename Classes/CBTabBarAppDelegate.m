//
//  CBTabBarAppDelegate.m
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright Christian Bader 2010. All rights reserved.
//

#import "CBTabBarAppDelegate.h"
#import "CBTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@implementation CBTabBarAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	FirstViewController *firstViewController = [[FirstViewController alloc] initWithNibName:nil bundle:nil];
	SecondViewController *secondViewController = [[SecondViewController alloc] initWithNibName:nil bundle:nil];
	ThirdViewController *thirdViewController = [[ThirdViewController alloc] initWithNibName:nil bundle:nil];
	
	NSArray *viewControllerArray = [NSArray arrayWithObjects:firstViewController, secondViewController, thirdViewController, nil];
	
	[firstViewController release];
	[secondViewController release];
	[thirdViewController release];
	
	tabBarController = [[CBTabBarController alloc] initWithViewControllers:viewControllerArray];
	
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end
