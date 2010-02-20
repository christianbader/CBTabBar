//
//  CBTabBarController.m
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import "CBTabBarController.h"
#import "MovableView.h"
#import "HUDView.h"

#define kSpacing 10.0

@interface CBTabBarController (PrivateMethods)

- (void)createButtonsForControllers;
- (void)animateHUD;
- (void)pushViewController:(id)sender;

@end

@implementation CBTabBarController

@synthesize viewControllers;

- (id)initWithViewControllers:(NSArray *)viewControllerArray
{
	if (self = [super initWithNibName:nil bundle:nil]){
		
		movableHUD = [[MovableView alloc] initWithFrame:self.view.bounds];
		
		movableHUD.interfaceOrientation = self.interfaceOrientation;
		
		movableHUD.alpha = 0.0;
				
		self.viewControllers = viewControllerArray;
		
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		self.view.autoresizesSubviews = YES;
	}
	
	return self;
}

- (void)dealloc {
	
	[movableHUD release];
	
	[viewControllers release];
	
    [super dealloc];
}

- (void)setViewControllers:(NSArray *)newValue
{
	if (viewControllers != newValue) {
		[viewControllers release];
		viewControllers = newValue;
		[newValue retain];
	}
	
	[self createButtonsForControllers];
	
	[self pushViewController:nil];
}

- (void)createButtonsForControllers
{
	int row = 1;
	int col = 1;
	int maxW = 0;
	int i = 0;
	
	float buttonSize = 66.0;
	
	for (UIViewController *controller in viewControllers) {
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.tag = i;
		[button addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
		
		if (row * (kSpacing + buttonSize) + kSpacing < 320.0) {
			
			button.frame = CGRectMake((row -1) * (kSpacing + buttonSize) + kSpacing, (col -1) * (kSpacing + buttonSize) + kSpacing, buttonSize, buttonSize);
			row++;
			
		} else {
			
			maxW = row - 1;
			col++;
			row = 1;

			button.frame = CGRectMake((row -1) * (kSpacing + buttonSize) + kSpacing, (col -1) * (kSpacing + buttonSize) + kSpacing, buttonSize, buttonSize);
		}
		
		[movableHUD.aHUDFrontView addSubview:button];

		i++;
	}
	
	if (maxW == 0) {
		maxW = row - 1;
	}
	
	[movableHUD.aHUDFrontView setFrame:CGRectMake(movableHUD.aHUDFrontView.frame.origin.x, movableHUD.aHUDFrontView.frame.origin.y, (maxW * (kSpacing + buttonSize)) + kSpacing, (col * (kSpacing + buttonSize)) + 3* kSpacing)];
	
	UIButton *prefButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	prefButton.frame = CGRectMake(movableHUD.aHUDFrontView.frame.size.width - 25.0, movableHUD.aHUDFrontView.frame.size.height - 25.0, 20.0, 20.0);
	[prefButton addTarget:movableHUD action:@selector(flipHUD) forControlEvents:UIControlEventTouchUpInside];
	[movableHUD.aHUDFrontView addSubview:prefButton];	
}

- (void)pushViewController:(id)sender
{	
	int senderTag = [sender tag];
	
	if (sender == nil) {
		senderTag = 0;
	} else {
		[self animateHUD];
	}
	
	[[viewControllers objectAtIndex:[sender tag]] view].frame = self.view.bounds;
	
	[[viewControllers objectAtIndex:senderTag] viewWillAppear:NO];
		
	[self.view addSubview:[[viewControllers objectAtIndex:senderTag] view]];
	
	[[viewControllers objectAtIndex:senderTag] viewDidAppear:NO];
	
	[self.view bringSubviewToFront:movableHUD];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation == UIInterfaceOrientationPortrait | 
									UIInterfaceOrientationLandscapeLeft | 
									UIInterfaceOrientationLandscapeRight);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{	
	[movableHUD setInterfaceOrientation:interfaceOrientation];
	
	for (UIViewController *controller in viewControllers) {
		if ([controller isKindOfClass:[UINavigationController class]]){
			if (interfaceOrientation == UIInterfaceOrientationPortrait) {
				[[(UINavigationController *)controller navigationBar] setFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
			} else {
				[[(UINavigationController *)controller navigationBar] setFrame:CGRectMake(0.0, 0.0, 480.0, 32.0)];
			}
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder 
{    
    return YES; 
} 

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (event.subtype == UIEventSubtypeMotionShake && !isAnimating) {
		
		[self animateHUD];
	}
}

- (void)animateHUD
{
	isAnimating = YES;
	
	movableHUD.frame = self.view.bounds;
	
	[self.view addSubview:movableHUD];
	
	if (movableHUD.alpha == 0.0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop)];
		movableHUD.alpha = 1.0;
		[UIView commitAnimations];
	} else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop)];
		movableHUD.alpha = 0.0;
		[UIView commitAnimations];
	}
}

- (void)showAnimationDidStop
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	movableHUD.aHUDFrontView.alpha = 1.0;
	[UIView commitAnimations];
	
	isAnimating = NO;
}
- (void)hideAnimationDidStop
{ 
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	movableHUD.aHUDFrontView.alpha = 0.0;
	[UIView commitAnimations];
	
	[movableHUD removeFromSuperview];
	isAnimating = NO;	
}

@end
