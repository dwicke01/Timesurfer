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

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunRiseSetLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void) getWeather;
- (TSWeather*) updateWeather:(NSUInteger)hour;
- (void)startLocationUpdatesWithCompletionBlock:(void (^)(void))completion;

@end

