
#import "TSToggleSettingsManager.h"

@interface TSToggleSettingsManager ()



@end

@implementation TSToggleSettingsManager

-(instancetype)init {
    if (self = [super init]) {
        _toggleAirplaneAnimation = [[NSUserDefaults standardUserDefaults] boolForKey:@"airplaneAnimation"];
        _toggleAllAnimations = [[NSUserDefaults standardUserDefaults] boolForKey:@"allAnimations"];
        _toggleCatsAndDogsAnimation = [[NSUserDefaults standardUserDefaults] boolForKey:@"catsAndDogsAnimation"];
        _toggleHelicopterAnimation = [[NSUserDefaults standardUserDefaults] boolForKey:@"helicopterAnimation"];
        _toggleSheepAnimation = [[NSUserDefaults standardUserDefaults] boolForKey:@"sheepAnimation"];
        _toggleSquirrelAnimation = [[NSUserDefaults standardUserDefaults] boolForKey:@"squirrelAnimation"];
        _toggleGoogleCalendar = [[NSUserDefaults standardUserDefaults] boolForKey:@"googleCalendar"];
    }
    return self;
}

-(void)saveEverything {
    [[NSUserDefaults standardUserDefaults] setBool:_toggleAirplaneAnimation forKey:@"airplaneAnimation"];
    [[NSUserDefaults standardUserDefaults] setBool:_toggleAllAnimations forKey:@"allAnimations"];
    [[NSUserDefaults standardUserDefaults] setBool:_toggleCatsAndDogsAnimation forKey:@"catsAndDogsAnimation"];
    [[NSUserDefaults standardUserDefaults] setBool:_toggleHelicopterAnimation forKey:@"helicopterAnimation"];
    [[NSUserDefaults standardUserDefaults] setBool:_toggleSheepAnimation forKey:@"sheepAnimation"];
    [[NSUserDefaults standardUserDefaults] setBool:_toggleSquirrelAnimation forKey:@"squirrelAnimation"];
    [[NSUserDefaults standardUserDefaults] setBool:_toggleGoogleCalendar forKey:@"googleCalendar"];
}

@end