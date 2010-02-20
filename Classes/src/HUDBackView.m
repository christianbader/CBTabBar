//
//  HUDBackView.m
//  CBTabBar
//
//  Created by Christian Bader on 1/24/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import "HUDBackView.h"

@implementation HUDBackView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
