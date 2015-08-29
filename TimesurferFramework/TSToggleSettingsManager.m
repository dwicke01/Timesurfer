
#import "TSToggleSettingsManager.h"

@implementation TSToggleSettingsManager

-(instancetype)init {
    if (self = [super init]) {
        _toggleAirplaneAnimation = YES;
        _toggleAllAnimations = YES;
        _toggleCatsAndDogsAnimation = YES;
        _toggleHelicopterAnimation = YES;
        _toggleSheepAnimation = YES;
        _toggleSquirrelAnimation = YES;
        _toggleGoogleCalendar = YES;
    }
    return self;
}

@end
