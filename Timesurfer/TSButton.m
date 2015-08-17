#import "TSButton.h"

@implementation TSButton

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 0, -75);
    return CGRectContainsPoint(bounds, point);
}


@end
