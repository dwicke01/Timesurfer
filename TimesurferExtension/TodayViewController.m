//
//  TodayViewController.m
//  TimesurferExtension
//
//  Created by Daniel Wickes on 6/29/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "TodayViewController.h"
#define AF_APP_EXTENSIONS
#import <NotificationCenter/NotificationCenter.h>
//#import <Forecastr/Forecastr.h>

@implementation TodayViewController {
    NSInteger _time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;

    //[self getWeather];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startUpdatingLocation];

//    [self startLocationUpdatesWithCompletionBlock:^{
//        [self getWeather];
//    }];
    //[self getWeather];
}

- (IBAction)timeStepper:(id)sender {
    UIStepper *stepper = sender;
    //_time += stepper.value + 24;
    //_time = _time % 24;
    NSLog(@"%f",stepper.value);
    if (stepper.value < 0)
        stepper.value = 0;
    else if (stepper.value > 23)
        stepper.value = 23;
    else {
        [self updateWeatherLabelsWithIndex:(NSInteger)stepper.value];
        TSWeather *weather = [self.weatherData weatherForHour:stepper.value];
        //self.weatherImageView.image = weather.weatherImage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
