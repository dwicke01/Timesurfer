//
//  ViewController.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import <Forecastr/Forecastr.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TSViewController.h"
#import "TSSkyView.h"
#import "TSWeatherData.h"
#import "TSGradientBackground.h"
@import CoreLocation;

@interface TSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISlider *hourSlider;
@property (weak, nonatomic) IBOutlet UILabel *sunRiseSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPrecip;
@property (weak, nonatomic) IBOutlet TSSkyView *skyView;
@property (weak, nonatomic) IBOutlet TSGradientBackground *gradientBackground;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *weatherLocation;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) Forecastr *forcastr;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, strong) TSWeatherData *weatherData;
@property (nonatomic, strong) TSWeather *currentWeather;

@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weatherImage.image = [UIImage imageNamed:@"Surf-Icon"];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    self.forcastr = [Forecastr sharedManager];
    self.forcastr.apiKey = @"530d1d38e625bdd0d86381ffe990ca1c";
    self.hourSlider.value = 0;
    self.hourSlider.maximumValue = 24;
    //[self.hourSlider setThumbImage:[UIImage imageNamed:@"surfer-thumb2"] forState:UIControlStateNormal];
    self.hourSlider.maximumTrackTintColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.06];
    self.hourSlider.minimumTrackTintColor = [UIColor colorWithRed:255. green:255. blue:255. alpha:0.9];
    self.skyView.alpha = .5;
    self.skyView.hidden = YES;
    self.gradientBackground.frame = CGRectMake(0, -736, 414, 1472);
    //    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    
    //panRecognizer.delegate = self;
    
    //    [self.view addGestureRecognizer:panRecognizer];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}


//- (IBAction)detectPan:(id)sender{
//    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
//    CGPoint relativeLocation = [pan translationInView:self.view];
//    CGPoint actualLocation = [pan locationInView:self.view];
//
////    NSLog(@"%@",NSStringFromCGPoint(actualLocation));
//    NSLog(@"%f",self.startPoint);
//
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        self.startPoint = actualLocation.x;
//    }
//}

- (void)viewDidAppear:(BOOL)animated{
    [self requestAlwaysAuth];
    [self.locationManager startMonitoringSignificantLocationChanges];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)sliderChanged:(id)sender {
    CGFloat theHour = floor(self.hourSlider.value);
    //NSLog(@"%.2f",self.hourSlider.value);
    
    [self updateWeather:theHour];
    
    CGFloat currentTime = self.currentWeather.currentHourInt;
    
    if (currentTime >= 21 || currentTime < 5) {
        currentTime = 0;
    } else if (currentTime >= 11 && currentTime <= 15) {
        currentTime = -736;
    } else if (currentTime > 12){
        currentTime = (24-currentTime-4);
        currentTime = (currentTime/6)*-736;
    } else {
        currentTime -= 4;
        currentTime = (currentTime/6)*-736;
    }
    
    self.gradientBackground.frame = CGRectMake(0, currentTime, 414, 1472);
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.lastObject != nil) {
        self.weatherLocation = locations.lastObject;
    } else {
        self.weatherLocation = manager.location;
    }
    
    [self.geoCoder reverseGeocodeLocation:self.weatherLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
        });
    }];
    
    self.latitude = self.weatherLocation.coordinate.latitude;
    self.longitude = self.weatherLocation.coordinate.longitude;
    [self getWeather];
    
}

- (void) getWeather{
    [self.forcastr getForecastForLatitude:self.latitude
                                longitude:self.longitude
                                     time:nil
                               exclusions:nil
                                   extend:nil
                                  success:^(id JSON) {
                                       NSLog(@"JSON Response was: %@", JSON);
                                      
                                      _weatherData = [[TSWeatherData alloc] initWithDictionary:JSON];
                                      
                                      [self updateWeather:0];
                                      
                                      CGFloat currentTime = self.weatherData.startingHour;
                                      
                                      if (currentTime > 21 || currentTime < 5) {
                                          self.skyView.alpha =1;
                                      }
                                      
                                      if (currentTime >= 12) {
                                          currentTime = ((24-currentTime)/12)*-736;
                                      } else {
                                          currentTime = (currentTime/12)*-736;
                                      }
                                      
                                      
                                      if (self.currentWeather.sunUp) {
                                          self.skyView.hidden = YES;
                                          
                                          self.gradientBackground.frame = CGRectMake(0, currentTime, 414, 1472);
                                          NSLog(@"%f",currentTime);
                                      } else {
                                          self.skyView.hidden = NO;
                                          self.gradientBackground.frame = CGRectMake(0, currentTime, 414, 1472);
                                          NSLog(@"%lu",self.weatherData.startingHour);
                                      }
                                      
                                  } failure:^(NSError *error, id response) {
                                      NSLog(@"Error while retrieving forecast: %@", [self.forcastr messageForError:error withResponse:response]);
                                  }];
}


