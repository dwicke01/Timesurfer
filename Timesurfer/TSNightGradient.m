//
//  TSNightGradient.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/11/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSNightGradient.h"
#import "TSGraphics.h"

@implementation TSNightGradient

- (void)drawRect:(CGRect)rect {
    
    
    CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [TSGraphics drawNightGradientWithCanvasSize:canvas];
}

@end
