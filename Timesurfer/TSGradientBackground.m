//
//  TSGradientBackground.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/28/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSGradientBackground.h"
#import "TSStar.h"




@implementation TSGradientBackground


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [TSStar drawCanvas2WithBackgroudY:0];
}

- (void)transitionGradient:(CGFloat)yAxis{
    
    [TSStar drawCanvas2WithBackgroudY:yAxis];
}



@end
