//
//  TSWeather.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSWeather.h"

@interface TSWeather()

@property (nonatomic, strong) NSDictionary *incomingDictionary;
@property (nonatomic, strong) NSNumber *sunRise;
@property (nonatomic, strong) NSNumber *sunSet;
@property (nonatomic, assign) NSUInteger currentTime;

@end

@implementation TSWeather


- (instancetype)initWithDictionary:(NSDictionary *)incomingDictionary sunrise:(NSNumber*)sunRise sunSet:(NSNumber *)sunSet{
    
    self = [super init];
    
    if (self) {
        _incomingDictionary = incomingDictionary;
        _sunSet = sunSet;
        _sunRise = sunRise;
        [self formatWeatherData];
    }
    
    return self;
}


- (void) formatWeatherData{
    
    _weatherImage = [UIImage imageNamed:self.incomingDictionary[@"icon"]];
    
    NSNumber *temperatureNumber = self.incomingDictionary[@"temperature"];
    _weatherTemperature = [[NSString alloc] initWithFormat:@"%.f",temperatureNumber.floatValue];
    
    _currentTime = [self.incomingDictionary[@"time"] integerValue];
    
    _dayTime = (self.currentTime >= self.sunRise.integerValue && self.currentTime <= self.sunSet.integerValue) ? YES: NO;
}

@end
