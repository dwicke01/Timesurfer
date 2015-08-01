//
//  TSGrayGradient.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 8/1/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSGrayGradient.h"
#import "TSGraphics.h"

@implementation TSGrayGradient


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [TSGraphics drawGrayGradientWithCanvasSize:canvas];
    
}


@end
