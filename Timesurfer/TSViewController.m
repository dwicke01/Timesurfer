#import <SceneKit/SceneKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Forecastr/Forecastr.h>

#import "TSViewController.h"
#import "TSSettingsViewController.h"
#import "TSWeatherManager.h"
#import "TSConstants.h"
#import "TSStarField.h"
#import "TSClouds.h"
#import "TSSheepClouds.h"
#import "TSSun.h"
#import "TSSlider.h"
#import "LMGeocoder.h"
#import "TSEventManager.h"
#import "TSToggleSettingsManager.h"

@import CoreLocation;

@interface TSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPrecip;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *calendarEventLabel;

@property (nonatomic, strong) SCNView *sceneView;
@property (weak, nonatomic) IBOutlet UIView *skyView;
@property (weak, nonatomic) IBOutlet UIView *dayTimeGradient;
@property (weak, nonatomic) IBOutlet UIView *grayGradient;
@property (weak, nonatomic) IBOutlet TSSun *sunView;
@property (weak, nonatomic) IBOutlet TSSheepClouds *sheepClouds;
@property (weak, nonatomic) IBOutlet TSClouds *clouds;
@property (weak, nonatomic) IBOutlet TSSlider *hourSlider;

@property (weak, nonatomic) IBOutlet UIImageView *helicopter;
@property (weak, nonatomic) IBOutlet UIImageView *airplane;
@property (weak, nonatomic) IBOutlet UIImageView *moonImage;
@property (weak, nonatomic) IBOutlet UIImageView *milkyWay;
@property (weak, nonatomic) IBOutlet UIImageView *yorkieDog;
@property (weak, nonatomic) IBOutlet UIImageView *greyCat;
@property (weak, nonatomic) IBOutlet UIImageView *blackCat;
@property (weak, nonatomic) IBOutlet UIImageView *orangeCat;
@property (weak, nonatomic) IBOutlet UIImageView *pugDog;
@property (weak, nonatomic) IBOutlet UIImageView *corgieDog;
@property (weak, nonatomic) IBOutlet UIImageView *poodleDog;
@property (weak, nonatomic) IBOutlet UIImageView *greyStripeCat;
@property (weak, nonatomic) IBOutlet UIImageView *squirrelLeft;
@property (weak, nonatomic) IBOutlet UIImageView *squirrelRight;
@property (weak, nonatomic) IBOutlet UIImageView *squirrelRightAcorn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *temperatureYAxis;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greyStripeYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squirrelYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squirrelXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squirrelRightYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squirrelRightXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squirrelRightAcornYAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *squirrelRightAcornXAxis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helicopterXAxis;

@property (nonatomic, assign) BOOL sheepInMotion;
@property (nonatomic, assign) BOOL randomizerInMotion;
@property (nonatomic, assign) BOOL animalsInMotion;
@property (nonatomic, assign) BOOL grayGradientInMotion;
@property (nonatomic, assign) BOOL temperatureInCelcius;

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat startPoint;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat hourOffset;

@property (nonatomic, strong) CLLocation *weatherLocation;

@property (nonatomic, strong) Forecastr *forcastr;
@property (nonatomic, strong) TSWeather *currentWeather;

@property (nonatomic, assign) NSUInteger animationCount;
@property (nonatomic, assign) NSUInteger loopCount;
@property (nonatomic, strong) NSTimer *animatedDayTimer;
@property (nonatomic, strong) NSTimer *sliderStoppedTimer;
@property (nonatomic, strong) NSDate *apiLastRequestTime;
@property (nonatomic, strong) NSString *todayShortDateUS;
@property (nonatomic, strong) NSString *todayShortDateUK;
@property (nonatomic, strong) NSString *tomorrowShortDateUS;
@property (nonatomic, strong) NSString *tomorrowShortDateUK;

@property (nonatomic, strong) TSEventManager *eventManager;

@property (nonatomic, strong) TSToggleSettingsManager *settingsManager;

