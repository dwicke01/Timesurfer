//
//  TSStar.h
//  (null)
//
//  Created by Jordan Guggenheim on 7/11/15.
//  Copyright (c) 2015 (null). All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TSStar : NSObject

// Drawing Methods
+ (void)drawBiggerStarWithFrame: (CGRect)frame starColor: (UIColor*)starColor rotation: (CGFloat)rotation;
+ (void)drawMediumStarWithFrame: (CGRect)frame starColor: (UIColor*)starColor rotation: (CGFloat)rotation;
+ (void)drawLittleStarWithFrame: (CGRect)frame starColor: (UIColor*)starColor rotation: (CGFloat)rotation;
+ (void)drawBigStarWithFrame: (CGRect)frame starColor: (UIColor*)starColor rotation: (CGFloat)rotation;
+ (void)drawDayNightGradientWithCanvasSize: (CGSize)canvasSize;
+ (void)drawDayGradientWithCanvasSize: (CGSize)canvasSize;
+ (void)drawNightGradientWithCanvasSize: (CGSize)canvasSize;

@end



@interface UIColor (PaintCodeAdditions)

- (UIColor*)blendedColorWithFraction: (CGFloat)fraction ofColor: (UIColor*)color;

@end
