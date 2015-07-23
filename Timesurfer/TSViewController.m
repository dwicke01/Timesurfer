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
#import "TSStarField.h"
#import "TSWeatherData.h"
#import "LMGeocoder.h"
#import "TSClouds.h"
#import "TSConstants.h"
//#import <BAFluidView/BAFluidView.h>

@import CoreLocation;

@interface TSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPrecip;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunRiseSetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moonImage;
@property (weak, nonatomic) IBOutlet UIImageView *milkyWay;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIImageView *precipitationAnimation;
@property (weak, nonatomic) IBOutlet UIView *skyView;
@property (weak, nonatomic) IBOutlet UIView *sunView;
@property (weak, nonatomic) IBOutlet UIView *dayTimeGradient;
@property (weak, nonatomic) IBOutlet UIView *sheepClouds;
@property (weak, nonatomic) IBOutlet UIView *airplane;
@property (weak, nonatomic) IBOutlet TSClouds *clouds;
@property (weak, nonatomic) IBOutlet UISlider *hourSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moonYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moonXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sunYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sunXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cloudsXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheepCloudsXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *airplaneXAxis;

@property (nonatomic, assign) BOOL sheepInMotion;
@property (nonatomic, assign) BOOL planeInMotion;

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat hourOffset;

@property (nonatomic, strong) CLLocation *weatherLocation;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) Forecastr *forcastr;
@property (nonatomic, strong) TSWeatherData *weatherData;
@property (nonatomic, strong) TSWeather *currentWeather;

@property (nonatomic, strong) NSTimer *sliderStoppedTimer;
@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherData = [TSWeatherData sharedDataStore];
    
    self.weatherImage.image = [UIImage imageNamed:@"Surf-Icon"];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    self.forcastr = [Forecastr sharedManager];
    self.forcastr.apiKey = FORCAST_KEY;
    self.sheepCloudsXAxis.constant = self.view.frame.size.width;
    
    self.hourSlider.maximumTrackTintColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.06];
    self.hourSlider.minimumTrackTintColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.9];
    
    self.frameHeight = self.view.frame.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnFromSleep)
                                                 name:@"appBecameActive" object:nil];
    
    self.milkyWay.alpha = 0;
    self.skyView.alpha = 0;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self requestWhenInUseAuth];
    [self.locationManager startUpdatingLocation];
    
    if (![self isKindOfClass:NSClassFromString(@"TodayViewController")]){
        
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)startLocationUpdatesWithCompletionBlock:(void (^)(void))completion {
    if (completion != nil) {
        [self.locationManager startUpdatingLocation];
        completion();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) returnFromSleep {
    self.hourSlider.value = 0;
    
    [self requestWhenInUseAuth];
    [self getWeather];
}

- (IBAction)sliderChanged:(id)sender {
    [self updateWeatherInfo];
    
    if (!self.sliderStoppedTimer) {
        self.sliderStoppedTimer = [[NSTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:1] interval:0 target:self selector:@selector(easterEggs) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.sliderStoppedTimer forMode:NSDefaultRunLoopMode];
    } else {
        self.sliderStoppedTimer.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
        
    }
}

- (void) easterEggs {
    CGFloat currentTime = 0.0;
    
    if (self.hourSlider.value > 2400) {
        currentTime = self.hourSlider.value-2400;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    if ((currentTime >= 2000 || currentTime < 500) && self.sheepInMotion == NO && self.currentWeather.percentRainFloat <= 30 && self.currentWeather.cloudCoverFloat < .6) {
        
        self.sheepInMotion = YES;
        
        [UIView animateWithDuration:15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.sheepCloudsXAxis.constant = -self.view.frame.size.width;
            [self.sheepClouds layoutIfNeeded];
        } completion:^(BOOL finished) {

            self.sheepCloudsXAxis.constant = self.view.frame.size.width;
            self.sheepInMotion = NO;

            
        }];
        
    } else if (self.planeInMotion == NO && self.sheepInMotion == NO){
        
        self.planeInMotion = YES;
        
        [UIView animateWithDuration:15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.airplaneXAxis.constant = -200;
              [self.airplane layoutIfNeeded];
        } completion:^(BOOL finished) {

            self.airplaneXAxis.constant = 500;
            [self.airplane layoutIfNeeded];
            self.planeInMotion = NO;

        }];
    }
    self.sliderStoppedTimer = nil;
}

- (void) updateWeatherInfo {
    CGFloat currentTime = floor(self.hourSlider.value-self.hourOffset)/100;
    
    [self updateWeatherLabelsWithIndex:currentTime];
    [self updateGradient];
    [self updateSky];
    [self updateSun];
    [self updateMoon];
}

