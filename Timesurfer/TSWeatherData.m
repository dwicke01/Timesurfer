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
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSString *sunRiseHour;
@property (nonatomic, strong) NSString *sunSetHour;
@property (nonatomic, assign) BOOL dayLight;
@end


@implementation TSWeatherData

- (instancetype)initWithDictionary:(NSDictionary *)incomingWeather{
    
    self = [super init];
    
    if (self){
        _weatherDictionary = incomingWeather;
        _weatherByHour = [[NSMutableArray alloc] init];
        
        NSNumber *sunRiseNum = self.weatherDictionary[@"daily"][@"data"][0][@"sunriseTime"];
        NSNumber *sunSetNum = self.weatherDictionary[@"daily"][@"data"][0][@"sunsetTime"];
        NSNumber *currentNum = self.weatherDictionary[@"hourly"][@"data"][0][@"time"];
        _sunRiseDate = [NSDate dateWithTimeIntervalSince1970:sunRiseNum.integerValue];
        _sunSetDate = [NSDate dateWithTimeIntervalSince1970:sunSetNum.integerValue];
        _currentDate = [NSDate dateWithTimeIntervalSince1970:currentNum.integerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        
        _sunRise = [dateFormatter stringFromDate:self.sunRiseDate];
        _sunSet = [dateFormatter stringFromDate:self.sunSetDate];
        
        [dateFormatter setDateFormat:@"H"];
        
        _sunRiseHour = [dateFormatter stringFromDate:self.sunRiseDate];
        _sunSetHour = [dateFormatter stringFromDate:self.sunSetDate];
        _startingHour = [[dateFormatter stringFromDate:self.currentDate] integerValue];
        
        [self populateWeatherByHour];
    }
    
    return self;
}

- (void) populateWeatherByHour{
    
    if (self.weatherDictionary[@"currently"]) {
        NSNumber *hour = self.weatherDictionary[@"hourly"][@"data"][0][@"time"];
        NSUInteger militaryHour = [self currentHour:hour];
        
        TSWeather *weather = [[TSWeather alloc] initWithDictionary:self.weatherDictionary[@"currently"] sunRiseString:self.sunRiseHour sunSetString:self.sunSetHour sunUp:[self sunUpCheck:militaryHour]];
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
            
            NSNumber *hour = self.weatherDictionary[@"hourly"][@"data"][i][@"time"];
            NSUInteger theHour = [self currentHour:hour];
            
            TSWeather *weather = [[TSWeather alloc] initWithDictionary:hourlyDataArray[i] sunRiseString:self.sunRiseHour sunSetString:self.sunSetHour sunUp:[self sunUpCheck:theHour]];
            [self.weatherByHour addObject:weather];
        }
    }
}


- (TSWeather *)weatherForHour:(NSUInteger)hour{
    
    return self.weatherByHour[hour];
}

- (NSUInteger)currentHour:(NSNumber *) num{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H"];
    NSString *hourString = [dateFormatter stringFromDate:date];
    return hourString.integerValue;
}

- (BOOL) sunUpCheck:(NSUInteger) theHour {
    if (theHour >= self.sunRiseHour.integerValue && theHour < self.sunSetHour.integerValue) {
        return YES;
    } else {
        return NO;
    }
}

@end
