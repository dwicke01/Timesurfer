#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSWeather : NSObject

- (instancetype) initWithDictionary:(NSDictionary *)incomingDictionary sunRiseString:(NSString *)sunRiseString sunSetString:(NSString *)sunSetString sunUp:(BOOL)sunUp;

@property (nonatomic, strong, readonly) UIImage *weatherImage;
@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) NSString *weatherTemperatureF;
@property (nonatomic, strong) NSString *weatherTemperatureC;
@property (nonatomic, strong) NSString *percentRainString;
@property (nonatomic, assign) BOOL sunRiseHour;
@property (nonatomic, assign) BOOL sunSetHour;
@property (nonatomic, assign) BOOL sunUp;
@property (nonatomic, assign) CGFloat percentRainFloat;
@property (nonatomic, assign) CGFloat cloudCoverFloat;
@property (nonatomic, assign) CGFloat precipIntensityFloat;
@property (nonatomic, assign) NSUInteger currentHourInt;
@end
