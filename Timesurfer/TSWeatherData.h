//
//  TSWeatherData.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSWeather.h"

@class CLLocation;

@interface TSWeatherData : NSObject

@property (nonatomic, strong) NSString *sunRise;
@property (nonatomic, strong) NSString *sunSet;
@property (nonatomic, assign) NSUInteger startingHour;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) BOOL rainChanceTodayAbove50;

+ (instancetype)sharedDataStore;

- (instancetype) initWithDictionary:(NSDictionary *)incomingWeatherJSON;
- (TSWeather *)weatherForHour:(NSUInteger)hour;

@end
