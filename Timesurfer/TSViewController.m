//
//  ViewController.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <Forecastr/Forecastr.h>

#import "TSViewController.h"
#import "TSWeatherData.h"

@interface TSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *weatherLocation;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, strong) Forecastr *forcastr;
@property (nonatomic, strong) NSDictionary *weatherDictionary;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, strong) NSString *weatherTemp;

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
}

- (void)viewDidAppear:(BOOL)animated{
    [self requestAlwaysAuth];
    [self.locationManager startMonitoringSignificantLocationChanges];
//    [self getCachedForecast];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
                                      //NSLog(@"JSON Response was: %@", JSON);
                                      
                                      self.weatherDictionary = JSON;
                                      
                                      TSWeatherData *weatherData = [[TSWeatherData alloc] initWithDictionary:self.weatherDictionary];
                                      
                                      NSNumber *currentTemp = self.weatherDictionary[@"currently"][@"temperature"];
                                      CGFloat currentTempFloat = currentTemp.floatValue;
                                      self.weatherTemp = [NSString stringWithFormat:@"%.f",currentTempFloat];
                                      self.temperatureLabel.text = self.weatherTemp;
                                      
                                      NSString *weatherIcon = self.weatherDictionary[@"currently"][@"icon"];
                                      NSLog(@"%@",weatherIcon);
                                      self.weatherImage.image = [UIImage imageNamed:weatherIcon];
                                      
                                  } failure:^(NSError *error, id response) {
                                      NSLog(@"Error while retrieving forecast: %@", [self.forcastr messageForError:error withResponse:response]);
                                  }];
}



-(void)requestAlwaysAuth{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied || status==kCLAuthorizationStatusRestricted || status==kCLAuthorizationStatusNotDetermined) {
        
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
        
    }else if (status==kCLAuthorizationStatusNotDetermined)
        
    {[self.locationManager requestAlwaysAuthorization];}
    
}

@end
