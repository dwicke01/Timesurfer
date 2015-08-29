
#import <Foundation/Foundation.h>

@interface TSToggleSettingsManager : NSObject

@property (nonatomic, assign) BOOL toggleAllAnimations;
@property (nonatomic, assign) BOOL toggleSheepAnimation;
@property (nonatomic, assign) BOOL toggleCatsAndDogsAnimation;
@property (nonatomic, assign) BOOL toggleHelicopterAnimation;
@property (nonatomic, assign) BOOL toggleAirplaneAnimation;
@property (nonatomic, assign) BOOL toggleSquirrelAnimation;
@property (nonatomic, assign) BOOL toggleGoogleCalendar;

-(void)saveEverything;

@end
