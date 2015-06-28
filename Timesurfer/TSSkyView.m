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
    [self buildBigStars];
    [self buildLittleStars];
}


- (void) buildBigStars {
    CGFloat xAxis = 0;
    CGFloat xAxisPadding = 10;
    CGFloat yAxis = 5;
    CGFloat starWidth = 22;
    
    CGFloat rotation = 0;
    CGFloat alpha = 1;
    
    CGFloat evenRow = 0;
    CGFloat rowCount = 0;
    
    
    for (int i = 1; i < 2000; i++) {
        
        CGRect rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
        CGFloat maxX = CGRectGetMaxX(rect1);
        UIColor *starColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:alpha];
        rotation = arc4random_uniform(82)-10;
        
        if (maxX+xAxisPadding >= self.frame.size.width) {
            if (evenRow == 0){
                xAxis = starWidth+xAxisPadding*3;
                yAxis += arc4random_uniform(10)+30;
                evenRow = 1;
                alpha *= .7;
            } else {
                xAxis = 20;
                yAxis += arc4random_uniform(10)+30;
                evenRow = 0;
            }
            rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
            
            rowCount++;
            
            if (yAxis > 175) {
                yAxis = 0;
                alpha = 1;
            }
            
        } else {
            rect1 = CGRectMake(xAxis+arc4random_uniform(10)+40, yAxis+arc4random_uniform(10)-10, starWidth, starWidth);
            xAxis += 2*starWidth+xAxisPadding*2;
        }
        
        if (![self newStarIntersects:rect1]) {
            if (i % 2 == 0 && rowCount < 4) {
                [TSStar drawBigStarWithFrame:rect1 starColor:starColor rotation:rotation];
            } else if (i % 1 == 0 && rowCount < 4) {
                [TSStar drawMediumStarWithFrame:rect1 starColor:starColor rotation:rotation];
            } else if (i % 2 == 0 && rowCount < 5 && i < 80) {

                [TSStar drawMediumStarWithFrame:rect1 starColor:starColor rotation:rotation];
            }
            [self.stars addObject:[NSValue valueWithCGRect:rect1]];
        }
    }
}

- (void) buildLittleStars {
    CGFloat xAxis = 0;
    CGFloat xAxisPadding = 10;
    CGFloat yAxis = -10;
    CGFloat starWidth = 2;
    
    CGFloat rotation = 0;
    CGFloat alpha = 1;
    
    CGFloat evenRow = 0;
    CGFloat rowCount = 0;
    
    
    for (int i = 1; i < 500; i++) {
        
        CGRect rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
        CGFloat maxX = CGRectGetMaxX(rect1);
        UIColor *starColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:alpha];
        rotation = arc4random_uniform(82)-10;
        
        if (maxX+xAxisPadding >= self.frame.size.width) {
      
                xAxis = arc4random_uniform(15)+5;
                yAxis += arc4random_uniform(30);

            rect1 = CGRectMake(xAxis, yAxis, starWidth, starWidth);
            alpha *= .8;
            
            
            if (yAxis > 200) {
                yAxis = 0;
                alpha = 1;
            }
            
        } else {
            rect1 = CGRectMake(xAxis+arc4random_uniform(30)-10, yAxis+arc4random_uniform(30)-10, starWidth, starWidth);
            xAxis += 2*starWidth+xAxisPadding*2;
        }
       // if (![self newStarIntersects:rect1]) {
            [TSStar drawLittleStarWithFrame:rect1 starColor:starColor rotation:rotation];
            [self.stars addObject:[NSValue valueWithCGRect:rect1]];
        //}
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
