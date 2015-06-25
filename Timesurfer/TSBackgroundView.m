//
//  TSBackgroundView.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSBackgroundView.h"

@implementation TSBackgroundView


- (void)drawRect:(CGRect)rect {
    
    CGRect parentContainer = [super bounds];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* color1 = [UIColor colorWithRed:148./255. green:186./255. blue:101./255. alpha:1.];
    UIColor* color2 = [UIColor colorWithRed:39./255. green:144./255. blue:176./255. alpha:1.];
    
    UIColor* color3 = [UIColor colorWithRed: 0.547 green: 0 blue: 0.084 alpha: 0.373];
    UIColor* color4 = [UIColor colorWithRed: 0.939 green: 0.218 blue: 0.302 alpha: 0.627];

    CGFloat linearGradient1Locations[] = {0, 1};
    CGGradientRef linearGradient1 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)color2.CGColor, (id)color1.CGColor], linearGradient1Locations);

    CGFloat linearGradient2Locations[] = {0, 1};
    CGGradientRef linearGradient2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)color3.CGColor, (id)color4.CGColor], linearGradient2Locations);

    UIBezierPath* path3Path = [UIBezierPath bezierPathWithRect: parentContainer];
    CGContextSaveGState(context);
    [path3Path addClip];
    CGContextDrawLinearGradient(context, linearGradient1,
                                CGPointMake(0, 0),
                                CGPointMake(0, 740),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    CGGradientRelease(linearGradient2);
    CGGradientRelease(linearGradient1);
    CGColorSpaceRelease(colorSpace);
    
    
}

@end
