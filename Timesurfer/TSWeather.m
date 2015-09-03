#import "TSWeather.h"
#import "NSDate+Utilities.h"

@interface TSWeather()

@property (nonatomic, strong) NSDictionary *incomingDictionary;
@property (nonatomic, assign) NSUInteger currentTime;
@property (nonatomic, assign) NSInteger gmtOffset;

@end

@implementation TSWeather

- (instancetype)initWithDictionary:(NSDictionary *)incomingDictionary gmtOffset:(NSInteger) gmtOffset{
    
    self = [super init];
    
    if (self) {
        _incomingDictionary = incomingDictionary;
        _currentTime = [incomingDictionary[@"time"] integerValue];
        _gmtOffset = gmtOffset;
        [self formatWeatherData];
    }
    
    return self;
}

- (void) formatWeatherData{

    NSNumber *temperatureNumber = self.incomingDictionary[@"temperature"];
    _weatherTemperatureF = [[NSString alloc] initWithFormat:@"%.f°F",temperatureNumber.floatValue];
    CGFloat celcius = ((temperatureNumber.floatValue - 32.f) / 1.8f);
    _weatherTemperatureC = [[NSString alloc] initWithFormat:@"%.f°C",celcius];
    
    
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:self.currentTime];
    _weatherTime = [dateTime timeStringWithGMTOffset:self.gmtOffset militaryTime:NO];
    
    _weatherMilitaryHour = [dateTime militaryHourWithGMTOffset:self.gmtOffset];
    
    NSNumber *cloudCover = self.incomingDictionary[@"cloudCover"];
    _weatherCloudCover = cloudCover.floatValue;
    
    
    NSNumber *percentRain = self.incomingDictionary[@"precipProbability"];
    // Round rain down, then make value out of 100
    _weatherPercentRain = roundf(percentRain.floatValue * 10) * 10;
    _weatherPercentRainString = [NSString stringWithFormat:@"%.0F%%",self.weatherPercentRain];
    
    
    NSNumber *precipIntense = self.incomingDictionary[@"precipIntensity"];
    _weatherPrecipIntensity = precipIntense.floatValue;
}

-(UIImage *)weatherImage {
    return [UIImage imageNamed:self.incomingDictionary[@"icon"]];
}

@end