@end

@implementation TSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    self.eventManager = [TSEventManager sharedEventManger];
    
    self.forcastr = [Forecastr sharedManager];
    self.forcastr.apiKey = FORCAST_KEY;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredForeground)
                                                 name:@"appEnteredForeground"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredBackground)
                                                 name:@"appEnteredBackground"
                                               object:nil];
    //self.settingsDictionary = [[NSMutableDictionary alloc] initWithObjects:@[@YES, @YES, @YES, @YES, @YES, @NO] forKeys:@[]];
    self.settingsManager = [[TSToggleSettingsManager alloc] init];
    
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestWhenInUseAuth];
    [self populateDateLabels];
    
    [self.locationManager startUpdatingLocation];
}

- (void)appEnteredBackground {

    [self animalStartingPositions];
    self.sheepInMotion = NO;
    self.animalsInMotion = NO;
    self.randomizerInMotion = NO;
}

- (void) appEnteredForeground {
    [self.locationManager startUpdatingLocation];
    
    if (arc4random_uniform(5) == 4) {
        UIImage *sliderThumb = [self imageWithImage: [UIImage imageNamed:@"Surf-Icon"] scaledToSize:CGSizeMake(40,40)];
        [self.hourSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
        
    } else {
        [self.hourSlider setThumbImage:nil forState:UIControlStateNormal];
    }
    [self populateDateLabels];
    [self requestWhenInUseAuth];
    [self getWeatherWithOverride:NO];
}

# pragma mark - API 

- (void) updateWeatherInfo {
    CGFloat currentTime = floor(self.hourSlider.value-self.hourOffset)/100;
    
//    if (currentTime >= 4) {
//        self.calendarEventLabel.text = @"";
//    } else {
    self.calendarEventLabel.text = [self.eventManager eventForHourAtIndex:currentTime];
//    }
    
    [self updateWeatherLabelsWithIndex:currentTime];
}

- (void) getWeatherWithOverride:(BOOL)override {

    self.latitude = self.weatherLocation.coordinate.latitude;
    self.longitude = self.weatherLocation.coordinate.longitude;
    
    if (self.latitude == 0 && self.longitude == 0) {
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    
    if (!self.weatherData || [self.weatherLocation distanceFromLocation:self.weatherData.location] > 8000 || fabs([self.apiLastRequestTime timeIntervalSinceNow])>1800 || override) {
        
        self.apiLastRequestTime = [NSDate date];
        
        [self.forcastr getForecastForLatitude:self.latitude
                                    longitude:self.longitude
                                         time:nil
                                   exclusions:nil
                                       extend:nil
                                      success:^(NSDictionary *JSON) {
                                          
                                          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                          NSString *documentsDirectory = [paths objectAtIndex:0];
                                          NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Latest_Weather"];
                                          
                                          [JSON writeToFile:filePath atomically:YES];
                                          
                                          [self createWeatherWithJSON:JSON];
                                          
                                          [self updateLocationNameWithLocation:self.weatherLocation];

                                      } failure:^(NSError *error, id response) {
//                                          NSLog(@"Error while retrieving forecast: %@", [self.forcastr messageForError:error withResponse:response]);
                                          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                          NSString *documentsDirectory = [paths objectAtIndex:0];
                                          NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Latest_Weather"];

                                          NSDictionary *JSON = [NSDictionary dictionaryWithContentsOfFile:filePath];
                                          [self createWeatherWithJSON:JSON];
                                      }];
    } else {
        [self updateWeatherInfo];
    }
}

- (void) createWeatherWithJSON:(NSDictionary *)JSON {
    self.weatherData = [[TSWeatherManager alloc] initWithDictionary:JSON];
    
    self.hourSlider.minimumValue = self.weatherData.startingHour * 100;
    self.hourSlider.maximumValue = 2400 + self.weatherData.startingHour * 100;
    self.hourSlider.value = self.hourSlider.minimumValue;
    self.hourOffset = self.hourSlider.minimumValue;
    
    self.clouds.weatherData = self.weatherData;
    
    [self updateWeatherInfo];
    [self startAnimatedDayTimer];
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
    
    if (currentTime >= 800 && currentTime <= 2100 && self.currentWeather.percentRainFloat < 50) {
        
        [self.sunView makeDisplayLinkIfNeeded];
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.sunXAxis.constant = 15 + z * ((currentTime-800)/900);
                             self.sunYAxis.constant = -40 * sin((M_PI * (self.sunXAxis.constant-50))/z)+40;
                             
                             [self.sunView layoutIfNeeded];
                         }];
        
    } else if (currentTime < 700) {
        self.sunXAxis.constant = 0;
        [self.sunView destroyDisplayLink];
    } else if (currentTime > 2100){
        self.sunXAxis.constant = z + x;
        [self.sunView destroyDisplayLink];
    } else {
        [self.sunView destroyDisplayLink];
    }
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
                             self.moonYAxis.constant = -40 * sin((M_PI * (self.moonXAxis.constant-50))/z)+80;
                             
                             [self.moonImage layoutIfNeeded];
                             
                         }];
        
    } else if (currentTime <= 800){
        
        [UIView animateWithDuration:.4
                         animations:^{
                             self.moonXAxis.constant = x + x * (currentTime/600);
                             self.moonYAxis.constant = -40 * sin((M_PI * (self.moonXAxis.constant-50))/z)+80;
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
        [UIView animateWithDuration:.5 animations:^{
            self.dayTimeGradient.alpha = alphaValue;
            self.grayGradient.alpha = 1 * ((self.currentWeather.percentRainFloat-40)/50);
        }];
        
    } else {
        
        if (self.grayGradient.alpha < 1) {
            
            self.dayTimeGradient.alpha = alphaValue;
            
        } else {
            self.dayTimeGradient.alpha = 0;
        }
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.grayGradient.alpha = 1 * ((self.currentWeather.percentRainFloat-40)/40);
        } completion:^(BOOL finished) {}];
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
            self.milkyWay.alpha = alphaValue-.75;
            
            self.cloudsXAxis.constant = 0;
            [self.clouds layoutIfNeeded];
        }];
    } else {
        
        self.skyView.alpha = alphaValue;
        self.milkyWay.alpha = alphaValue-.75;
        [self.clouds layoutIfNeeded];
    }
    
}

