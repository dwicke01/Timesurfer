//
//  TSSkyView.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/26/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSSkyView.h"



@implementation TSSkyView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGRect rect1 = CGRectMake(0, 0, 0, 0);
    
    _stars = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGRect:rect1], nil];
    
    CGFloat xAxis = 15;
    CGFloat xAxisPadding = 10;
    CGFloat yAxis = 5;
    CGFloat starWidth = 25;
    
    CGFloat rotation = 0;
    CGFloat alpha = 1;
    
    CGFloat count = 1;

    
    
    for (int i = 1; i < 90; i++) {
        
        CGRect rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
        CGFloat maxX = CGRectGetMaxX(rect1);
        NSLog(@"%f",maxX);
//        NSLog(@"%f",self.frame.size.width);
        UIColor *starColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:alpha];
        
        if (maxX+xAxisPadding >= self.frame.size.width) {
            if (count == 1){
                xAxis = starWidth+xAxisPadding;
                yAxis += 5+starWidth;
                count = 2;
            } else {
                xAxis = 10;
                yAxis += 5+starWidth;
                count = 1;
            }
            rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
                    alpha *= .7;
        } else {
            xAxis += starWidth+xAxisPadding*2;
        }

        if (![self newStarIntersects:rect1]) {
            [TSStar drawBigStarWithFrame:rect1 starColor:starColor rotation:rotation];
            [self.stars addObject:[NSValue valueWithCGRect:rect1]];
        }
    }
    
}


- (BOOL) newStarIntersects:(CGRect)rect{
    
    for (NSValue *values in self.stars) {

        CGRect oldRect = values.CGRectValue;
        if (CGRectIntersectsRect(oldRect, rect)) {
//            NSLog(@"Hit!");
            return YES;
        }
    }
    return NO;
}



@end
