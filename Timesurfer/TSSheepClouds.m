//
//  TSSheepClouds.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/12/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSSheepClouds.h"
#import "TSGraphics.h"

@implementation TSSheepClouds

- (void)drawRect:(CGRect)rect {

    [TSGraphics drawSheepCloudsWithAlpha:1];
    
//    [self setNeedsDisplay];
}

@end
