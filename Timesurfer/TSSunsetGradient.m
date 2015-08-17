//
//  TSSunsetGradient.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 8/15/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSSunsetGradient.h"
#import "TSGraphics.h"
@implementation TSSunsetGradient



- (void)drawRect:(CGRect)rect {
     CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    [TSGraphics drawSunsetGradientWithCanvasSize:canvas];
}


@end
