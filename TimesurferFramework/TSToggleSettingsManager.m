//
//  ToggleAnimationsManager.m
//  Timesurfer
//
//  Created by Daniel Wickes on 8/27/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSToggleSettingsManager.h"

@implementation TSToggleSettingsManager

-(instancetype)init {
    if (self = [super init]) {
        _toggleAirplaneAnimation = YES;
        _toggleAllAnimations = YES;
        _toggleCatsAndDogsAnimation = YES;
        _toggleHelicopterAnimation = YES;
        _toggleSheepAnimation = YES;
        _toggleSquirrelAnimation = YES;
        _toggleGoogleCalendar = NO;
        NSLog(@"%@", self);
    }
    return self;
}

@end
