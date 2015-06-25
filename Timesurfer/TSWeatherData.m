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

@end


@implementation TSWeatherData

- (instancetype)initWithDictionary:(NSDictionary *)incomingWeather{
    
    return self;
}

-(TSWeather *)weatherForHour:(NSUInteger)hour{
    
    return nil;
}

@end
