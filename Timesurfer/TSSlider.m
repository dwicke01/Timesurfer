#import "TSSlider.h"

@interface TSSlider ()

@end

@implementation TSSlider

#pragma mark - UIControl

#define THUMB_SIZE 10
#define EFFECTIVE_THUMB_SIZE 40

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 0, -100);
    return CGRectContainsPoint(bounds, point);
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    float thumbPercent = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    float thumbPos = THUMB_SIZE + (thumbPercent * (bounds.size.width - (2 * THUMB_SIZE)));
    CGPoint touchPoint = [touch locationInView:self];
    
    return (touchPoint.x >= (thumbPos - EFFECTIVE_THUMB_SIZE) &&
            touchPoint.x <= (thumbPos + EFFECTIVE_THUMB_SIZE));
}

@end