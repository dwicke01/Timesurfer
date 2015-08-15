#import "TSGrayGradient.h"
#import "TSGraphics.h"

@implementation TSGrayGradient

- (void)drawRect:(CGRect)rect {

    CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [TSGraphics drawGrayGradientWithCanvasSize:canvas];
    
}

@end
