
#import <Foundation/Foundation.h>
#import "TSWeather.h"

@class CLLocation;

@interface TSWeatherManager : NSObject

@property (nonatomic, strong) NSString *sunRise;
@property (nonatomic, strong) NSString *sunSet;
@property (nonatomic, strong) NSString *weatherDaySummaryString;
@property (nonatomic, assign) NSString *weatherHourSummaryString;
@property (nonatomic, strong) NSString *highLowTempF;
@property (nonatomic, strong) NSString *highLowTempC;
@property (nonatomic, strong) NSString *highLowTempFTomorrow;
@property (nonatomic, strong) NSString *highLowTempCTomorrow;
@property (nonatomic, assign) NSUInteger startingHour;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) BOOL rainChanceTodayAbove70;
@property (nonatomic, assign) BOOL rainChanceTodayAbove50;

- (instancetype) initWithDictionary:(NSDictionary *)incomingWeatherJSON;
- (TSWeather *)weatherForHour:(NSUInteger)hour;

@end
