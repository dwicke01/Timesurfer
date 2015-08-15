#import "TSNightGradient.h"
#import "TSGraphics.h"

@implementation TSNightGradient

- (void)drawRect:(CGRect)rect {
    
    CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [TSGraphics drawNightGradientWithCanvasSize:canvas];
}

@end
