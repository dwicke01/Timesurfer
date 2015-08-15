#import "TSDayTimeGradient.h"
#import "TSGraphics.h"

@implementation TSDayTimeGradient

- (void)drawRect:(CGRect)rect {

    CGSize canvas = CGSizeMake(self.frame.size.width, self.frame.size.height);
    [TSGraphics drawDayGradientWithCanvasSize:canvas];
}







@end
