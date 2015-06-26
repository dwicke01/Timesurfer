//
//  TSWeatherData.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSWeather.h"

@interface TSWeatherData : NSObject

@property (nonatomic, strong) NSNumber *sunRise;
@property (nonatomic, strong) NSNumber *sunSet;

- (instancetype) initWithDictionary:(NSDictionary *)incomingWeather;
- (TSWeather *)weatherForHour:(NSUInteger)hour;

@end
