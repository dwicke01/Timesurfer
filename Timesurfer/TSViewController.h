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

- (void) getWeather;
- (TSWeather*) updateWeather:(NSUInteger)hour;

@end

