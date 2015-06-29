//
//  TSBackgroundView.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSBackgroundView.h"

@implementation TSBackgroundView {
    CAGradientLayer *daytimeLayer;
    NSArray   *_daytimeColors;
    NSArray   *_nighttimeColors;
    NSUInteger _counter;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _daytimeColors =  @[[self cgColorForRed: 148 green: 186 blue: 101 alpha: 1], [self cgColorForRed: 39 green: 144 blue: 176 alpha: 1]];
        _nighttimeColors = @[[self cgColorForRed:39 green:144 blue:176 alpha:1], [self cgColorForRed:36 green:136 blue:166 alpha:1], [self cgColorForRed:34 green:128 blue:157 alpha:1], [self cgColorForRed:32 green:120 blue:147 alpha:1], [self cgColorForRed:30 green:113 blue:138 alpha:1], [self cgColorForRed:28 green:105 blue:128 alpha:1],  [self cgColorForRed:26 green:97 blue:119 alpha:1], [self cgColorForRed:24 green:90 blue:110 alpha:1], [self cgColorForRed:22 green:82 blue:100 alpha:1], [self cgColorForRed:20 green:74 blue:91 alpha:1], [self cgColorForRed:18 green:67 blue:82 alpha:1], [self cgColorForRed:16 green:60 blue:74 alpha:1], [self cgColorForRed:15 green:54 blue:66 alpha:1], [self cgColorForRed:12 green:46 blue:56 alpha:1],[self cgColorForRed:10 green:37 blue:46 alpha:1],[self cgColorForRed:7 green:27 blue:33 alpha:1],[self cgColorForRed:4 green:17 blue:19 alpha:1],[self cgColorForRed:4 green:17 blue:19 alpha:1],[self cgColorForRed:0 green:0 blue:10 alpha:1]];
        
        
        _counter = 0;
        CAGradientLayer *layer = (id)self.layer;
//        daytimeLayer = (id)self.layer;
        
        layer.frame = [self bounds];
        layer.colors = _daytimeColors;
        
        layer.startPoint = CGPointMake(0, 1);
        layer.endPoint = CGPointMake(0, 0);
        self.maskLayer = [CALayer layer];
        [self.maskLayer setFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        [self.maskLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
//        [self performAnimation];
        daytimeLayer = [[CAGradientLayer alloc]init];
        daytimeLayer.frame = [self bounds];
        daytimeLayer.startPoint = CGPointMake(0, 1);
        daytimeLayer.endPoint = CGPointMake(0, 0);
        daytimeLayer.colors = _daytimeColors;
        
        CAGradientLayer *nighttimeLayer = [[CAGradientLayer alloc] init];
        nighttimeLayer.frame = [self bounds];
        nighttimeLayer.startPoint = CGPointMake(0, 1);
        nighttimeLayer.endPoint = CGPointMake(0, 0);
        nighttimeLayer.colors = _nighttimeColors;
        nighttimeLayer.opacity = 1;

        [self.layer addSublayer:nighttimeLayer];
        [self.layer addSublayer:daytimeLayer];
        
        [layer setMask:self.maskLayer];
        [self.layer insertSublayer:self.maskLayer atIndex:0];
        
        //[self makeDaytimeLayerTransparent];

    }
    return self;
}

-(id) cgColorForRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    return (id)color.CGColor;
}

- (void)performAnimation {
    // Move the last color in the array to the front
    // shifting all the other colors.
    CAGradientLayer *layer = (id)[self layer];
    NSMutableArray *mutable = [[layer colors] mutableCopy];
    
    [mutable removeObjectAtIndex:0];
    [mutable addObject:_nighttimeColors[_counter++]];
    NSArray *shiftedColors = [NSArray arrayWithArray:mutable];
    
    // Update the colors on the model layer
    [layer setColors:shiftedColors];
    
    // Create an animation to slowly move the gradient left to right.
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setToValue:shiftedColors];
    [animation setDuration:0.001];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [animation setDelegate:self];
    [layer addAnimation:animation forKey:@"animateGradient"];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    return;
    CAGradientLayer *layer = (id)self.layer;
    if (![((UIColor*)layer.colors[10]) isEqual:[self cgColorForRed:0 green:0 blue:10 alpha:1]
          ])
        [self performAnimation];
    else
        _counter = 0;
}

- (void)setProgress:(CGFloat)value {
    if (self.progress != value) {
        // Progress values go from 0.0 to 1.0
        self.progress = MIN(1.0, fabs(value));
        [self setNeedsLayout];
    }
}


- (void)makeDaytimeLayerTransparent {
    CAGradientLayer *layer = daytimeLayer;
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 1.3;
    [layer addAnimation:fadeAnim forKey:@"opacity"];
    layer.opacity = 0.0;
}

- (void)makeDaytimeLayerOpaque {
    CAGradientLayer *layer = daytimeLayer;
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 1.3;
    [layer addAnimation:fadeAnim forKey:@"opacity"];
    layer.opacity = 1.0;
}

- (void)layoutSubviews {
    // Resize our mask layer based on the current progress
    CGRect maskRect = [self.maskLayer frame];
    maskRect.size.width = CGRectGetWidth([self bounds]) * self.progress;
    [self.maskLayer setFrame:maskRect];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
