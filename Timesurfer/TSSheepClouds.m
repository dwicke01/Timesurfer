//
//  TSSheepClouds.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 7/16/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSSheepClouds.h"
#import "TSGraphics.h"

@interface TSSheepClouds()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval firstDrawTime;

@end

@implementation TSSheepClouds

-(void)drawRect:(CGRect)rect
{
    if(self.firstDrawTime == 0)
    {
        self.firstDrawTime = self.displayLink.timestamp;
        return;
    }
    
    CFTimeInterval elapsedTime = self.displayLink.timestamp - self.firstDrawTime;
    // 50 - 140
    
    
    if (self.frame.size.width == 320) {
        [TSGraphics drawLightSheepCloudsSmallWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) legRotation:-1*(15 + 15 * sin(self.displayLink.timestamp*8))];
    } else {
        [TSGraphics drawLightSheepCloudsWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) legRotation:-1*(15 + 15 * sin(self.displayLink.timestamp*8))];
    }
    
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    if(newWindow) {
        // We're moving to a window, so we're on screen somehow
        [self makeDisplayLinkIfNeeded];
    }
    else {
        // We're leaving a window (i.e., we're going offscreen)
        [self destroyDisplayLink];
    }
}

-(void)makeDisplayLinkIfNeeded
{
    if(self.displayLink) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)destroyDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}



@end
