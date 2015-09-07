
#import "TSWeatherManager.h"
#import <CoreLocation/CLLocation.h>
#import "NSDate+Utilities.h"

@interface TSWeatherManager ()

@property (nonatomic, strong) NSDictionary *weatherDictionary;
@property (nonatomic, strong) NSMutableArray *weatherByHour;

@end

@implementation TSWeatherManager

- (instancetype)initWithDictionary:(NSDictionary *)incomingWeatherJSON{
    
    self = [super init];
    
    if (self){
        _weatherDictionary = incomingWeatherJSON;

        _weatherByHour = [[NSMutableArray alloc] init];

        _weatherHourSummary = self.weatherDictionary[@"minutely"][@"summary"];
        
        _weatherDaySummary = self.weatherDictionary[@"hourly"][@"summary"];

        _weatherGMTOffset = ((NSNumber *)self.weatherDictionary[@"offset"]).integerValue;
        
        [self weatherSunriseSunset];
        
        [self weatherhighLowTemps];

        [self weatherDates];
        
        [self populateWeatherByHour];
    }
    
    return self;
}

- (TSWeather *)weatherForHour:(NSUInteger)hour{
    
    return self.weatherByHour[hour];
}

- (void) weatherDates {
    
    NSNumber *startingEpochTime = self.weatherDictionary[@"hourly"][@"data"][0][@"time"];
    NSDate *startingDate = [NSDate dateWithTimeIntervalSince1970:startingEpochTime.integerValue];
    
    _weatherStartingMilitaryHourLocal = [startingDate militaryHourWithGMTOffset:self.weatherGMTOffset];
    
    _weatherLongDateLocal = [startingDate longDateWithGMTOffset:self.weatherGMTOffset];
    
    NSDate *tomorrowDate = [startingDate dateByAddingTimeInterval:60*60*24];
    
    _weatherLongDateLocalTomorrow = [tomorrowDate longDateWithGMTOffset:self.weatherGMTOffset];
}

- (void) weatherSunriseSunset {
    
    NSNumber *sunRiseNum = self.weatherDictionary[@"daily"][@"data"][0][@"sunriseTime"];
    NSDate *sunriseDate = [NSDate dateWithTimeIntervalSince1970:sunRiseNum.integerValue];
    _weatherSunrise = [sunriseDate timeStringWithGMTOffset:self.weatherGMTOffset militaryTime:0];
    _weatherSunriseMilitaryHourLocal = [sunriseDate militaryHourWithGMTOffset:self.weatherGMTOffset];
    
    NSNumber *sunSetNum = self.weatherDictionary[@"daily"][@"data"][0][@"sunsetTime"];
    NSDate *sunsetDate = [NSDate dateWithTimeIntervalSince1970:sunSetNum.integerValue];
    _weatherSunset = [sunsetDate timeStringWithGMTOffset:self.weatherGMTOffset militaryTime:0];
    _weatherSunsetMilitaryHourLocal = [sunsetDate militaryHourWithGMTOffset:self.weatherGMTOffset];
}

- (void) weatherhighLowTemps {
    NSDictionary *today = [[[self.weatherDictionary valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0];
    CGFloat high = [today[@"temperatureMax"] floatValue];
    CGFloat low = [today[@"temperatureMin"] floatValue];
    
    _weatherHighLowTemperaturesF = [NSString stringWithFormat:@"H %.f°F   L %.f°F", high, low];
    
    high = ((high - 32.f) / 1.8f);
    low = ((low - 32.f) / 1.8f);
    
    _weatherHighLowTemperaturesC = [NSString stringWithFormat:@"H %.f°C   L %.f°C", high, low];
    
    // Tomorrow
    today = [[[self.weatherDictionary valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:1];
    high = [today[@"temperatureMax"] floatValue];
    low = [today[@"temperatureMin"] floatValue];
    
    _weatherHighLowTemperaturesFTomorrow = [NSString stringWithFormat:@"H %.f°F   L %.f°F", high, low];
    
    high = ((high - 32.f) / 1.8f);
    low = ((low - 32.f) / 1.8f);
    
    _weatherHighLowTemperaturesCTomorrow = [NSString stringWithFormat:@"H %.f°C   L %.f°C", high, low];
}

- (void) populateWeatherByHour{
    
    // Create first weather object for current weather
    if (self.weatherDictionary[@"currently"]) {
        
        TSWeather *weather = [[TSWeather alloc] initWithDictionary:self.weatherDictionary[@"currently"] gmtOffset:self.weatherGMTOffset];
        
        if (weather.weatherPercentRain >= 70) {
            self.weatherRainParticlesPresent = YES;
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
            
            TSWeather *weather = [[TSWeather alloc] initWithDictionary:hourlyWeatherDataArray[i] gmtOffset:self.weatherGMTOffset];
            
            if (weather.weatherPercentRain >= 60) {
                self.weatherRainParticlesPresent = YES;
            }
            
            [self.weatherByHour addObject:weather];
        }
    }
}

@end
