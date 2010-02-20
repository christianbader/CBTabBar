//
//  MovableView.m
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import "MovableView.h"
#import "HUDView.h"
#import "HUDBackView.h"
#import <QuartzCore/QuartzCore.h>

@interface MovableView (PrivateMethods)

- (void)setUpHUDView;
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint;
- (void)getHUDPosition;
- (void)positionsToUserDefaults;

@end

@implementation MovableView

@synthesize aHUDFrontView;
@synthesize aHUDBackView;
@synthesize centerSwitch;
@synthesize interfaceOrientation;


#pragma mark -
#pragma mark initialization and destruction

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setUpHUDView];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
    return self;
}

- (void)dealloc {
	[centerSwitch release];
	[aHUDBackView release];
	[aHUDFrontView release];
	[super dealloc];	
}

- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat locations[] = { 0.0, 1.0 };
	const CGFloat colors[] = {
	                0.0, 0.0, 0.0, 0.1,
	                1.0, 1.0, 1.0, 0.0
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
	   
	CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	CGContextDrawRadialGradient(context, gradient, center, 0.0f, center, 250.0f, kCGGradientDrawsBeforeStartLocation);
	     
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

- (void)setUpHUDView
{
	//The initial setup of the HUD view
	HUDView *tmpHUDView = [[HUDView alloc] init];
	self.aHUDFrontView = tmpHUDView;
	[tmpHUDView release];
	
	aHUDFrontView.center = self.center;
	aHUDFrontView.alpha = 0;

	[self getHUDPosition];

	[self addSubview:aHUDFrontView];	
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)anInterfaceOrientation
{
	interfaceOrientation = anInterfaceOrientation;
	
	[self getHUDPosition];
}

- (void)getHUDPosition
{
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HUDXValuePortrait"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"HUDYValuePortrait"]){
			NSNumber *x = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUDXValuePortrait"];
			NSNumber *y = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUDYValuePortrait"];
			
			CGRect rect = CGRectMake([x floatValue], [y floatValue], aHUDFrontView.frame.size.width, aHUDFrontView.frame.size.height);
			aHUDFrontView.frame = rect;
		} else {
			[self centerViewAnimated:NO];
		}
	} else {
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HUDXValueLandscape"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"HUDYValueLandscape"]){
			NSNumber *x = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUDXValueLandscape"];
			NSNumber *y = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUDYValueLandscape"];
			
			CGRect rect = CGRectMake([x floatValue], [y floatValue], aHUDFrontView.frame.size.width, aHUDFrontView.frame.size.height);
			aHUDFrontView.frame = rect;
		} else {
			[self centerViewAnimated:NO];
		}
	}
}

- (void)flipHUD
{
	//If the HUDBackView is nil create one
	if (aHUDBackView == nil) {
		
		HUDBackView *tmpHUDView = [[HUDBackView alloc] initWithFrame:aHUDFrontView.bounds];
		self.aHUDBackView = tmpHUDView;
		[tmpHUDView release];
		
		//Create the buttons and the labels
		UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, aHUDBackView.frame.size.width - 20.0, 24.0)];
		centerLabel.backgroundColor = [UIColor clearColor];
		centerLabel.text = @"Center View";
		[aHUDBackView addSubview:centerLabel];
		[centerLabel release];
		
		UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, aHUDBackView.frame.size.height - 24.0, aHUDBackView.frame.size.width - 20.0, 24.0)];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.textColor = [UIColor lightGrayColor];
		infoLabel.text = @"Double tap when finished";
		[aHUDBackView addSubview:infoLabel];
		[infoLabel release];
		
		self.centerSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(aHUDBackView.frame.size.width - 94.0 - 10.0, 10.0, 94.0, 24.0)] autorelease];

		[aHUDBackView addSubview:centerSwitch];
	} 
	
	//If the topmost view is the back view then remove it
	if ([[self.aHUDFrontView.subviews objectAtIndex:[self.aHUDFrontView.subviews count] -1] isKindOfClass:[HUDBackView class]]) {
		
		aHUDFrontView.transform = CGAffineTransformMakeScale(1, 1);

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(flipAnimationDidStop)];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
							   forView:aHUDFrontView
								 cache:YES];
		[aHUDBackView removeFromSuperview];
		[UIView commitAnimations];
				
	//Else add it	
	} else {
		aHUDFrontView.transform = CGAffineTransformMakeScale(-1, 1);
		aHUDBackView.transform = CGAffineTransformMakeScale(-1, 1);

		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
							   forView:aHUDFrontView
								 cache:YES];
		[aHUDFrontView addSubview:aHUDBackView];
		[UIView commitAnimations];
	}
}

