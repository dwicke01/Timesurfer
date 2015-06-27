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
@property (nonatomic, strong) NSString *currentHour;
@property (nonatomic, strong) NSString *sunRiseString;
@property (nonatomic, strong) NSString *sunSetString;

@end

@implementation TSWeather


- (instancetype)initWithDictionary:(NSDictionary *)incomingDictionary sunRiseString:(NSString *)sunRiseString sunSetString:(NSString *)sunSetString {
    
    self = [super init];
    
    if (self) {
        _incomingDictionary = incomingDictionary;
        _currentTime = [self.incomingDictionary[@"time"] integerValue];
        _sunSetString = sunSetString;
        _sunRiseString = sunRiseString;
        [self formatWeatherData];
    }
    
    return self;
}


- (void) formatWeatherData{
    
    _weatherImage = [UIImage imageNamed:self.incomingDictionary[@"icon"]];
    
    NSNumber *temperatureNumber = self.incomingDictionary[@"temperature"];
    _weatherTemperature = [[NSString alloc] initWithFormat:@"%.f°F",temperatureNumber.floatValue];
    
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:self.currentTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a"];
    _currentDate = [dateFormatter stringFromDate:dateTime];
    
    [dateFormatter setDateFormat:@"H"];
    _currentHour = [dateFormatter stringFromDate:dateTime];
    
    if ([self.currentHour isEqualToString:self.sunRiseString]) {
        _sunRiseHour = YES;
    }

    if([self.currentHour isEqualToString:self.sunSetString]){
        _sunSetHour = YES;
    }
    
    NSNumber *cloudCover = self.incomingDictionary[@"cloudCover"];
    _cloudCoverInt = cloudCover.integerValue;
    
    NSNumber *percentRain = self.incomingDictionary[@"precipProbability"];
    self.percentRainFloat = roundf(percentRain.floatValue*10)*10;
   // NSLog(@"%.2f",self.percentRainFloat);
    _percentRainString = [NSString stringWithFormat:@"%.0F%%",self.percentRainFloat];
    
    NSNumber *precipIntense = self.incomingDictionary[@"precipIntensity"];
    _precipIntensity = precipIntense.integerValue;
}

@end