- (void) updateWeatherLabelsWithIndex:(NSUInteger)indexOfHour{
    TSWeather *weather = [self.weatherData weatherForHour:indexOfHour];
    
    if(self.currentWeather == weather) {
        [self showWeatherAnimations];
        [self removeAnimationsAndParticles];
        
    } else if (self.currentWeather != weather || self.currentWeather.currentHourInt == 0){
        
        self.currentWeather = weather;
        
        [UIView animateWithDuration:.5 animations:^{
            
            CGFloat nearestHour = floor((self.hourSlider.value - self.hourOffset)/100)*100;
            
            self.cloudsXAxis.constant = nearestHour/2400*(self.view.frame.size.width*-25) ;
            [self.clouds layoutIfNeeded];
        }];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        
        self.longDateLabel.hidden = NO;
        self.longDateLabel.alpha = 1;
        
        self.timeLabel.text = weather.currentDate;
        
        if (indexOfHour == 0 && !weather.sunRiseHour && !weather.sunSetHour) {
            self.timeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
        }
        
        [self updateTemperatureLabelUnits];
        
        if (weather.percentRainFloat >= 50) {
            self.percentPrecip.text = [NSString stringWithFormat:@"%@ ☂",weather.percentRainString];
        } else {
            self.percentPrecip.text = weather.percentRainString;
        }
    }

    [self showWeatherAnimations];
    [self removeAnimationsAndParticles];
    
    if ([self isKindOfClass:NSClassFromString(@"TodayViewController")]) {
        UIImageView *imageView = [self valueForKey:@"weatherImageView"];
        
        CGFloat aspectRatio = ((UIImage *)[weather weatherImage]).size.width / ((UIImage *)[weather weatherImage]).size.height ;
        
        imageView.image = [self imageWithImage:[weather weatherImage] scaledToSize:CGSizeMake(imageView.bounds.size.width, (imageView.bounds.size.width)/aspectRatio)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;//
    }
    
    [self updateGradient];
    [self updateSky];
    [self updateSun];
    [self updateMoon];
    [self easterEggTimer];
}

- (void) updateTemperatureLabelUnits {
    
    if (self.hourSlider.value > 2400) {
        
        if (self.temperatureInCelcius) {
            self.temperatureLabel.text = self.currentWeather.weatherTemperatureC;
            self.longDateLabel.text = self.tomorrowShortDateUK;
        } else {
            self.temperatureLabel.text = self.currentWeather.weatherTemperatureF;
            self.longDateLabel.text = self.tomorrowShortDateUS;
        }
        
    } else {
        if (self.temperatureInCelcius) {
            self.temperatureLabel.text = self.currentWeather.weatherTemperatureC;
            self.longDateLabel.text = self.todayShortDateUK;
        } else {
            self.temperatureLabel.text = self.currentWeather.weatherTemperatureF;
            self.longDateLabel.text = self.todayShortDateUS;
        }
    }
    
    if (self.currentWeather.sunSetHour) {
        self.sunriseLabel.alpha = 1;
        self.timeLabel.text = self.weatherData.sunSet;
        self.sunriseLabel.text = @"Sunset";
        
    } else if (self.currentWeather.sunRiseHour) {
        
        self.timeLabel.text = self.weatherData.sunRise;
        self.sunriseLabel.text = @"Sunrise";
        self.sunriseLabel.alpha = 1;
        
    } else {
        self.sunriseLabel.alpha = 0;
    }
}

- (void) populateDateLabels {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"EEEE, MMMM d"];
    
    self.todayShortDateUS = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[NSDate date]]];
    self.tomorrowShortDateUS = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24]]];
    
    [dateFormat setDateFormat:@"EEEE, d MMMM"];
    self.todayShortDateUK = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[NSDate date]]];
    self.tomorrowShortDateUK = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24]]];
}

