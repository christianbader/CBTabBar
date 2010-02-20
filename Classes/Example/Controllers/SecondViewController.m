//
//  SecondViewController.m
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.view.backgroundColor = [UIColor redColor];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
