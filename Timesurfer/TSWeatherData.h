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


- (instancetype) initWithDictionary:(NSDictionary *)incomingWeather;
- (TSWeather *)weatherForHour:(NSUInteger)hour;

@end