- (IBAction)toggleTemperatureUnits:(id)sender {
    
    if (!self.temperatureInCelcius) {
        self.temperatureInCelcius = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tempInC"];
        
    } else {
        self.temperatureInCelcius = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tempInC"];
    }
    
    [self updateTemperatureLabelUnits];
}

#pragma mark Animations

- (IBAction)sliderChanged:(id)sender {
    [self updateWeatherInfo];
}

- (void) startAnimatedDayTimer {
    
    self.animatedDayTimer = [[NSTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:1.] interval:.000001 target:self selector:@selector(animateDay) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.animatedDayTimer forMode:NSDefaultRunLoopMode];
}

- (void) animateDay {
    
    self.loopCount++;
    
    CGFloat currentTime = 0.0;
    
    if (self.hourSlider.value > 2400) {
        currentTime = self.hourSlider.value-2400;
    } else {
        currentTime = self.hourSlider.value;
    }
    
    if (self.loopCount > 2400 || self.currentWeather.percentRainFloat >= 60) {
        [self.animatedDayTimer invalidate];
        self.animatedDayTimer = nil;
        
    } else {
        self.hourSlider.value += 4;
        [self updateWeatherInfo];
    }
}

- (void) easterEggTimer {
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
    
    [self showWeatherAnimations];
    
    if ((currentTime >= 2000 || currentTime < 500) && !self.sheepInMotion && !self.randomizerInMotion && !self.weatherData.rainChanceTodayAbove70) {
        
        [self sheepAnimation];
        
    } else if (!self.randomizerInMotion && !self.sheepInMotion && self.currentWeather.percentRainFloat < 60){
        
        [self animationRandomizer];
    }
    
    self.sliderStoppedTimer = nil;
}

