
#import <Foundation/Foundation.h>
#import "TSWeather.h"

@class CLLocation;

@interface TSWeatherManager : NSObject

@property (nonatomic, strong) NSString *weatherSunrise;
@property (nonatomic, strong) NSString *weatherSunset;
@property (nonatomic, strong) NSString *weatherDaySummary;
@property (nonatomic, assign) NSString *weatherHourSummary;
@property (nonatomic, strong) NSAttributedString *weatherLongDateLocal;
@property (nonatomic, strong) NSAttributedString *weatherLongDateLocalTomorrow;
@property (nonatomic, strong) NSString *weatherHighLowTemperaturesF;
@property (nonatomic, strong) NSString *weatherHighLowTemperaturesC;
@property (nonatomic, strong) NSString *weatherHighLowTemperaturesFTomorrow;
@property (nonatomic, strong) NSString *weatherHighLowTemperaturesCTomorrow;
@property (nonatomic, assign) CGFloat weatherStartingMilitaryHourLocal;
@property (nonatomic, assign) CGFloat weatherSunriseMilitaryHourLocal;
@property (nonatomic, assign) CGFloat weatherSunsetMilitaryHourLocal;
@property (nonatomic, assign) NSInteger weatherGMTOffset;
@property (nonatomic, assign) BOOL weatherRainParticlesPresent;

- (instancetype) initWithDictionary:(NSDictionary *)incomingWeatherJSON;

- (TSWeather *)weatherForHour:(NSUInteger)hour;

@end
