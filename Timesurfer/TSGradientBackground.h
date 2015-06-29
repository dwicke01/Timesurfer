//
//  TSGradientBackground.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/28/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSGradientBackground : UIView

@property (nonatomic, assign) NSInteger yAxis;

- (void)transitionGradient:(CGFloat)yAxis;


@end
