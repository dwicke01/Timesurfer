//
//  TSBackground.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TSBackgroundView : UIView

@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic) CGFloat progress;

- (void)makeDaytimeLayerTransparent;
- (void)makeDaytimeLayerOpaque;

@end
