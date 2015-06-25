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
@end


@implementation TSWeatherData

- (instancetype)initWithDictionary:(NSDictionary *)incomingWeather{
    
    self = [super init];
    
    if (self){
        _weatherDictionary = incomingWeather;
        _weatherByHour = [[NSMutableArray alloc] init];
        [self populateWeatherByHour];
    }
    
    return self;
}

- (void) populateWeatherByHour{
    
    if (self.weatherDictionary[@"currently"]) {
        TSWeather *weather = [[TSWeather alloc] initWithDictionary:self.weatherDictionary[@"currently"]];
        [self.weatherByHour addObject:weather];
        
    }
    
    if (self.weatherDictionary[@"hourly"]){
        
        NSArray *hourlyDataArray = self.weatherDictionary[@"hourly"][@"data"];
        NSLog(@"%@",hourlyDataArray[1]);
        for (NSUInteger i = 1; i < hourlyDataArray.count; i++) {
            TSWeather *weather = [[TSWeather alloc] initWithDictionary:hourlyDataArray[i]];
            [self.weatherByHour addObject:weather];
        }
    }
}


- (TSWeather *)weatherForHour:(NSUInteger)hour{
    
    return nil;
}

@end
