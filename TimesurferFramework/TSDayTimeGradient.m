//
//  TSDayTimeGradient.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/11/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSDayTimeGradient.h"
#import "TSStar.h"

@implementation TSDayTimeGradient

- (void)drawRect:(CGRect)rect {

    CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [TSStar drawDayGradientWithCanvasSize:canvas];
}


@end
