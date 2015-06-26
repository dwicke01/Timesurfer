//
//  TSBackgroundView.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSBackgroundView.h"

@implementation TSBackgroundView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = [self bounds];
    layer.colors = @[[self cgColorForRed:148 green:186 blue:101 alpha:1], [self cgColorForRed:39 green:144 blue:176 alpha:1]];
    //layer.locations = @[@0,@1];
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(0, 0);
    [self.layer addSublayer:layer];
}

-(id) cgColorForRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    return (id)color.CGColor;
}

@end
