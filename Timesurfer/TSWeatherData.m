//
//  TSWeatherData.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/25/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TSWeatherData.h"
#import <CoreLocation/CLLocation.h>

@interface TSWeatherData ()

@property (nonatomic, strong) NSDictionary *weatherDictionary;
@property (nonatomic, strong) NSMutableArray *weatherByHour;
@property (nonatomic, strong) NSDate *sunRiseDate;
@property (nonatomic, strong) NSDate *sunSetDate;
@property (nonatomic, strong) NSString *sunRiseHour;
@property (nonatomic, strong) NSString *sunSetHour;
@property (nonatomic, assign) BOOL dayLight;

@end

@implementation TSWeatherData

+ (instancetype)sharedDataStore {
    static TSWeatherData *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[TSWeatherData alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)initWithDictionary:(NSDictionary *)incomingWeatherJSON{
    
    self = [super init];
    
    if (self){
        _weatherDictionary = incomingWeatherJSON;
        _weatherByHour = [[NSMutableArray alloc] init];
        
        _location = [[CLLocation alloc] initWithLatitude:[self.weatherDictionary[@"latitude"] doubleValue] longitude:[self.weatherDictionary[@"longitude"] doubleValue]];
        
        
        NSDictionary *today = [[[incomingWeatherJSON valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0];
        CGFloat high = [today[@"temperatureMax"] floatValue];
        CGFloat low = [today[@"temperatureMin"] floatValue];
        
        _highLowTempF = [NSString stringWithFormat:@"H %.f°F   L %.f°F", high, low];
        
        high = ((high - 32.f) / 1.8f);
        low = ((low - 32.f) / 1.8f);

        _highLowTempC = [NSString stringWithFormat:@"H %.f°C   L %.f°C", high, low];
        
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
        
        _weatherSummaryString = self.weatherDictionary[@"hourly"][@"summary"];
        
        [self populateWeatherByHour];
    }
    
    return self;
}

- (void) populateWeatherByHour{
    
    
    // Create first weather object for current weather
    if (self.weatherDictionary[@"currently"]) {
        
        NSNumber *unixTime = self.weatherDictionary[@"hourly"][@"data"][0][@"time"];
        NSUInteger militaryHour = [self convertToMilitaryHourWithUnixTime:unixTime];
        
        TSWeather *weather = [[TSWeather alloc] initWithDictionary:self.weatherDictionary[@"currently"] sunRiseString:self.sunRiseHour sunSetString:self.sunSetHour sunUp:[self sunUpCheck:militaryHour]];
        
        if (weather.percentRainFloat >= 50) {
            self.rainChanceTodayAbove50 = YES;
        }
        
        [self.weatherByHour addObject:weather];
    }
    
    // Create weather objects for remaining hours
    if (self.weatherDictionary[@"hourly"]){
        
        NSMutableArray *hourlyWeatherDataArray = [[NSMutableArray alloc] initWithArray:self.weatherDictionary[@"hourly"][@"data"]];
        
        
        // If the hourly weather for Index 1 is the same hour as the current weather hour then remove the redundant weather info
        NSDate *currentDateTime = [NSDate date];
        NSNumber *unixTimeAtIndex1 = hourlyWeatherDataArray[1][@"time"];
        NSDate *dateAtIndex1 = [NSDate dateWithTimeIntervalSince1970:unixTimeAtIndex1.doubleValue];
        
        if ([currentDateTime compare:dateAtIndex1] == NSOrderedDescending || [currentDateTime compare:dateAtIndex1] == NSOrderedSame) {
            [hourlyWeatherDataArray removeObjectAtIndex:1];
        }
        
        //Create Weather Objects and add to weatherByHour array
        for (NSUInteger i = 1; i < hourlyWeatherDataArray.count; i++) {
            
            NSNumber *unixTime = self.weatherDictionary[@"hourly"][@"data"][i][@"time"];
            NSUInteger militaryHour = [self convertToMilitaryHourWithUnixTime:unixTime];
            
            TSWeather *weather = [[TSWeather alloc] initWithDictionary:hourlyWeatherDataArray[i] sunRiseString:self.sunRiseHour sunSetString:self.sunSetHour sunUp:[self sunUpCheck:militaryHour]];
            
            if (weather.percentRainFloat >= 50 && i < 13) {
                self.rainChanceTodayAbove50 = YES;
            }
            
            [self.weatherByHour addObject:weather];
            
//            if (i == 23) {
//                
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"staleWeather"];
//                [[NSUserDefaults standardUserDefaults] setObject:self.weatherByHour forKey:@"staleWeather"];
//            }
        }
    }
}


- (TSWeather *)weatherForHour:(NSUInteger)hour{
    
    if (self.weatherByHour[hour]) {
        
        return self.weatherByHour[hour];
        
    } else {
        
        NSArray *staleWeatherArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"staleWeather"];
        
        return staleWeatherArray[hour];
    }
}

- (NSUInteger)convertToMilitaryHourWithUnixTime:(NSNumber *) unixTime{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime.integerValue];
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