- (void)flipAnimationDidStop
{		
	if (centerSwitch.on) {
		[self centerViewAnimated:YES];
		centerSwitch.on = NO;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == aHUDBackView) {
		if ([touch tapCount] == 2) {
			[self flipHUD];
		}
		return;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, move the placardView to its location
	if ([touch view] == aHUDFrontView || [touch view] == aHUDBackView) {
		CGPoint location = [touch locationInView:self];
		aHUDFrontView.center = location;		
		
		return;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == aHUDFrontView || [touch view] == aHUDBackView) {

		[self positionsToUserDefaults];
		
		return;
	}
}

- (void)centerViewAnimated:(BOOL)animated {
	
	// Bounces the placard back to the center
	
	CALayer *welcomeLayer = aHUDFrontView.layer;
	
	// Create a keyframe animation to follow a path back to the center
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.removedOnCompletion = NO;
	
	if (animated) {
		
		CGFloat animationDuration = 1.5;
		
		
		// Create the path for the bounces
		CGMutablePathRef thePath = CGPathCreateMutable();
		
		CGFloat midX = self.center.x;
		CGFloat midY = self.center.y;
		CGFloat originalOffsetX = aHUDFrontView.center.x - midX;
		CGFloat originalOffsetY = aHUDFrontView.center.y - midY;
		CGFloat offsetDivider = 4.0;
		
		BOOL stopBouncing = NO;
		
		// Start the path at the placard's current location
		CGPathMoveToPoint(thePath, NULL, aHUDFrontView.center.x, aHUDFrontView.center.y);
		CGPathAddLineToPoint(thePath, NULL, midX, midY);
		
		// Add to the bounce path in decreasing excursions from the center
		while (stopBouncing != YES) {
			CGPathAddLineToPoint(thePath, NULL, midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
			CGPathAddLineToPoint(thePath, NULL, midX, midY);
			
			offsetDivider += 4;
			animationDuration += 1/offsetDivider;
			if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
				stopBouncing = YES;
			}
		}
		
		bounceAnimation.path = thePath;
		bounceAnimation.duration = animationDuration;
		CGPathRelease(thePath);
		
		// Create a basic animation to restore the size of the placard
		CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
		transformAnimation.removedOnCompletion = YES;
		transformAnimation.duration = animationDuration;
		transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
		
		
		// Create an animation group to combine the keyframe and basic animations
		CAAnimationGroup *theGroup = [CAAnimationGroup animation];
		
		// Set self as the delegate to allow for a callback to reenable user interaction
		theGroup.delegate = self;
		theGroup.duration = animationDuration;
		theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		
		theGroup.animations = [NSArray arrayWithObjects:bounceAnimation, transformAnimation, nil];
		
		
		// Add the animation group to the layer
		[welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
	}
	
	// Set the placard view's center and transformation to the original values in preparation for the end of the animation
	aHUDFrontView.center = self.center;
	aHUDFrontView.transform = CGAffineTransformIdentity;
	
}

- (void)positionsToUserDefaults
{
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aHUDFrontView.frame.origin.x] forKey:@"HUDXValuePortrait"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aHUDFrontView.frame.origin.y] forKey:@"HUDYValuePortrait"];
	} else {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aHUDFrontView.frame.origin.x] forKey:@"HUDXValueLandscape"];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aHUDFrontView.frame.origin.y] forKey:@"HUDYValueLandscape"];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {

	aHUDFrontView.transform = CGAffineTransformIdentity;
	
	[self positionsToUserDefaults];
}

@end
