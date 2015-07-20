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


- (instancetype)initWithDictionary:(NSDictionary *)incomingDictionary sunRiseString:(NSString *)sunRiseString sunSetString:(NSString *)sunSetString sunUp:(BOOL)sunUp{
    
    self = [super init];
    
    if (self) {
        _incomingDictionary = incomingDictionary;
        _currentTime = [self.incomingDictionary[@"time"] integerValue];
        _sunSetString = sunSetString;
        _sunRiseString = sunRiseString;
        _sunUp = sunUp;
        [self formatWeatherData];
    }
    
    return self;
}


- (void) formatWeatherData{

    NSNumber *temperatureNumber = self.incomingDictionary[@"temperature"];
    _weatherTemperature = [[NSString alloc] initWithFormat:@"%.f°F",temperatureNumber.floatValue];
    
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:self.currentTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a"];
    _currentDate = [dateFormatter stringFromDate:dateTime];
    
    [dateFormatter setDateFormat:@"H"];
    _currentHour = [dateFormatter stringFromDate:dateTime];
    self.currentHourInt = self.currentHour.integerValue;
    if ([self.currentHour isEqualToString:self.sunRiseString]) {
        _sunRiseHour = YES;
    }

    if([self.currentHour isEqualToString:self.sunSetString]){
        _sunSetHour = YES;
    }
    
    NSNumber *cloudCover = self.incomingDictionary[@"cloudCover"];
    _cloudCoverFloat = cloudCover.floatValue;
    
    NSNumber *percentRain = self.incomingDictionary[@"precipProbability"];
    self.percentRainFloat = roundf(percentRain.floatValue*10)*10;
//    NSLog(@"%.2f",self.cloudCoverFloat);
    _percentRainString = [NSString stringWithFormat:@"%.0F%% ☂",self.percentRainFloat];
    
    NSNumber *precipIntense = self.incomingDictionary[@"precipIntensity"];
    _precipIntensityFloat = precipIntense.floatValue;
}

-(UIImage *)weatherImage
{
    return [UIImage imageNamed:self.incomingDictionary[@"icon"]];
}

@end
