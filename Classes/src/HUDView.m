//
//  HUDView.m
//  CBTabBar
//
//  Created by Christian Bader on 1/23/10.
//  Copyright 2010 Christian Bader. All rights reserved.
//

#import "HUDView.h"

@implementation HUDView

- (id)init {
	CGRect frame = CGRectMake(0.0, 0.0, 250.0, 150.0);
		
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {

	float radius = 10.0f;
	
	CGContextRef context = UIGraphicsGetCurrentContext();   
	rect = CGRectInset(rect, 1.0f, 1.0f);
	
	CGContextBeginPath(context);
	CGContextSetGrayFillColor(context, 1.0, 0.7);
	CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
	CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
}

@end
