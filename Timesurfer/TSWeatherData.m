//
//  TSWeatherData.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSWeatherData.h"

@interface TSWeatherData ()

@property (nonatomic, strong) NSDictionary *weatherDictionary;
@property (nonatomic, strong) NSMutableArray *weatherByHour;
@property (nonatomic, strong) NSDate *sunRiseDate;
@property (nonatomic, strong) NSDate *sunSetDate;
@property (nonatomic, strong) NSString *sunRiseHour;
@property (nonatomic, strong) NSString *sunSetHour;
@end


@implementation TSWeatherData

- (instancetype)initWithDictionary:(NSDictionary *)incomingWeather{
    
    self = [super init];
    
    if (self){
        _weatherDictionary = incomingWeather;
        _weatherByHour = [[NSMutableArray alloc] init];
        
        NSNumber *sunRiseNum = self.weatherDictionary[@"daily"][@"data"][0][@"sunriseTime"];
        NSNumber *sunSetNum = self.weatherDictionary[@"daily"][@"data"][0][@"sunsetTime"];
        _sunRiseDate = [NSDate dateWithTimeIntervalSince1970:sunRiseNum.integerValue];
        _sunSetDate = [NSDate dateWithTimeIntervalSince1970:sunSetNum.integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        
        _sunRise = [dateFormatter stringFromDate:self.sunRiseDate];
        _sunSet = [dateFormatter stringFromDate:self.sunSetDate];
        
        [dateFormatter setDateFormat:@"H"];
        
        _sunRiseHour = [dateFormatter stringFromDate:self.sunRiseDate];
        _sunSetHour = [dateFormatter stringFromDate:self.sunSetDate];
        
        [self populateWeatherByHour];
    }
    
    return self;
}

- (void) populateWeatherByHour{
    
    if (self.weatherDictionary[@"currently"]) {
    
        TSWeather *weather = [[TSWeather alloc] initWithDictionary:self.weatherDictionary[@"currently"] sunRiseString:self.sunRiseHour sunSetString:self.sunSetHour];
        [self.weatherByHour addObject:weather];
    }
    
    if (self.weatherDictionary[@"hourly"]){
        
        NSMutableArray *hourlyDataArray = [[NSMutableArray alloc] initWithArray:self.weatherDictionary[@"hourly"][@"data"]];
        NSDate *dateTime = [NSDate date];
        
        NSNumber *unixTimeAtIndex1 = hourlyDataArray[1][@"time"];
        NSDate *dateAtIndex1 = [NSDate dateWithTimeIntervalSince1970:unixTimeAtIndex1.doubleValue];
        
        if ([dateTime compare:dateAtIndex1] == NSOrderedDescending ||[dateTime compare:dateAtIndex1] == NSOrderedSame) {
            [hourlyDataArray removeObjectAtIndex:1];
        }
        for (NSUInteger i = 1; i < hourlyDataArray.count; i++) {
            TSWeather *weather = [[TSWeather alloc] initWithDictionary:hourlyDataArray[i] sunRiseString:self.sunRiseHour sunSetString:self.sunSetHour];
            [self.weatherByHour addObject:weather];
        }
    }
}


- (TSWeather *)weatherForHour:(NSUInteger)hour{
    
    return self.weatherByHour[hour];
}

@end