- (TSWeather*) updateWeather:(NSUInteger)hour{
    TSWeather *weather = [self.weatherData weatherForHour:hour];
    
    NSLog(@"%lu",hour);
    if(self.currentWeather && self.currentWeather == weather) {
        
        return weather;
        
    } else {
        
        self.currentWeather = weather;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        
        CGFloat currentTime = self.currentWeather.currentHourInt;
        
        if (weather.sunSetHour) {
            self.sunRiseSetLabel.hidden = NO;
            self.sunRiseSetLabel.alpha = 1;
            self.sunRiseSetLabel.text = [NSString stringWithFormat:@"Sunset: %@",self.weatherData.sunSet];
            
        } else if (weather.sunRiseHour) {
            self.sunRiseSetLabel.hidden = NO;
            self.sunRiseSetLabel.alpha = 1;
            self.sunRiseSetLabel.text = [NSString stringWithFormat:@"Sunrise: %@",self.weatherData.sunRise];
            
        }  else if (currentTime == 19 || currentTime == 21) {
            self.sunRiseSetLabel.alpha = .5;
            self.sunRiseSetLabel.text = [NSString stringWithFormat:@"Sunset: %@",self.weatherData.sunSet];
            self.sunRiseSetLabel.hidden = NO;
        } else if (currentTime == 4 || currentTime == 6) {
            self.sunRiseSetLabel.alpha = .5;
            self.sunRiseSetLabel.text = [NSString stringWithFormat:@"Sunrise: %@",self.weatherData.sunRise];
            self.sunRiseSetLabel.hidden = NO;
        } else {
            self.sunRiseSetLabel.hidden = YES;
        }
        
        
        
        if (hour == 0) {
            NSDate *dateTime = [NSDate date];
            self.temperatureLabel.text = weather.weatherTemperature;
            self.weatherImage.image = weather.weatherImage;
            self.percentPrecip.text = weather.percentRainString;
            self.timeLabel.text = [dateFormatter stringFromDate:dateTime];
            
        } else {
            self.temperatureLabel.text = weather.weatherTemperature;
            self.weatherImage.image = weather.weatherImage;
            self.percentPrecip.text = weather.percentRainString;
            self.timeLabel.text = weather.currentDate;
        }
     
        if (self.currentWeather.currentHourInt == 7 || self.currentWeather.currentHourInt == 19) {
            self.skyView.hidden = NO;
            self.skyView.alpha =.35;
        } else if (self.currentWeather.currentHourInt == 6 || self.currentWeather.currentHourInt == 20){
            self.skyView.hidden = NO;
            self.skyView.alpha =.5;
        } else if (self.currentWeather.currentHourInt == 5 || self.currentWeather.currentHourInt == 21){
                   self.skyView.hidden = NO;
                   self.skyView.alpha = .75;
        } else if (self.currentWeather.currentHourInt < 5 || self.currentWeather.currentHourInt > 21){
            self.skyView.hidden = NO;
            self.skyView.alpha = 1;
        } else {
            self.skyView.hidden = YES;
        }
//        self.skyView.hidden = self.currentWeather.sunUp;
        return weather;
    }
}


- (void)requestAlwaysAuth{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied || status==kCLAuthorizationStatusRestricted) {
        
        NSString *title;
        
        title=(status == kCLAuthorizationStatusDenied || status==kCLAuthorizationStatusRestricted) ? @"Location Services Are Off" : @"Background use is not enabled";
        
        NSString *message = @"Go to settings";
        
        UIAlertController *settingsAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication]openURL:settingsURL];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [settingsAlert addAction:goToSettings];
        [settingsAlert addAction:cancel];
        
        [self presentViewController:settingsAlert animated:YES completion:nil];

    } else if (status==kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestAlwaysAuthorization];}
}

@end
