//
//  TSSlider.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 8/1/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSSlider.h"

@interface TSSliderEntry : NSObject

/// slider's value
@property (nonatomic) float value;
/// time at which this position was reached ("slided to")
@property (nonatomic) NSTimeInterval startingTime;
/// how long the user has kept the slider in this position
@property (nonatomic) NSTimeInterval duration;
@end

@implementation TSSliderEntry
- (NSString *)description
{
    return [ @{ @"value" : @(self.value),
                @"startingTime" : @(self.startingTime),
                @"duration" : @(self.duration) } description];
}
@end



@interface TSSlider ()
/// Keeps AHKSliderEntry objects from the current touch.
@property (strong, nonatomic) NSMutableArray *entries;
@end

@implementation TSSlider

#pragma mark - UIControl

#define SIZE_EXTENSION_Y -100

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 0, SIZE_EXTENSION_Y);
    return CGRectContainsPoint(bounds, point);
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL retVal = [super beginTrackingWithTouch:touch withEvent:event];
    
    if (retVal) {
        // reset entries from the previous touch
        self.entries = nil;
        
        [self addNewEntry];
    }

    CGPoint touchPoint = [touch locationInView:touch.view];

    CGFloat sliderX = [self xPositionFromSliderValue:self];
//    NSLog(@"%.f  %.f",sliderX,touchPoint.x);
//    if ((touchPoint.x + 50) > (sliderX - 20) && (touchPoint.x + 50) < (sliderX + 20) ) {
//        retVal = YES;
//    } else {
//        retVal = NO;
//    }
//    
    return YES;
}

- (CGFloat)xPositionFromSliderValue:(UISlider *)aSlider {
    float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
    float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 2.0);
    
    float sliderValueToPixels = (((aSlider.value - aSlider.minimumValue)/(aSlider.maximumValue - aSlider.minimumValue)) * sliderRange) + sliderOrigin;
    
    return sliderValueToPixels;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL retVal = [super continueTrackingWithTouch:touch withEvent:event];
    
    if (retVal) {
        [self updateLastEntryDuration];
        [self addNewEntry];
    }
    
    return retVal;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateLastEntryDuration];
    [self correctValueIfNeeded];
}

#pragma mark - Properties

- (NSMutableArray *)entries
{
    if (!_entries) {
        _entries = [[NSMutableArray alloc] init];
    }
    
    return _entries;
}

#pragma mark - Private

- (void)addNewEntry
{
    TSSliderEntry *newEntry = [[TSSliderEntry alloc] init];
    newEntry.value = self.value;
    newEntry.startingTime = CACurrentMediaTime();
    [self.entries addObject:newEntry];
}

/**
 *  Put the slider at a position that was selected when a user was raising up a finger.
 */
- (void)correctValueIfNeeded
{
    static const CGFloat kAcceptableLocationDelta = 12.0f;
    __block float properSliderValue = FLT_MIN;
    
    // finds the newest entry with a duration longer than 0.05s
    [self.entries enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TSSliderEntry *entry, NSUInteger idx, BOOL *stop) {
        if (entry.duration > 0.05) {
            
            CGFloat width = CGRectGetWidth(self.frame);
            CGFloat valueDelta = fabsf(entry.value - self.value);
            CGFloat sliderRange = fabsf(self.maximumValue - self.minimumValue);
            CGFloat locationDelta = valueDelta / sliderRange * width;
            
            // assume this value as the one user tried to select if it's close enough to the value after the touch has ended
            if (locationDelta < kAcceptableLocationDelta) {
                properSliderValue = entry.value;
            }
            
            *stop = YES;
        }
    }];
    
    // correct the value
    if (properSliderValue != FLT_MIN) {
        [self setValue:properSliderValue animated:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

/// update the duration of the latest entry in the entries array
- (void)updateLastEntryDuration
{
    TSSliderEntry *lastEntry = [self.entries lastObject];
    lastEntry.duration = CACurrentMediaTime() - lastEntry.startingTime;
}

@end