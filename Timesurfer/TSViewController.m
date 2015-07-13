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
@property (weak, nonatomic) IBOutlet UIView *skyView;
@property (weak, nonatomic) IBOutlet UIView *dayTimeGradient;
@property (weak, nonatomic) IBOutlet UIView *sheepClouds;
@property (weak, nonatomic) IBOutlet UISlider *hourSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moonYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moonXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheepCloudsXAxis;
@property (nonatomic) BOOL moonInMotion;
@property (nonatomic) BOOL cloudsInMotion;

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

@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherData = nil;
    self.weatherImage.image = [UIImage imageNamed:@"Surf-Icon"];
    
    self.geoCoder = [[CLGeocoder alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    self.forcastr = [Forecastr sharedManager];
    self.forcastr.apiKey = @"530d1d38e625bdd0d86381ffe990ca1c";
    
    self.hourSlider.maximumTrackTintColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.06];
    self.hourSlider.minimumTrackTintColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.9];
    
    self.frameHeight = self.view.frame.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnFromSleep)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.milkyWay.alpha = 0;
    self.skyView.alpha = 0;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self requestAlwaysAuth];
    
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
    self.moonXAxis.constant = -405;
    self.sheepCloudsXAxis.constant = 440;
    
    NSUInteger randomInt = arc4random_uniform(2);
    
    if (randomInt == 1) {
        self.moonImage.image = [UIImage imageNamed:@"Cool-Moon"];
    } else {
        self.moonImage.image = [UIImage imageNamed:@"Moon"];
    }
    
    [self requestAlwaysAuth];
    [self getWeather];
}

- (IBAction)sliderChanged:(id)sender {
    [self updateWeatherInfo];
}

- (void) updateWeatherInfo {
    CGFloat currentTime = floor(self.hourSlider.value-self.hourOffset)/100;
    
    [self updateWeatherLabelsWithIndex:currentTime];
    [self updateGradient];
    [self updateSky];
}

- (void) updateGradient {
    
    CGFloat currentTime;
    CGFloat alphaValue;
    
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
    
    [UIView animateWithDuration:.7 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.dayTimeGradient.alpha = alphaValue;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void) updateSky {
    
    CGFloat currentTime;
    CGFloat alphaValue;
    
    if (self.hourSlider.value > 2400) {
        currentTime = self.hourSlider.value-2400;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    if (currentTime >= 1900 && currentTime <= 2230) {
        alphaValue = ((currentTime-1900)/330);
        

        
        if ([self.moonImage.image isEqual: [UIImage imageNamed:@"Moon"]] && self.moonInMotion == NO && self.moonXAxis.constant != -15) {
            self.moonInMotion = YES;
            self.cloudsInMotion = YES;
            self.moonYAxis.constant = 30;
            self.moonXAxis.constant = -390;
            [self.skyView layoutIfNeeded];
            
            
            [UIView animateKeyframesWithDuration:20 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                    self.moonXAxis.constant = 0;
                    self.moonYAxis.constant = -10;
                    [self.skyView layoutIfNeeded];
                }];
                
//                [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.1 animations:^{
//                    self.moonXAxis.constant = -80;
//                    self.moonYAxis.constant = -40;
//                    [self.skyView layoutIfNeeded];
//                }];
//                
//                [UIView addKeyframeWithRelativeStartTime:.6 relativeDuration:.1 animations:^{
//                    self.moonXAxis.constant = -60;
//                    self.moonYAxis.constant = -20;
//                    [self.skyView layoutIfNeeded];
//                }];
//                
//                [UIView addKeyframeWithRelativeStartTime:.7 relativeDuration:.1 animations:^{
//                    self.moonXAxis.constant = -5;
//                    self.moonYAxis.constant = 30;
//                    [self.skyView layoutIfNeeded];
//                }];
            
            } completion:^(BOOL finished) {
                self.moonInMotion = NO;
            }];
            
            
        
            
        } else if (self.moonInMotion == NO) {
            //Move this to separate method to account for accurate moon rise/set times
            self.moonInMotion = YES;
            
            [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.moonXAxis.constant = -15;
                [self.skyView layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.moonInMotion = NO;
            }];
        }
        
        if (self.cloudsInMotion == NO) {
            
            self.cloudsInMotion = YES;
            
            [UIView animateWithDuration:40 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                self.sheepCloudsXAxis.constant = -440;
                [self.sheepClouds layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.cloudsInMotion = NO;
                NSLog(@"Clouds done %d",self.moonInMotion);
            }];
            
        }
     
        
    } else if (currentTime >= 500 && currentTime <= 730){
        alphaValue = ((730-currentTime)/230);
        
    } else if (currentTime < 500) {
        alphaValue = 1;
        
    } else if (currentTime > 730 && currentTime < 1700){
        alphaValue = 0;
        
    } else if (currentTime > 2200){
        alphaValue = 1;
    }
    
    self.skyView.alpha = alphaValue;
    self.milkyWay.alpha = alphaValue-.7;
}

- (void) updateWeatherLabelsWithIndex:(NSUInteger)indexOfHour{
    TSWeather *weather = [self.weatherData weatherForHour:indexOfHour];
    
    if(self.currentWeather && self.currentWeather == weather) {
        
        return;
        
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
            self.timeLabel.text = weather.currentDate;
        }
    }
}

- (void) getWeather{
    
    if (self.latitude == 0 && self.longitude == 0) {
        return;
    }
    
    [self.forcastr getForecastForLatitude:self.latitude
                                longitude:self.longitude
                                     time:nil
                               exclusions:nil
                                   extend:nil
                                  success:^(id JSON) {
                                      //NSLog(@"JSON Response was: %@", JSON);
                                      
                                      self.weatherData = [[TSWeatherData alloc] initWithDictionary:JSON];
                                      
                                      self.hourSlider.minimumValue = self.weatherData.startingHour*100;
                                      self.hourSlider.maximumValue = 2400+self.weatherData.startingHour*100;
                                      self.hourSlider.value = self.hourSlider.minimumValue;
                                      self.hourOffset = self.hourSlider.minimumValue;
                                      
                                      NSDictionary *today = [[[JSON valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0];
                                      NSInteger high = [today[@"temperatureMax"] integerValue];
                                      NSInteger low = [today[@"temperatureMin"] integerValue];
                                      self.highLowLabel.text = [NSString stringWithFormat:@"H %lu L %lu", high, low];
                                      
                                      [self updateWeatherLabelsWithIndex:0];
                                      
                                      CGFloat currentTime = self.weatherData.startingHour;
                                      
                                      if (currentTime > 21 || currentTime < 5) {
                                          self.skyView.alpha =1;
                                      }
                                      
                                      if (currentTime >= 12) {
                                          currentTime = ((24-currentTime)/12)*-736;
                                      } else {
                                          currentTime = (currentTime/12)*-736;
                                      }
                                      
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
                                                
                                                self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", locality, administrativeArea];
                                            }
                                        }];
    
    self.latitude = self.weatherLocation.coordinate.latitude;
    self.longitude = self.weatherLocation.coordinate.longitude;
    [self getWeather];
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
