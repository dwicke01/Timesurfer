//
//  ViewController.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <Forecastr/Forecastr.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TSViewController.h"
#import "TSWeatherData.h"
#import "TSSkyView.h"

@interface TSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISlider *hourSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunRiseSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPrecip;
@property (weak, nonatomic) IBOutlet TSSkyView *skyView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *weatherLocation;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) Forecastr *forcastr;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, strong) TSWeatherData *weatherData;

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
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

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
                                     // NSLog(@"JSON Response was: %@", JSON);
                                      
                                      _weatherData = [[TSWeatherData alloc] initWithDictionary:JSON];
                                      
                                      [self updateWeather:0];
                                      
                                  } failure:^(NSError *error, id response) {
                                      NSLog(@"Error while retrieving forecast: %@", [self.forcastr messageForError:error withResponse:response]);
                                  }];
}

- (void) updateWeather:(NSUInteger)hour{
    TSWeather *weather = [self.weatherData weatherForHour:hour];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    if (weather.sunSetHour) {
        self.sunRiseSetLabel.hidden = NO;
        self.sunRiseSetLabel.text = [NSString stringWithFormat:@"Sunset: %@",self.weatherData.sunSet];
        
    } else if (weather.sunRiseHour) {
        self.sunRiseSetLabel.hidden = NO;
        self.sunRiseSetLabel.text = [NSString stringWithFormat:@"Sunrise: %@",self.weatherData.sunRise];
        
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


//        NSUInteger minutes = (self.hourSlider.value -floor(self.hourSlider.value))*60;
//        if (minutes >= 30) {
//            minutes = 30;
//        } else {
//            minutes = 0;
//        }
//        NSDate *exactDate = [dateTime dateByAddingTimeInterval:minutes*60];
