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
//#import "TSEventManager.h"
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
@property (weak, nonatomic) IBOutlet UIView *grayGradient;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greyCatYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackCatYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orangeCatYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pugYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *corgiYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *poodleYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yorkieYAxis;
@property (weak, nonatomic) IBOutlet UIImageView *yorkieDog;
@property (weak, nonatomic) IBOutlet UIImageView *greyCat;
@property (weak, nonatomic) IBOutlet UIImageView *blackCat;
@property (weak, nonatomic) IBOutlet UIImageView *orangeCat;
@property (weak, nonatomic) IBOutlet UIImageView *pugDog;
@property (weak, nonatomic) IBOutlet UIImageView *corgieDog;
@property (weak, nonatomic) IBOutlet UIImageView *poodleDog;
@property (weak, nonatomic) IBOutlet UIImageView *greyStripeCat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greyStripeYAxis;

@property (nonatomic, assign) BOOL sheepInMotion;
@property (nonatomic, assign) BOOL planeInMotion;
@property (nonatomic, assign) BOOL animalsInMotion;
@property (nonatomic, assign) BOOL grayGradientInMotion;

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat hourOffset;

@property (nonatomic, strong) CLLocation *weatherLocation;

@property (nonatomic, strong) Forecastr *forcastr;
@property (nonatomic, strong) TSWeatherData *weatherData;
@property (nonatomic, strong) TSWeather *currentWeather;

@property (nonatomic, strong) NSTimer *sliderStoppedTimer;
@property (nonatomic, strong) NSDate *apiLastRequestTime;

@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    self.forcastr = [Forecastr sharedManager];
    self.forcastr.apiKey = FORCAST_KEY;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnFromSleep)
                                                 name:@"appBecameActive" object:nil];
    [self setupView];
    
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

- (void) returnFromSleep {
    [self.locationManager startUpdatingLocation];
    self.hourSlider.value = 0;
    
    if (arc4random_uniform(5) == 4) {
        UIImage *sliderThumb = [self imageWithImage: [UIImage imageNamed:@"Surf-Icon"] scaledToSize:CGSizeMake(60,60)];
        
        [self.hourSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    }
    
    [self requestWhenInUseAuth];
    [self getWeather];
}

- (void) updateWeatherInfo {
    CGFloat currentTime = floor(self.hourSlider.value-self.hourOffset)/100;
    
    [self updateWeatherLabelsWithIndex:currentTime];
    [self updateGradient];
    [self updateSky];
    [self updateSun];
    [self updateMoon];
}

- (void) getWeather{
    
    if (self.latitude == 0 && self.longitude == 0) {
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Time Interval Since Now %f", fabs([self.apiLastRequestTime timeIntervalSinceNow]));
    
    if (!self.weatherData || [self.weatherLocation distanceFromLocation:self.weatherData.location] > 8000 || fabs([self.apiLastRequestTime timeIntervalSinceNow])>1800) {
        
        self.apiLastRequestTime = [NSDate date];
        
        [self.forcastr getForecastForLatitude:self.latitude
                                    longitude:self.longitude
                                         time:nil
                                   exclusions:nil
                                       extend:nil
                                      success:^(id JSON) {
                                          //                                      NSLog(@"JSON Response was: %@", JSON);
                                          //                                      NSLog(@"Made API Call");
                                          
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
    } else {
        [self updateWeatherInfo];
    }
}

#pragma mark UI Updates

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
    
    //NSLog(@"Sun X %f Sun Y %f",self.sunXAxis.constant, self.sunYAxis.constant);
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
                             self.moonYAxis.constant = -65 * sin((M_PI * (self.moonXAxis.constant-50))/z)+100;
                             
                             [self.moonImage layoutIfNeeded];
                             
                         }];
        
        
    } else if (currentTime <= 800){
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.moonXAxis.constant = x + x * (currentTime/600);
                             self.moonYAxis.constant = -65 * sin((M_PI * (self.moonXAxis.constant-50))/z)+100;
                             [self.moonImage layoutIfNeeded];
                         }];
    } else if (currentTime < 900) {
        self.moonXAxis.constant = z + 200;
    } else if (currentTime > 1900){
        self.moonXAxis.constant = 0;
    }
    
    //    NSLog(@"Y %f  X %f",self.moonYAxis.constant,self.moonXAxis.constant);
    
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
        [UIView animateWithDuration:.5 animations:^{
            self.dayTimeGradient.alpha = alphaValue;
            
            self.grayGradient.alpha = 1 * ((self.currentWeather.percentRainFloat-40)/40);
        }];
        
    } else {
        self.dayTimeGradient.alpha = alphaValue;
        
        if (!self.grayGradientInMotion) {
            self.grayGradientInMotion = YES;
            
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.grayGradient.alpha = 1 * ((self.currentWeather.percentRainFloat-40)/40);
            } completion:^(BOOL finished) {
                self.grayGradientInMotion = NO;
            }];
            
            NSLog(@"%f",self.grayGradient.alpha);
        }
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
    
    if(self.currentWeather == weather) {
        
        return;
        
    } else {
        
        [self removeWeatherAnimation];
        
        self.currentWeather = weather;
        
        [UIView animateWithDuration:.5 animations:^{
            
            CGFloat nearestHour = floor((self.hourSlider.value - self.hourOffset)/100)*100;
            
            self.cloudsXAxis.constant = nearestHour/2400*(self.view.frame.size.width*-25) ;
            [self.clouds layoutIfNeeded];
        }];
        
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
            self.timeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        } else {
            
        }
        self.temperatureLabel.text = weather.weatherTemperature;
        self.weatherImage.image = weather.weatherImage;
        
        if (self.weatherData.rainChanceTodayAbove50 || weather.percentRainFloat >= 50) {
            self.percentPrecip.text = [NSString stringWithFormat:@"%@ ☂",weather.percentRainString];
        } else {
            self.percentPrecip.text = weather.percentRainString;
        }
        
        
    }
}


