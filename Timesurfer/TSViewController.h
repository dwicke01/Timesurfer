
#import <UIKit/UIKit.h>

@import CoreLocation;

@class TSWeather;

@interface TSViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void) getWeatherForced:(BOOL)override;
- (void) updateWeatherLabelsWithIndex:(NSUInteger)hour;
- (void) startLocationUpdatesWithCompletionBlock:(void (^)(void))completion;

@end

