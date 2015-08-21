
#import <UIKit/UIKit.h>

@import CoreLocation;

@class TSWeatherManager;

@interface TSViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) TSWeatherManager *weatherData;

- (void) getWeatherWithOverride:(BOOL)override;
- (void) updateWeatherLabelsWithIndex:(NSUInteger)hour;
- (void) startLocationUpdatesWithCompletionBlock:(void (^)(void))completion;

@end