#pragma mark Animations

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
    
    if ((currentTime >= 2000 || currentTime < 500) && self.sheepInMotion == NO && self.planeInMotion == NO && self.currentWeather.percentRainFloat <= 30 && self.currentWeather.cloudCoverFloat < .6) {
        
        self.sheepInMotion = YES;
        
        [UIView animateWithDuration:15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.sheepCloudsXAxis.constant = -self.view.frame.size.width;
            [self.sheepClouds layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            self.sheepCloudsXAxis.constant = self.view.frame.size.width;
            self.sheepInMotion = NO;
        }];
        
    } else if (self.currentWeather.percentRainFloat >= 80) {
        
        self.animalsInMotion = YES;
        NSUInteger constant = 1100;
        NSUInteger duration = 5;
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.greyCatYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:.5
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.corgiYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:1
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.blackCatYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:1.8
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.poodleYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:2.3
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.pugYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:3
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.orangeCatYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:3.5
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.greyStripeYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:duration
                              delay:4.3
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.yorkieYAxis.constant = constant;
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
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


- (void) removeWeatherAnimation {
    
    if (self.currentWeather.percentRainFloat < 70 && self.animalsInMotion) {
        
        self.animalsInMotion = NO;
        
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.corgieDog.alpha = 0;
                             self.greyCat.alpha = 0;
                             self.pugDog.alpha = 0;
                             self.orangeCat.alpha = 0;
                             self.poodleDog.alpha = 0;
                             self.blackCat.alpha = 0;
                             self.yorkieDog.alpha = 0;
                             self.greyStripeCat.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self.corgieDog.layer removeAllAnimations];
                             [self.poodleDog.layer removeAllAnimations];
                             [self.pugDog.layer removeAllAnimations];
                             [self.greyCat.layer removeAllAnimations];
                             [self.blackCat.layer removeAllAnimations];
                             [self.orangeCat.layer removeAllAnimations];
                             [self.yorkieDog.layer removeAllAnimations];
                             [self.greyStripeCat.layer removeAllAnimations];
                             self.greyStripeCat.alpha = 1;
                             self.yorkieDog.alpha = 1;
                             self.corgieDog.alpha = 1;
                             self.greyCat.alpha = 1;
                             self.pugDog.alpha = 1;
                             self.orangeCat.alpha = 1;
                             self.poodleDog.alpha = 1;
                             self.blackCat.alpha = 1;
                             self.yorkieYAxis.constant = -150;
                             self.greyCatYAxis.constant = -150;
                             self.blackCatYAxis.constant = -150;
                             self.orangeCatYAxis.constant = -150;
                             self.corgiYAxis.constant = -150;
                             self.poodleYAxis.constant = -150;
                             self.pugYAxis.constant = -150;
                             self.greyStripeYAxis.constant = -150;
                         }];
    }
}

#pragma mark GPS Logic

- (void)startLocationUpdatesWithCompletionBlock:(void (^)(void))completion {
    if (completion != nil) {
        [self.locationManager startUpdatingLocation];
        completion();
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.lastObject != nil) {
        self.weatherLocation = locations.lastObject;
    } else {
        self.weatherLocation = manager.location;
    }
    
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate: /*CLLocationCoordinate2DMake(40.5744, -73.9786)*/
     self.weatherLocation.coordinate
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                NSInteger indexOfLocality = [address.lines indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    return [(NSString *)([[obj objectForKey:@"types"] firstObject]) isEqualToString:@"locality"];
                                                }];
                                                
                                                NSInteger indexOfNeighborhood = [address.lines indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                                                    return [(NSString *)([[obj objectForKey:@"types"] firstObject]) isEqualToString:@"neighborhood"];
                                                }];
                                                NSString *locality;
                                                
                                                if (address.subLocality)
                                                    locality = address.subLocality;
                                                else
                                                    locality = address.locality;
                                                
                                                if (indexOfNeighborhood < [address.lines count])
                                                    
                                                    locality = [address.lines[indexOfNeighborhood] objectForKey:@"short_name"];
                                                if (indexOfLocality < [address.lines count] && [locality length] < 14) {
                                                    
                                                    locality = [address.lines[indexOfLocality] objectForKey:@"long_name"];
                                                }
                                                
                                                self.locationLabel.text = [NSString stringWithFormat:@"%@", locality];
                                            }
                                            else if (error) {
                                                NSLog(@"%@ %@", results, error.localizedDescription);
                                            }
                                        }
     
     ];
    
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


# pragma mark Setup Methods

- (void) setupView {
    self.sheepCloudsXAxis.constant = self.view.frame.size.width;
    
    self.hourSlider.maximumTrackTintColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.06];
    self.hourSlider.minimumTrackTintColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.9];
    
    self.frameHeight = self.view.frame.size.height;
    
    self.milkyWay.alpha = 0;
    self.skyView.alpha = 0;
    self.grayGradient.alpha = 0;
    
    self.greyCatYAxis.constant = -150;
    self.blackCatYAxis.constant = -150;
    self.orangeCatYAxis.constant = -150;
    self.corgiYAxis.constant = -150;
    self.poodleYAxis.constant = -150;
    self.pugYAxis.constant = -150;
    self.yorkieYAxis.constant = -150;
    self.greyStripeYAxis.constant = -150;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(2, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