- (void) updateSun {
    
    CGFloat currentTime = 0.0;
    CGFloat x = self.view.frame.size.width * .5;
    CGFloat z = self.view.frame.size.width;
    
    if (self.hourSlider.value > 2400) {
        currentTime = self.hourSlider.value-2400;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    
    if (currentTime >= 800 && currentTime <= 2100) {
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.sunXAxis.constant = 15 + z * ((currentTime-800)/900);
                             self.sunYAxis.constant = -65 * sin((M_PI * (self.sunXAxis.constant-50))/z)+50;
                             
                             [self.sunView layoutIfNeeded];
                         }];
        
    } else if (currentTime < 700) {
        self.sunXAxis.constant = 0;
    } else if (currentTime > 2200){
        self.sunXAxis.constant = z + x;
    }
    
    NSLog(@"Sun X %f Sun Y %f",self.sunXAxis.constant, self.sunYAxis.constant);
}

- (void) updateMoon {
    
    
    CGFloat currentTime = 0.0;
    CGFloat x = self.view.frame.size.width * .5 + 100;
    CGFloat z = self.view.frame.size.width;
    
    
    if (self.hourSlider.value > 2600) {
        currentTime = self.hourSlider.value-2600;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    
    if (currentTime >= 2000 && currentTime <= 2600) {
        
        self.moonXAxis.constant = -x;
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.moonXAxis.constant = x * ((currentTime-2000)/600);
                             self.moonYAxis.constant = -65 * sin((M_PI * (self.moonXAxis.constant-50))/z)+75;
                             
                             [self.moonImage layoutIfNeeded];
                             
                         }];
        
        
    } else if (currentTime <= 800){
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.moonXAxis.constant = x + x * (currentTime/600);
                             self.moonYAxis.constant = -65 * sin((M_PI * (self.moonXAxis.constant-50))/z)+75;
                             [self.moonImage layoutIfNeeded];
                         }];
    } else if (currentTime < 900) {
        self.moonXAxis.constant = z + 200;
    } else if (currentTime > 1900){
        self.moonXAxis.constant = 0;
    }
    
    
}

- (void) updateGradient {
    
    CGFloat currentTime = 0.0;
    CGFloat alphaValue = 0.0;
    
    if (self.hourSlider.value > 2400) {
        currentTime = self.hourSlider.value-2400;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    // Program this to correspond with actual sunset
    if (currentTime >= 1500 && currentTime <= 2200) {
        alphaValue = ((2200-currentTime)/700);
        
        // Program this to correspond with actual sunrise
    } else if (currentTime >= 500 && currentTime <= 1000){
        alphaValue = ((currentTime-500)/500);
        
    } else if (currentTime < 500) {
        alphaValue = 0;
        
    } else if (currentTime > 1000 && currentTime < 1500){
        alphaValue = 1;
        
    } else if (currentTime > 2200){
        alphaValue = 0;
    }
    
    if (self.hourSlider.value == self.hourOffset) {
        [UIView animateWithDuration:1 animations:^{
            self.dayTimeGradient.alpha = alphaValue;
        }];
        
    } else {
        self.dayTimeGradient.alpha = alphaValue;
    }
}

- (void) updateSky {
    
    CGFloat currentTime = 0.0;
    CGFloat alphaValue = 0.0;
    
    if (self.hourSlider.value > 2400) {
        currentTime = self.hourSlider.value-2400;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    if (currentTime >= 1900 && currentTime <= 2230) {
        alphaValue = ((currentTime-1900)/330);
        
    } else if (currentTime >= 500 && currentTime <= 730){
        alphaValue = ((730-currentTime)/230);
        
    } else if (currentTime < 500) {
        alphaValue = 1;
        
    } else if (currentTime > 730 && currentTime < 1900){
        alphaValue = 0;
        
    } else if (currentTime > 2200){
        alphaValue = 1;
        
    }
    
    if (self.hourSlider.value == self.hourOffset) {
        [UIView animateWithDuration:1 animations:^{
            
            self.skyView.alpha = alphaValue;
            self.milkyWay.alpha = alphaValue-.7;
            
            self.cloudsXAxis.constant = 0;
            [self.clouds layoutIfNeeded];
        }];
    } else {
        
        self.skyView.alpha = alphaValue;
        self.milkyWay.alpha = alphaValue-.7;
        [self.clouds layoutIfNeeded];
    }
    
}

- (void) updateWeatherLabelsWithIndex:(NSUInteger)indexOfHour{
    TSWeather *weather = [self.weatherData weatherForHour:indexOfHour];
    
    if(self.currentWeather && self.currentWeather == weather) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            self.cloudsXAxis.constant = floor(self.hourSlider.value-self.hourOffset)/2400*(self.view.frame.size.width*-23) ;
            [self.clouds layoutIfNeeded];
            
        }];
        
        
        return;
        
    } else {
        
        self.currentWeather = weather;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        
        if (weather.sunSetHour) {
            self.sunRiseSetLabel.hidden = NO;
            self.sunRiseSetLabel.alpha = 1;
            self.timeLabel.text = self.weatherData.sunSet;
            self.sunRiseSetLabel.text = @"Sunset";
            
        } else if (weather.sunRiseHour) {
            self.sunRiseSetLabel.hidden = NO;
            self.sunRiseSetLabel.alpha = 1;
            self.timeLabel.text = self.weatherData.sunRise;
            self.sunRiseSetLabel.text = @"Sunrise";
            
        }  else {
            self.sunRiseSetLabel.hidden = YES;
            self.timeLabel.text = weather.currentDate;
        }
        
        if (indexOfHour == 0) {
            NSDate *dateTime = [NSDate date];
            self.temperatureLabel.text = weather.weatherTemperature;
            self.weatherImage.image = weather.weatherImage;
            self.percentPrecip.text = weather.percentRainString;
            self.timeLabel.text = [dateFormatter stringFromDate:dateTime];
            
        } else {
            self.temperatureLabel.text = weather.weatherTemperature;
            self.weatherImage.image = weather.weatherImage;
            self.percentPrecip.text = weather.percentRainString;
        }
    }
}

