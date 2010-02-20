//
//  CBTabBarController.h
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

@class MovableView;

@interface CBTabBarController : UIViewController {

	NSArray *viewControllers;
	
	MovableView *movableHUD;
	
	BOOL isAnimating;
}

@property (nonatomic, retain) NSArray *viewControllers;

- (id)initWithViewControllers:(NSArray *)viewControllerArray;

@end
