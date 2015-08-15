#import "TSSun.h"
#import "TSGraphics.h"

@interface TSSun()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval firstDrawTime;
@property (nonatomic, assign) BOOL sunFullSize;

@end

@implementation TSSun

- (void)drawRect:(CGRect)rect {
    if(self.firstDrawTime == 0)
    {
        self.firstDrawTime = self.displayLink.timestamp;
        return;
    }
    
    CFTimeInterval elapsedTime = self.displayLink.timestamp - self.firstDrawTime;

            [TSGraphics drawSunTwoWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) sunRotation:(180 + 18000 * sin(elapsedTime*.001)) scale:.8];

}

- (void)makeDisplayLinkIfNeeded {
    if(self.displayLink) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)destroyDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
