//
//  TSViewController.h
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreLocation/CoreLocation.h>
@import CoreLocation;

@class TSWeather;

@interface TSViewController : UIViewController <CLLocationManagerDelegate>




@property (nonatomic, strong) CLLocationManager *locationManager;

- (void) getWeather;
- (void) updateWeatherLabelsWithIndex:(NSUInteger)hour;
- (void)startLocationUpdatesWithCompletionBlock:(void (^)(void))completion;

@end

