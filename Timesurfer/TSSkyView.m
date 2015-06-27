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
    
    CGFloat xAxis = 0;
    CGFloat xAxisPadding = 10;
    CGFloat yAxis = 5;
    CGFloat starWidth = 25;
    
    CGFloat rotation = 0;
    CGFloat alpha = 1;
    
    CGFloat evenRow = 0;
    CGFloat rowCount = 0;
    
    
    for (int i = 1; i < 100; i++) {
        
        CGRect rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
        CGFloat maxX = CGRectGetMaxX(rect1);
        UIColor *starColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:alpha];
        rotation = arc4random_uniform(82)-10;
        
        if (maxX+xAxisPadding >= self.frame.size.width) {
            if (evenRow == 0){
                xAxis = starWidth+xAxisPadding*3;
                yAxis += arc4random_uniform(10)+15;
                evenRow = 1;
            } else {
                xAxis = 20;
                yAxis += arc4random_uniform(10)+15;
                evenRow = 0;
            }
            rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
            alpha *= .8;
            rowCount++;
        } else {
            rect1 = CGRectMake(xAxis+arc4random_uniform(10)-10, yAxis+arc4random_uniform(10)-10, starWidth, starWidth);
            xAxis += 2*starWidth+xAxisPadding*2;
        }
        
        if (![self newStarIntersects:rect1]) {
            if (i % 4 == 0 && rowCount < 4) {
                [TSStar drawBigStarWithFrame:rect1 starColor:starColor rotation:rotation];
            } else if (i % 2 == 0 && rowCount < 4) {
                [TSStar drawMediumStarWithFrame:rect1 starColor:starColor rotation:rotation];
            } else if (i % 4 == 0 && rowCount < 8) {
                [TSStar drawMediumStarWithFrame:rect1 starColor:starColor rotation:rotation];
            } else {
                [TSStar drawLittleStarWithFrame:rect1 starColor:starColor rotation:rotation];
            }
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
