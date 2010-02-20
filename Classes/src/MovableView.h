//
//  MovableView.h
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HUDView;
@class HUDBackView;

@interface MovableView : UIView {
	
	HUDView *aHUDFrontView;
	HUDBackView *aHUDBackView;
	
	UISwitch *centerSwitch;
	
	UIInterfaceOrientation interfaceOrientation;
}

@property (nonatomic, retain) HUDView *aHUDFrontView;
@property (nonatomic, retain) HUDBackView *aHUDBackView;

@property (nonatomic, retain) UISwitch *centerSwitch;

@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;

- (void)centerViewAnimated:(BOOL)animated;

@end
