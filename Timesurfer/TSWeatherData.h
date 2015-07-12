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

@property (nonatomic, strong) NSString *sunRise;
@property (nonatomic, strong) NSString *sunSet;
@property (nonatomic, assign) NSUInteger startingHour;


- (instancetype) initWithDictionary:(NSDictionary *)incomingWeatherJSON;
- (TSWeather *)weatherForHour:(NSUInteger)hour;

@end