- (void) animationRandomizer {

    switch (self.animationCount % 3) {
//    switch (0) {
        case 0:
            [self squirrelAnimation];
            break;
        case 1:
            [self planeAnimation];
            break;
        case 2:
            [self helicopterAnimation];
            break;
        default:
            break;
    }
        self.animationCount++;
}

- (void) sheepAnimation {

    if (self.settingsManager.toggleSheepAnimation && !self.weatherData.rainChanceTodayAbove50) {
        self.sheepInMotion = YES;

        
        [self.sheepClouds makeDisplayLinkIfNeeded];
        
        [UIView animateWithDuration:15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.sheepCloudsXAxis.constant = -self.view.frame.size.width;
            [self.sheepClouds layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            self.sheepCloudsXAxis.constant = self.view.frame.size.width;
            [self.sheepClouds destroyDisplayLink];
            self.sheepInMotion = NO;
        }];
    }
}

- (void) helicopterAnimation {
    if (self.settingsManager.toggleHelicopterAnimation) {
        self.randomizerInMotion = YES;
        [self.helicopter startAnimating];
        [UIView animateWithDuration:7 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.helicopterXAxis.constant = 600;
            [self.helicopter layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            self.helicopterXAxis.constant = 0;
            [self.helicopter layoutIfNeeded];
            [self.helicopter stopAnimating];
            self.randomizerInMotion = NO;
        }];
    }
}

- (void) planeAnimation {
    if (self.settingsManager.toggleAirplaneAnimation) {
        self.randomizerInMotion = YES;
        
        [UIView animateWithDuration:11 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.airplaneXAxis.constant = -575;
            [self.airplane layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            self.airplaneXAxis.constant = 0;
            [self.airplane layoutIfNeeded];
            self.randomizerInMotion = NO;
        }];
    }
}