- (void) getWeather{
    
    if (self.latitude == 0 && self.longitude == 0) {
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    
    [self.forcastr getForecastForLatitude:self.latitude
                                longitude:self.longitude
                                     time:nil
                               exclusions:nil
                                   extend:nil
                                  success:^(id JSON) {
                                      //NSLog(@"JSON Response was: %@", JSON);
                                      
                                      [self.locationManager startMonitoringSignificantLocationChanges];
                                      
                                      self.weatherData = [[TSWeatherData alloc] initWithDictionary:JSON];
                                      
                                      self.hourSlider.minimumValue = self.weatherData.startingHour*100;
                                      self.hourSlider.maximumValue = 2400+self.weatherData.startingHour*100;
                                      self.hourSlider.value = self.hourSlider.minimumValue;
                                      self.hourOffset = self.hourSlider.minimumValue;
                                      
                                      NSDictionary *today = [[[JSON valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0];
                                      NSInteger high = [today[@"temperatureMax"] integerValue];
                                      NSInteger low = [today[@"temperatureMin"] integerValue];
                                      self.highLowLabel.text = [NSString stringWithFormat:@"H %lu°F   L %lu°F", high, low];
                                      
                                      CGFloat currentTime = self.weatherData.startingHour;
                                      
                                      if (currentTime > 21 || currentTime < 5) {
                                          self.skyView.alpha =1;
                                      }
                                      
                                      if (currentTime >= 12) {
                                          currentTime = ((24-currentTime)/12)*-736;
                                      } else {
                                          currentTime = (currentTime/12)*-736;
                                      }
                                      self.clouds.weatherData = self.weatherData;
                                      [self updateWeatherInfo];
                                      
                                  } failure:^(NSError *error, id response) {
                                      NSLog(@"Error while retrieving forecast: %@", [self.forcastr messageForError:error withResponse:response]);
                                      
                                  }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.lastObject != nil) {
        self.weatherLocation = locations.lastObject;
    } else {
        self.weatherLocation = manager.location;
    }
    
    //    [self.geoCoder reverseGeocodeLocation:self.weatherLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    //        CLPlacemark *placemark = placemarks.firstObject;
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
    //            //NSLog(@"%@",placemark.locality);
    //        });
    //    }];
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate: /*CLLocationCoordinate2DMake(40.5744, -73.9786)*/
     self.weatherLocation.coordinate
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                NSInteger indexOfLocality = [address.lines indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    return [(NSString *)([[obj objectForKey:@"types"] firstObject]) isEqualToString:@"locality"];
                                                }];
                                                NSInteger indexOfAdministrativeArea = [address.lines indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    return [(NSString *)([[obj objectForKey:@"types"] firstObject]) isEqualToString:@"administrative_area_level_1"];
                                                }];
                                                NSInteger indexOfNeighborhood = [address.lines indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    return [(NSString *)([[obj objectForKey:@"types"] firstObject]) isEqualToString:@"neighborhood"];
                                                }];
                                                
                                                NSString *locality;
                                                
                                                if (indexOfNeighborhood < [address.lines count])
                                                    
                                                    locality = [address.lines[indexOfNeighborhood] objectForKey:@"short_name"];
                                                if (indexOfLocality < [address.lines count] && [locality length] < 14) {
                                                    
                                                    locality = [address.lines[indexOfLocality] objectForKey:@"long_name"];
                                                }
                                                
                                                NSString *administrativeArea = [address.lines[indexOfAdministrativeArea] objectForKey:@"short_name"];
                                                
                                                self.locationLabel.text = [NSString stringWithFormat:@"%@", locality];
                                            }
                                        }];
    
    self.latitude = self.weatherLocation.coordinate.latitude;
    self.longitude = self.weatherLocation.coordinate.longitude;
    [self getWeather];
}

- (void)requestWhenInUseAuth{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status==kCLAuthorizationStatusRestricted) {
        
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
        [self.locationManager requestWhenInUseAuthorization];}
}

@end
