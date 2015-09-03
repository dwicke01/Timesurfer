#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSWeather : NSObject

- (instancetype) initWithDictionary:(NSDictionary *)incomingDictionary gmtOffset:(NSInteger)gmtOffset;

@property (nonatomic, strong) NSString *weatherTime;
@property (nonatomic, strong) NSString *weatherTemperatureF;
@property (nonatomic, strong) NSString *weatherTemperatureC;
@property (nonatomic, strong) NSString *weatherPercentRainString;
@property (nonatomic, assign) CGFloat weatherMilitaryHour;
@property (nonatomic, assign) CGFloat weatherPercentRain;
@property (nonatomic, assign) CGFloat weatherCloudCover;
@property (nonatomic, assign) CGFloat weatherPrecipIntensity;

- (UIImage *)weatherImage;

@end