- (void) squirrelAnimation {
    if (self.settingsManager.toggleSquirrelAnimation) {
        CGFloat SquirrelBeginningDuration = 0.25;
        CGFloat SquirrelEndingDuration = 0.8;
        CGFloat SquirrelDampening = 0.4;
        
        self.randomizerInMotion = YES;
        
        [UIView animateWithDuration:SquirrelBeginningDuration
                              delay:0
             usingSpringWithDamping:SquirrelDampening
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             self.squirrelXAxis.constant = 50;
                             self.squirrelYAxis.constant = -110;
                             [self.squirrelLeft layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:SquirrelBeginningDuration
                              delay:0.2
             usingSpringWithDamping:SquirrelDampening
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             self.squirrelRightXAxis.constant = -50;
                             self.squirrelRightYAxis.constant = -170;
                             [self.squirrelRight layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:SquirrelBeginningDuration
                              delay:0.3
             usingSpringWithDamping:SquirrelDampening
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             self.squirrelRightAcornXAxis.constant = -50;
                             self.squirrelRightAcornYAxis.constant = -310;
                             [self.squirrelRightAcorn layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:SquirrelEndingDuration
                              delay:3
             usingSpringWithDamping:SquirrelDampening
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             self.squirrelRightXAxis.constant = 0;
                             self.squirrelRightYAxis.constant = -160;
                             [self.squirrelRight layoutIfNeeded];
                         } completion:^(BOOL finished) {}];

        [UIView animateWithDuration:SquirrelEndingDuration
                              delay:3.1
             usingSpringWithDamping:SquirrelDampening
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             self.squirrelXAxis.constant = 0;
                             self.squirrelYAxis.constant = -100;
                             [self.squirrelLeft layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:SquirrelEndingDuration
                              delay:3.2
             usingSpringWithDamping:SquirrelDampening
              initialSpringVelocity:1
                            options:0
                         animations:^{
                             self.squirrelRightAcornXAxis.constant = 0;
                             self.squirrelRightAcornYAxis.constant = -300;
                             [self.squirrelRightAcorn layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.randomizerInMotion = NO;
                         }];
    }
}

- (void) showWeatherAnimations {
    
    if (self.currentWeather.percentRainFloat >= 80 && !self.animalsInMotion && self.settingsManager.toggleCatsAndDogsAnimation) {

        [UIView animateWithDuration:1 animations:^{
            self.dayTimeGradient.alpha = 0;
        }];
        
        self.animalsInMotion = YES;
        NSUInteger constant = 1100;
        NSUInteger duration = 7;
        
        [self showParticleSystem];
        
        [UIView animateWithDuration:duration
                              delay:0.05  // Prevent starting simultaneously with particle system
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.greyCatYAxis.constant = constant;
                             [self.greyCat layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:.8
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.corgiYAxis.constant = constant;
                             [self.corgieDog layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:1.5
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.blackCatYAxis.constant = constant;
                             [self.blackCat layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:2.7
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.poodleYAxis.constant = constant;
                             [self.poodleDog layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:3.5
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.pugYAxis.constant = constant;
                             [self.pugDog layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:4.2
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.orangeCatYAxis.constant = constant;
                             [self.orangeCat layoutIfNeeded];
                           } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:5
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.greyStripeYAxis.constant = constant;
                             [self.greyStripeCat layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
        [UIView animateWithDuration:duration
                              delay:6
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                         animations:^{
                             self.yorkieYAxis.constant = constant;
                             [self.yorkieDog layoutIfNeeded];
                         } completion:^(BOOL finished) {}];
        
    } else if (self.sceneView.alpha == 0 && self.currentWeather.percentRainFloat >= 60) {
        [self showParticleSystem];
    }
}

- (void) createParticleSystem {
    
    if (self.sceneView != nil) {
        return;
    }
    
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"DefaultRain2" inDirectory:nil];
    
    SCNScene *scene = [SCNScene new];
    
    [scene addParticleSystem:particleSystem withTransform:SCNMatrix4Identity];
    scene.background.contents = nil;
    
    self.sceneView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.sceneView.backgroundColor = [UIColor clearColor];
    self.sceneView.scene = scene;
    
    [self.view insertSubview:self.sceneView aboveSubview:self.grayGradient];
    
    self.sceneView.alpha = 0;
}

- (void) showParticleSystem {
    
    if (self.sceneView) {
        return;
    }
    
    [self createParticleSystem];
    [UIView animateWithDuration:1
                          delay:1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.sceneView.alpha = 1;
                         
                     } completion:^(BOOL finished) {}];
}

- (void) hideParticleSystem {
    
    if (self.sceneView.alpha > 0) {
        
        [UIView animateWithDuration:.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.sceneView.alpha = 0;
                         } completion:^(BOOL finished) {
                             
                             if (finished && self.sceneView.alpha == 0) {
                                 [self removeParticleSystem];
                             }
                         }];
    }
}

- (void) removeParticleSystem {
    [self.sceneView removeFromSuperview];
    self.sceneView = nil;
}

- (void) removeAnimationsAndParticles {
    
    if (self.currentWeather.percentRainFloat < 80 && self.animalsInMotion) {
        self.animalsInMotion = NO;
  
        [UIView animateWithDuration:.4
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

                             [self animalStartingPositions];

                         }];
    }
    
    if (self.currentWeather.percentRainFloat < 60) {
        [self hideParticleSystem];
    }
}

#pragma mark GPS Logic


- (void) changeCities {
    
    UIAlertController *locationAlert = [UIAlertController alertControllerWithTitle:@"Enter Location" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [locationAlert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter City or Zip";
         textField.keyboardAppearance = UIKeyboardAppearanceDark;
     }];
    
    UIAlertAction *triggerChange = [UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UITextField *textField = locationAlert.textFields[0];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder geocodeAddressString:textField.text completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            
            self.weatherLocation = location;
            
            [self getWeatherWithOverride:YES];

        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [locationAlert addAction:cancel];
    [locationAlert addAction:triggerChange];

    [self presentViewController:locationAlert animated:NO completion:nil];
}

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
    
    [self getWeatherWithOverride:NO];
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

- (void) updateLocationNameWithLocation:(CLLocation *)coords {
    
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate: coords.coordinate
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
                                                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", locality] forKey:@"Last_Location"];
                                            }
                                            else if (error) {
                                                //                                                NSLog(@"%@ %@", results, error.localizedDescription);
                                                self.locationLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Last_Location"];
                                            }
                                        }
     ];

}

# pragma mark Setup Methods

- (void) setupView {
    self.sheepCloudsXAxis.constant = self.view.frame.size.width;
    self.temperatureInCelcius = [[NSUserDefaults standardUserDefaults] boolForKey:@"tempInC"];
    
    self.hourSlider.maximumTrackTintColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.06];
    self.hourSlider.minimumTrackTintColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.9];
    self.hourSlider.contentScaleFactor = 2;
    
    [self animalStartingPositions];
    [self setupTapGestureRecognizer];
    
    self.frameHeight = self.view.frame.size.height;
    
    self.milkyWay.alpha = 0;
    self.skyView.alpha = 0;
    self.grayGradient.alpha = 0;
    
    self.helicopter.animationImages = @[[UIImage imageNamed:@"Helicopter1"],
                                        [UIImage imageNamed:@"Helicopter2"]];
    self.helicopter.animationDuration = 0.1;
    
    [NSUserDefaults standardUserDefaults];
    
    if (self.view.frame.size.width == 320) {
        self.longDateLabel.font = [self.longDateLabel.font fontWithSize:34];
        NSLog(@"running labels");
        self.temperatureLabel.font = [self.temperatureLabel.font fontWithSize:100];
        self.locationLabel.font = [self.locationLabel.font fontWithSize:34];
        self.timeLabel.font = [self.timeLabel.font fontWithSize:42];
        self.percentPrecip.font = [self.percentPrecip.font fontWithSize:34];
        self.calendarEventLabel.font = [self.percentPrecip.font fontWithSize:16];
        self.temperatureYAxis.constant = 14;
    }
}

- (void) animalStartingPositions {
    [self.corgieDog.layer removeAllAnimations];
    [self.poodleDog.layer removeAllAnimations];
    [self.pugDog.layer removeAllAnimations];
    [self.greyCat.layer removeAllAnimations];
    [self.blackCat.layer removeAllAnimations];
    [self.orangeCat.layer removeAllAnimations];
    [self.yorkieDog.layer removeAllAnimations];
    [self.greyStripeCat.layer removeAllAnimations];
    
    self.greyCatYAxis.constant = -150;
    self.blackCatYAxis.constant = -150;
    self.orangeCatYAxis.constant = -150;
    self.corgiYAxis.constant = -150;
    self.poodleYAxis.constant = -150;
    self.pugYAxis.constant = -150;
    self.yorkieYAxis.constant = -150;
    self.greyStripeYAxis.constant = -150;

    self.greyStripeCat.alpha = 1;
    self.yorkieDog.alpha = 1;
    self.corgieDog.alpha = 1;
    self.greyCat.alpha = 1;
    self.pugDog.alpha = 1;
    self.orangeCat.alpha = 1;
    self.poodleDog.alpha = 1;
    self.blackCat.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) setupTapGestureRecognizer {
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCities)];
    
    [self.locationLabel addGestureRecognizer:recognizer];
    
    self.locationLabel.userInteractionEnabled = YES;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SettingsSegueID"]) {
        TSSettingsViewController *vc = segue.destinationViewController;
        vc.settingsManager = self.settingsManager;
    }
}

@end
