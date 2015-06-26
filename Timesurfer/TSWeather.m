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
@property (nonatomic, assign) NSUInteger currentTime;

@end

@implementation TSWeather


- (instancetype)initWithDictionary:(NSDictionary *)incomingDictionary {
    
    self = [super init];
    
    if (self) {
        _incomingDictionary = incomingDictionary;
        _currentTime = [self.incomingDictionary[@"time"] integerValue];
        [self formatWeatherData];
    }
    
    return self;
}


- (void) formatWeatherData{
    
    _weatherImage = [UIImage imageNamed:self.incomingDictionary[@"icon"]];
    
    
    NSNumber *temperatureNumber = self.incomingDictionary[@"temperature"];
    _weatherTemperature = [[NSString alloc] initWithFormat:@"%.f",temperatureNumber.floatValue];
    
    
//    NSTimeInterval seconds = self.currentTime;
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:self.currentTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    _currentDate = [dateFormatter stringFromDate:dateTime];
    
    
    NSNumber *cloudCover = self.incomingDictionary[@"cloudCover"];
    _cloudCoverInt = cloudCover.integerValue;
    
    
    NSNumber *percentRain = self.incomingDictionary[@"precipProbability"];
    _percentRainInt = percentRain.integerValue;
    _percentRainString = [NSString stringWithFormat:@"%lu %%",self.percentRainInt];
    
    
    NSNumber *precipIntense = self.incomingDictionary[@"precipIntensity"];
    _precipIntensity = precipIntense.integerValue;
    
    //_dayTime = (self.currentTime >= self.sunRise.integerValue && self.currentTime <= self.sunSet.integerValue) ? YES : NO;
}

@end
