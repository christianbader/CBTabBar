//
//  FirstViewController.m
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.view.backgroundColor = [UIColor yellowColor];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 200.0, 280.0, 40.0)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
								UIViewAutoresizingFlexibleTopMargin |
								UIViewAutoresizingFlexibleBottomMargin;
		
		label.textAlignment = UITextAlignmentCenter;
		label.text = @"Shake!";
		[self.view addSubview:label];
		[label release];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
